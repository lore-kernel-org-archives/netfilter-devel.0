From: Guillaume Nault <g.nault@alphalink.fr>
Subject: [libmnl] Creating netlink socket with SOCK_CLOEXEC flag
Date: Thu, 1 Oct 2015 18:16:04 +0200
Message-ID: <20151001161604.GC2911@alphalink.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zimbra.alphalink.fr ([217.15.80.77]:55342 "EHLO
	mail-2-cbv2.admin.alphalink.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752232AbbJAQYq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 12:24:46 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 638702B52045
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2015 18:16:08 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id xRccuYQh6GiS for <netfilter-devel@vger.kernel.org>;
	Thu,  1 Oct 2015 18:16:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id C09252B5217F
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2015 18:16:07 +0200 (CEST)
Received: from mail-2-cbv2.admin.alphalink.fr ([127.0.0.1])
	by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id LtwpYja7PddB for <netfilter-devel@vger.kernel.org>;
	Thu,  1 Oct 2015 18:16:07 +0200 (CEST)
Received: from dev-10-pornic.admin.alphalink.fr (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
	by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 96A572B52045
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2015 18:16:07 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm looking at how libmnl could be used with CLOEXEC netlink sockets.
Of course, one can use the
   nl = mnl_socket_open();
   fd = mnl_socket_get_fd(nl);
   fcntl(fd, F_SETFD, O_CLOEXEC);
sequence, but this is racy in multi-threaded programs, where another
thread could fork()/execve() between the mnl_socket_open() and the
fcntl() calls. Applying the CLOEXEC flag at socket creation closes this
issue.

There are three different approaches I can think of:
  1- Make mnl_socket_open() unconditionally add the SOCK_CLOEXEC flag in
     its socket() call.
  2- Define mnl_socket_open2(), similar to mnl_socket_open() but with an
     additional flags parameter that would be passed to socket().
  3- Tell user to create its netlink socket with the required flags and
     use it with mnl_socket_fdopen().

Solution #1 would provide safe default for all users, but that'd be an
ABI change. Also decision would need to be made wrt. platforms not
handling SOCK_CLOEXEC.

Solution #2 is more generic and allows all SOCK_* flags defined by the
plateform. But it's a bit more inelegant and exports yet another function
to allocate an mnl socket.

Solution #3 doesn't require any libmnl code update, but isn't (yet?) part
of any libmnl release. It also makes mnl socket creation not that well
integrated in libmnl.

Is any of these solutions acceptable? Any other idea on how to guarantee
race free application of the CLOEXEC flag to libmnl sockets?


Regards,

Guillaume
