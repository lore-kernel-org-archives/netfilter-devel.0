From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] iptables: link libxtables against libnetfilter_conntrack
Date: Tue, 13 Aug 2013 17:32:34 +0200
Message-ID: <20130813153234.GL29345@breakpoint.cc>
References: <1376399723-9967-1-git-send-email-gustavo@zacarias.com.ar>
 <20130813135932.GJ29345@breakpoint.cc>
 <520A4084.200@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:6672 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757619Ab3HMPcf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:32:35 -0400
Content-Disposition: inline
In-Reply-To: <520A4084.200@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gustavo Zacarias <gustavo@zacarias.com.ar> wrote:
> On 08/13/2013 10:59 AM, Florian Westphal wrote:
> 
> > Only with --enable-static, right?
> > Can you make it conditional on ENABLE_STATIC, like this?
> 
> Not really, it's failing for a dynamic build as well, remember binutils
> 2.22+ defaults to --no-copy-dt-needed (it's patched away in many
> distributions to avoid the general package build breakage).
> It's failing for me on a buildroot cross build which doesn't patch binutils.

I can't reproduce it using ld 2.23.1, even with "-Wl,--no-copy-dt-needed-entries".

Why does libxtables depend on lnf-conntrack?  And why don't you need to add
libm explicitly?

> -DALL_INCLUSIVE -DENABLE_IPV4 -DENABLE_IPV6 -pipe -Os -o xtables-multi
[..]
> ../extensions/libext.a(libxt_connlabel.o): In function `connlabel_get_name':
> libxt_connlabel.c:(.text+0xe): undefined reference to
> `nfct_labelmap_get_name'
> ../extensions/libext.a(libxt_connlabel.o): In function `connlabel_mt_parse':
> libxt_connlabel.c:(.text+0x6a): undefined reference to
> `nfct_labelmap_get_bit'
> ../extensions/libext.a(libxt_connlabel.o): In function
> `libxt_connlabel_init':
> libxt_connlabel.c:(.text+0x1ab): undefined reference to `nfct_labelmap_new'
> collect2: error: ld returned 1 exit status
> make[3]: *** [xtables-multi] Error 1

Yes, but that is with --enable-static.

The Makefile handles it correctly for statistics and rateest extensions
(it adds -lm) but not for the connlabel extension.
