From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/6] build: also use libtool for install stage
Date: Wed, 6 Mar 2013 00:16:33 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1303060009350.32082@nerf07.vanv.qr>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de> <1359381586-11940-2-git-send-email-jengelh@inai.de> <20130205033007.GA20407@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58754 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab3CEXQf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 18:16:35 -0500
In-Reply-To: <20130205033007.GA20407@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2013-02-05 04:30, Pablo Neira Ayuso wrote:

>On Mon, Jan 28, 2013 at 02:59:41PM +0100, Jan Engelhardt wrote:
>> The just-built library has DT_RPATH entries to be runnable from
>> whereever it is. If we just install that, the distro build systems
>> will throw warnings like
>> 
>> 	(Open Build Service) ERROR: RPATH
>> 	"/home/abuild/rpmbuild/BUILD/iptables-1.4.17a/libxtables/.libs"
>> 	on /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.17a-0.x86_64/usr/lib64/xtables/libxt_unclean.so
>> 	is not allowed
>> 
>> These RPATH entries are indeed undesired for libraries is in a system
>> location, which is why libtool produces another copy of the library on
>> installation. The makefile however missed using libtool during
>> installation (introduced with commit v1.4.17-1-g68e77a2).
>> This patch now resolves this.
>> 
>> There will be extra "warnings" emitted by libtool during `make install`,
>> like:
>> 
>> 	libtool: install: warning: relinking "libxt_AUDIT.la"
>> 
>> This is normal (and unfixable)
>
>I prefer that distros live with that warning.

It is not just a warning that distros have to face. It's a complete
abort of the build.

>Users will be annoyed by that warning for sure. 
   
No they won't. They know libtool, they know what to expect.
But whatever, I can add --no-warn, at the expensive of people
who like to know what is going on.
