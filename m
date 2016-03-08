From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] configure: Show support for connlabel
Date: Tue, 8 Mar 2016 14:54:23 +0100
Message-ID: <20160308135423.GA10602@salvia>
References: <20160307091447.GA10194@gmail.com>
 <20160307140913.GA27599@salvia>
 <CAKHNQQEp7uV+afTfZ73k6srRQyj1ks_dsWYsbu0N_bWzsoNd-Q@mail.gmail.com>
 <20160307175646.GA30910@salvia>
 <20160307180044.GA4134@salvia>
 <CAKHNQQFEtTkdrT9+f1i2XSG8+nk7ivCZz7bJcJm4tfbtGeCJtw@mail.gmail.com>
 <20160308133758.GA5764@salvia>
 <alpine.LSU.2.20.1603081441060.13514@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shivani Bhardwaj <shivanib134@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932139AbcCHNyc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 08:54:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B4DD013C0E4
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:54:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A4254DA388
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:54:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0430EDA388
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:54:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1603081441060.13514@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2016 at 02:47:13PM +0100, Jan Engelhardt wrote:
> 
> On Tuesday 2016-03-08 14:37, Pablo Neira Ayuso wrote:
> >>>> Those are the userspace bits for the old ip_queue support that was
> >>>> removed years ago, since NFQUEUE superseded for many years.
> >>>> You can still cd iptables/libipq and type 'make' to compile the
> >>>> this small userspace library since we have to keep new iptables
> >>>> releases running with old kernels.
> >>>
> >>> This is always compiling libipq even with --disable-libipq, this looks
> >>> like a bug in our build infrastructure.
> 
> If you manually and intentionally chdir to libipq and attempt to built it, why
> forbid it? Having "if ENABLE_LIBIPQ" in the toplevel Makefile.am seems
> sufficient.

That top level "if ENABLE_LIBIPQ" seems fine, I overlooked this.

> AS_HELP_STRING([--enable-libipq], [Build and install libipq])
> in configure.ac is also right, since ipq is build-disabled by default.
> 
> >> Yes. Also, I see that devel should have --disable-devel instead of
> >> --enable-devel option and the appropriate functionality associated
> >> with it. Please correct me if I am wrong here.
> 
> The help texts:
> AS_HELP_STRING([--enable-devel], [Install Xtables development headers])
> should indeed read
> AS_HELP_STRING([--disable-devel], [Avoid installation of Xtables development headers])
> because headers are build-*enabled* by default.
> 
> But the actual option parsing (--enable-devel, --enable-devel=no,
> --disable-devel) that AC_ARG_ENABLE provides needs no change AFAICS.

Right, this is also controled via top level Makefile.am.

@Shivani, please focus on improving connlabel integration into our
configure thing.
