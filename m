From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libmnl] Creating netlink socket with SOCK_CLOEXEC flag
Date: Thu, 1 Oct 2015 18:50:05 +0200
Message-ID: <20151001165005.GA2107@salvia>
References: <20151001161604.GC2911@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guillaume Nault <g.nault@alphalink.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39832 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbbJAQnL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 12:43:11 -0400
Content-Disposition: inline
In-Reply-To: <20151001161604.GC2911@alphalink.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 01, 2015 at 06:16:04PM +0200, Guillaume Nault wrote:
> Hi,
> 
> I'm looking at how libmnl could be used with CLOEXEC netlink sockets.
> Of course, one can use the
>    nl = mnl_socket_open();
>    fd = mnl_socket_get_fd(nl);
>    fcntl(fd, F_SETFD, O_CLOEXEC);
> sequence, but this is racy in multi-threaded programs, where another
> thread could fork()/execve() between the mnl_socket_open() and the
> fcntl() calls. Applying the CLOEXEC flag at socket creation closes this
> issue.
> 
> There are three different approaches I can think of:
>   1- Make mnl_socket_open() unconditionally add the SOCK_CLOEXEC flag in
>      its socket() call.
>   2- Define mnl_socket_open2(), similar to mnl_socket_open() but with an
>      additional flags parameter that would be passed to socket().
>   3- Tell user to create its netlink socket with the required flags and
>      use it with mnl_socket_fdopen().
> 
> Solution #1 would provide safe default for all users, but that'd be an
> ABI change. Also decision would need to be made wrt. platforms not
> handling SOCK_CLOEXEC.
> 
> Solution #2 is more generic and allows all SOCK_* flags defined by the
> plateform. But it's a bit more inelegant and exports yet another function
> to allocate an mnl socket.

I'd suggest you add mnl_socket_open2().
