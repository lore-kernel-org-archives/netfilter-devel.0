From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] ip[6]_tables.c: remove some inlines
Date: Mon, 31 Dec 2007 17:55:02 +0000
Message-ID: <200712311755.02578.vda.linux@googlemail.com>
References: <200712161247.53986.vda.linux@googlemail.com> <200712311643.41946.vda.linux@googlemail.com> <47792032.3020609@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:42300 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXLaRzJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:55:09 -0500
Received: by ug-out-1314.google.com with SMTP id z38so2312727ugc.16
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Dec 2007 09:55:08 -0800 (PST)
In-Reply-To: <47792032.3020609@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 31 December 2007 17:00, Patrick McHardy wrote:
> Denys Vlasenko wrote:
> > ip[6]_tables.c seem to abuse inline.
> >
> > This patch removes inlines except those which are used
> > by packet matching code and thus are performance-critical.
> >   
> 
> Some people also consider the ruleset replacement path performance
> critical, but overall I agree with your patch. I'm travelling currently
> though so it will take a few days until I'll apply it.
> 
> Do you have some numbers that show the actual difference these
> changes make?

Before:

$ size */*/*/ip*tables*.o
   text    data     bss     dec     hex filename
   6402     500      16    6918    1b06 net/ipv4/netfilter/ip_tables.o
   7130     500      16    7646    1dde net/ipv6/netfilter/ip6_tables.o

After:

$ size */*/*/ip*tables*.o
   text    data     bss     dec     hex filename
   6307     500      16    6823    1aa7 net/ipv4/netfilter/ip_tables.o
   7010     500      16    7526    1d66 net/ipv6/netfilter/ip6_tables.o

--
vda
