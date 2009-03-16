From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: xtables: avoid pointer to self
Date: Mon, 16 Mar 2009 15:36:06 +0100
Message-ID: <49BE63D6.1090306@trash.net>
References: <alpine.LSU.2.00.0903031806350.8887@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46860 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbZCPOgJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:36:09 -0400
In-Reply-To: <alpine.LSU.2.00.0903031806350.8887@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> (There is a 2nd patch as reply, could you please fold that.)
> 
> ---8<---
> netfilter: xtables: avoid pointer to self
> 
> Commit 784544739a25c30637397ace5489eeb6e15d7d49 (netfilter: iptables: 
> lock free counters) broke a number of modules whose rule data referenced 
> itself. A reallocation would not reestablish the correct references, so 
> it is best to use a separate struct that does not fall under RCU.

Applied, including the second patch. Thanks.

