<?php

namespace App\Filters;

use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use CodeIgniter\Filters\FilterInterface;

class AdminOrVendedorFilter implements FilterInterface
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $auth = service('auth');
        $auth->startSession();
        $user = $auth->user();

        if (! $user) {
            return redirect()->to('/login');
        }

        if (! ($user->inGroup('admin') || $user->inGroup('vendedor'))) {
            return redirect()->to('/')->with('error', 'Acceso no autorizado');
        }
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
        // no-op
    }
}
