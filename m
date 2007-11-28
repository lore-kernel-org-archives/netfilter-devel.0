From: Philip Craig <philipc@snapgear.com>
Subject: Re: IPT [PATCH] yay, autotools!
Date: Wed, 28 Nov 2007 11:21:37 +1000
Message-ID: <474CC2A1.2080106@snapgear.com>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:56339 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755460AbXK1BTx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 20:19:53 -0500
In-Reply-To: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> 	- iptables-static will be a multi binary. I doubt you want split
> 	binaries on embedded anyway (diskspace constraints).

Agreed.

> 	- A new binary, iptables-mtss is built (semi-static, with glibc but
> 	without plugins).
> 
> 	I do not think iptables-static makes any sense (neither now nor
> 	before this move to autotools), because ld rightly tells me that
> 	building with -static will cause loading of glibc parts /anyway/
> 	because of getserv*() in xt_dccp and so on.

Yes.  The NO_SHARED_LIBS option originally did the equivalent of iptables-mtss,
but it seems that got changed somewhere along the line.

