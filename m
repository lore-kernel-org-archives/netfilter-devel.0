From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Mon, 19 Jan 2015 15:17:59 +0100
Message-ID: <20150119141759.GB31569@gardel-login>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kernel@linuxace.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:56427 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbASOSC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:18:02 -0500
Content-Disposition: inline
In-Reply-To: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 18.01.15 22:13, Pablo Neira Ayuso (pablo@netfilter.org) wrote:

> Abstract unix sockets cannot be used to synchronize several concurrent
> instances of iptables since an unpriviledged process can create them and
> prevent the legitimate iptables instance from running.
> 
> This patch introduces a semaphore that is identified by the path to the
> iptables binary, it also relies on SEM_UNDO so the kernel performs the
> up() operation at process exit to avoid races with signals. This also
> avoid file locks that require a writable filesystem.

Please, don't use SysV IPC for any new code, it's the worst
choice. (the token API is already such a desaster!) The API is awful,
and dated. At least use the POSIX APIs instead.

I'd really recommend using BSD file locks on a file in /run though,
they have the nicest semantics of all, and are supported on Linux
since a long time.

Lennart

-- 
Lennart Poettering, Red Hat
