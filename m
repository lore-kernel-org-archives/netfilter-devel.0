From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 13/24] --- Add all necessary header files - compilation
 fix for various cases
Date: Tue, 4 Mar 2008 17:18:27 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041716180.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0803041702270.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35274 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765340AbYCDQS2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:18:28 -0500
In-Reply-To: <Pine.LNX.4.64.0803041702270.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 4 2008 17:02, Jan Engelhardt wrote:
>
>    Add all necessary header files - compilation fix for various cases
>    
>    Allow iptables to compile without a kernel source tree. This
>    implies fixing build for older kernels, such as 2.6.17 which
>    lack xt_SECMARK.h.
>---

See what happens if you force submission :-)
...
This patch is missing two hunks which ended up in 20/24 for some reason.
Consider patches beginning at 13/24 being just "please comment" and are 
otherwise invalidated.
