From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH iptables] iptables: use flock() instead of abstract unix
 sockets
Date: Mon, 19 Jan 2015 19:36:20 +0100
Message-ID: <20150119183620.GA32042@gardel-login>
References: <1421690957-11279-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kernel@linuxace.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:57168 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbASSgX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:36:23 -0500
Content-Disposition: inline
In-Reply-To: <1421690957-11279-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 19.01.15 19:09, Pablo Neira Ayuso (pablo@netfilter.org) wrote:

> Abstract unix sockets cannot be used to synchronize several concurrent
> instances of iptables since an unpriviledged process can create them and
> prevent the legitimate iptables instance from running.
> 
> Use flock() and /run instead as suggested by Lennart Poettering.

Looks OK. Of course, it's a bit nasty to do the sleep() loop, but
there is no time-limited version of flock(), hence doing the sleep()
loop is kinda necessary, unless one wants to use SIGARLM, but that's
awful to do without races...

Hence, looks OK to me.

A minor optimization might be to move the lock file into its own
subdir /run/iptables/ or so, but it's OK if you don't.

Lennart

-- 
Lennart Poettering, Red Hat
