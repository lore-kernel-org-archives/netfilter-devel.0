From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte counters
 for a specific rule using iptables/ip6tables
Date: Wed, 19 Aug 2009 22:41:07 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908192232020.9285@fbirervta.pbzchgretzou.qr>
References: <23915168.171071250704593343.JavaMail.root@tahiti.vyatta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Mohit Mehta <mohit.mehta@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52270 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZHSUlI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:41:08 -0400
In-Reply-To: <23915168.171071250704593343.JavaMail.root@tahiti.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-08-19 19:56, Mohit Mehta wrote:

>I was able to cleanly apply the attached modified patches to the
> latest iptables code. Also, below is the code in text if attachment
> doesn't reach.
>
>build-vm:/# cat iptables.c.patch
>>From 4dbfcfeb9fc65df7fac1f16230871c02a85b4ea1 Mon Sep 17 00:00:00 2001
>From: root <root@build-vm.(none)>
>Date: Tue, 7 Jul 2009 14:03:50 -0700
>Subject: [PATCH] expose option to zero packet and byte counters for a specific rule using iptables


I wonder what the real-world use of this is, apart from
rule debugging (for which -j TRACE seems better anyhow).


I queued these patches (since I guess they won't apply elsewhere
again ;-) with reservation provision, fixed the trailing whitespace, and 
added the missing manpage updates. Pull requests follows soon.
(It's in git://dev.medozas.de/iptables master already)
