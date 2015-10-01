From: Guillaume Nault <g.nault@alphalink.fr>
Subject: Re: [libmnl] Creating netlink socket with SOCK_CLOEXEC flag
Date: Thu, 1 Oct 2015 20:50:59 +0200
Message-ID: <20151001185059.GD2911@alphalink.fr>
References: <20151001161604.GC2911@alphalink.fr>
 <20151001165005.GA2107@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:59892 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756621AbbJASvF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 14:51:05 -0400
Content-Disposition: inline
In-Reply-To: <20151001165005.GA2107@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 01, 2015 at 06:50:05PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 01, 2015 at 06:16:04PM +0200, Guillaume Nault wrote:
> > Hi,
> > 
> > I'm looking at how libmnl could be used with CLOEXEC netlink sockets.
> > Of course, one can use the
> >    nl = mnl_socket_open();
> >    fd = mnl_socket_get_fd(nl);
> >    fcntl(fd, F_SETFD, O_CLOEXEC);
> > sequence, but this is racy in multi-threaded programs, where another
> > thread could fork()/execve() between the mnl_socket_open() and the
> > fcntl() calls. Applying the CLOEXEC flag at socket creation closes this
> > issue.
> > 
> > There are three different approaches I can think of:
> >   1- Make mnl_socket_open() unconditionally add the SOCK_CLOEXEC flag in
> >      its socket() call.
> >   2- Define mnl_socket_open2(), similar to mnl_socket_open() but with an
> >      additional flags parameter that would be passed to socket().
> >   3- Tell user to create its netlink socket with the required flags and
> >      use it with mnl_socket_fdopen().
> > 
> > Solution #1 would provide safe default for all users, but that'd be an
> > ABI change. Also decision would need to be made wrt. platforms not
> > handling SOCK_CLOEXEC.
> > 
> > Solution #2 is more generic and allows all SOCK_* flags defined by the
> > plateform. But it's a bit more inelegant and exports yet another function
> > to allocate an mnl socket.
> 
> I'd suggest you add mnl_socket_open2().

Ok, will do.
