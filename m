From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 6/27] xt_CONNMARK target, revision 1
Date: Fri, 4 Jan 2008 15:46:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801041545220.8731@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0801022126550.14900@fbirervta.pbzchgretzou.qr>
 <477E45A5.1060302@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38470 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYADOqQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:46:16 -0500
In-Reply-To: <477E45A5.1060302@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 4 2008 15:41, Patrick McHardy wrote:
>
> Applied with some minor cosmetic changes:
>
>> +	switch (info->mode) {
>> +		case XT_CONNMARK_SET:
>
> switch cases should not be indented deeper then the switch statement.
>

Ah ok. I was uncertain because xt_CONNMARK v0 or xt_MARK v0 did it
that way too. And since it's not exceeding 80 cols, it's kinda a
roll-a-die situation :)
