From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/6] build: also use libtool for install stage
Date: Tue, 5 Feb 2013 04:30:07 +0100
Message-ID: <20130205033007.GA20407@localhost>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de>
 <1359381586-11940-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:55111 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755566Ab3BEDaN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Feb 2013 22:30:13 -0500
Content-Disposition: inline
In-Reply-To: <1359381586-11940-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 28, 2013 at 02:59:41PM +0100, Jan Engelhardt wrote:
> The just-built library has DT_RPATH entries to be runnable from
> whereever it is. If we just install that, the distro build systems
> will throw warnings like
> 
> 	(Open Build Service) ERROR: RPATH
> 	"/home/abuild/rpmbuild/BUILD/iptables-1.4.17a/libxtables/.libs"
> 	on /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.17a-0.x86_64/usr/lib64/xtables/libxt_unclean.so
> 	is not allowed
> 
> These RPATH entries are indeed undesired for libraries is in a system
> location, which is why libtool produces another copy of the library on
> installation. The makefile however missed using libtool during
> installation (introduced with commit v1.4.17-1-g68e77a2).
> This patch now resolves this.
> 
> There will be extra "warnings" emitted by libtool during `make install`,
> like:
> 
> 	libtool: install: warning: relinking "libxt_AUDIT.la"
> 
> This is normal (and unfixable)

I prefer that distros live with that warning. Users will be annoyed by
that warning for sure.
