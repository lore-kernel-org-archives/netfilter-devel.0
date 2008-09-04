From: Patrick McHardy <kaber@trash.net>
Subject: Re: 6/7 [NETFILTER]: Use NFPROTO_* in extensions
Date: Thu, 04 Sep 2008 18:01:36 +0200
Message-ID: <48C00660.1090108@trash.net>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131943000.13154@fbirervta.pbzchgretzou.qr> <48BFF947.5070201@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65215 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYIDQBi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:01:38 -0400
In-Reply-To: <48BFF947.5070201@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 13b7a78eb14ed69f0dcd2af48d39b2284a2c9aed
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Sun Aug 10 17:46:39 2008 -0400
>>
>> [NETFILTER]: Use NFPROTO_* in extensions
> 
> Applied with two minor fixups, one for the reject resulting
> from not applying the xt_length patch, one in arptable_filter
> for unknown reasons.

BTW, there are a few occurences left, f.i. in the tables.
I'm applying Alexey's netns patches now, so if you want
to fix this up, please wait a few hours until I've uploaded
my current tree to kernel.org.


