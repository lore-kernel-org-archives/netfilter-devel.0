From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] xt_TCPOPTSTRIP 20071006 (kernel)
Date: Sat, 6 Oct 2007 17:21:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710061720030.5969@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
 <874ph4bafm.fsf@apollo.sven.bitebene.org> <Pine.LNX.4.64.0710061630310.5969@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710061659271.5969@fbirervta.pbzchgretzou.qr>
 <87sl4o9sot.fsf@apollo.sven.bitebene.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41376 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbXJFPVf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:21:35 -0400
In-Reply-To: <87sl4o9sot.fsf@apollo.sven.bitebene.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 6 2007 17:19, Sven Schnelle wrote:
>Jan Engelhardt <jengelh@computergmbh.de> writes:
>
>> Add xt_TCPOPTSTRIP, a module to replace TCP options by NOPs.
>>
>> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>> [..]
>
>Thanks Jan, especially for all the help with a netfilter beginner like
>me :). If nobody complains about serious bugs/problems, i'll submit these
>patches as the final candidates.
>

Sven, This is already submitted. With every mail you post, you have to fear
that your code is taken into the depths of the kernel source forest ;-)

Patrick, please apply.
