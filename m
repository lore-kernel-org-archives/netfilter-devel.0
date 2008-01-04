From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/27] xt_CONNMARK target, revision 1
Date: Fri, 04 Jan 2008 15:45:29 +0100
Message-ID: <477E4689.2010001@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022126550.14900@fbirervta.pbzchgretzou.qr> <477E45A5.1060302@trash.net> <Pine.LNX.4.64.0801041545220.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48511 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYADOsf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:48:35 -0500
In-Reply-To: <Pine.LNX.4.64.0801041545220.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 4 2008 15:41, Patrick McHardy wrote:
>> Applied with some minor cosmetic changes:
>>
>>> +	switch (info->mode) {
>>> +		case XT_CONNMARK_SET:
>> switch cases should not be indented deeper then the switch statement.
>>
> 
> Ah ok. I was uncertain because xt_CONNMARK v0 or xt_MARK v0 did it
> that way too. And since it's not exceeding 80 cols, it's kinda a
> roll-a-die situation :)


Actually they don't. Maybe your editor did something funny :)

