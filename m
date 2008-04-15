From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] [NETFILTER]: Collapse tcpmss_reverse_mtu{4,6} into
 one function
Date: Tue, 15 Apr 2008 15:59:18 +0200
Message-ID: <4804B4B6.4090006@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <b98252de900f8adedc682997216cc4f9dc4d5a4a.1207668694.git.jengelh@computergmbh.de> <4804A4D5.4090707@trash.net> <alpine.LNX.1.10.0804151554260.13202@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38031 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbYDON7V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:59:21 -0400
In-Reply-To: <alpine.LNX.1.10.0804151554260.13202@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-04-15 14:51, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>>> ---
>>>  net/netfilter/xt_TCPMSS.c |   42 +++++++++++-------------------------
>>>  1 files changed, 13 insertions(+), 29 deletions(-)
>> Applied, thanks.
>>
>> Please resend all AF_UNSPEC/arptables/ebtables related patches
>> once you've done the remaining fixes.
>> --
> 
> The patch queue (in testing) has no more fixes; am I missing patches?

Patch queue in testing?
