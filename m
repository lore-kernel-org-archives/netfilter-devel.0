From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_TCPOPTSTRIP 20071006 (kernel)
Date: Mon, 08 Oct 2007 07:05:10 +0200
Message-ID: <4709BA86.8090306@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr> <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de> <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr> <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710061659271.5969@fbirervta.pbzchgretzou.qr> <87sl4o9sot.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061720030.5969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51552 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXJHFHa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 01:07:30 -0400
In-Reply-To: <Pine.LNX.4.64.0710061720030.5969@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 6 2007 17:19, Sven Schnelle wrote:
> 
>>Thanks Jan, especially for all the help with a netfilter beginner like
>>me :). If nobody complains about serious bugs/problems, i'll submit these
>>patches as the final candidates.
>>
> 
> 
> Sven, This is already submitted. With every mail you post, you have to fear
> that your code is taken into the depths of the kernel source forest ;-)


Not really, I only apply patches when I'm addressed or am
certain otherwise that the submitter wants me to apply it.

> Patrick, please apply.


There were some discussions that new stuff shouldn't appear
so shortly before the merge window opens, so I'll queue it
for 2.6.25 when the last minor issues are addressed.
