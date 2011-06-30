From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Suggestion required in extending xt_RAWNAT.c to handle ICMP
 messages
Date: Thu, 30 Jun 2011 13:48:36 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106301347550.27062@frira.zrqbmnf.qr>
References: <9A920612ACA0144FBB2F8D874DA1EC6903E149C0@SGSIEXC017.nsn-intra.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "G A, Pramodh (NSN - IN/Bangalore)" <pramodh.g_a@nsn.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:37340 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab1F3Lsi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:48:38 -0400
In-Reply-To: <9A920612ACA0144FBB2F8D874DA1EC6903E149C0@SGSIEXC017.nsn-intra.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-06-28 07:42, G A, Pramodh (NSN - IN/Bangalore) wrote:

>
>
> Hi 
>
>	1. Currently xt_RAWNAT.c handle only tcp and udp data based on
>the iptables raw nat rules.
>	      I am extending Xt_RAWNAT.c to handle IMP messages .
>        
>	2. please find the test setup attached.

First, make a patch so that people can see what actually changed.
