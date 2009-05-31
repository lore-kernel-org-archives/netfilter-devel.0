From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Mon, 1 Jun 2009 01:50:21 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906010149510.12927@fbirervta.pbzchgretzou.qr>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu>  <alpine.DEB.2.00.0905311631480.760@blackhole.kfki.hu> <4ddb24250905311604o8d0f2c2l9ba3984ae296a009@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40664 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbZEaXuV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 19:50:21 -0400
In-Reply-To: <4ddb24250905311604o8d0f2c2l9ba3984ae296a009@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-06-01 01:04, Saatvik Agarwal wrote:

>Hi Jozsef,
>
>Thanks a lot for the patch. What version of the kernel/netfilter code
>is this patch intended for? I'm running debian 2.6.26 (lenny) and I
>can't patch my source. 14 out of the 15 hunks fail.

Often enough, whatever is cooking in Linus's (i.e. 2.6.30-rc currently).
