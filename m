From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: ct_extend: alloc space for xt_portscan
Date: Mon, 12 Jan 2009 05:18:32 +0100
Message-ID: <496AC498.7050908@trash.net>
References: <alpine.LSU.2.00.0901080924030.2273@fbirervta.pbzchgretzou.qr> <496633BF.7060609@netfilter.org> <496AC1EC.1070006@trash.net> <alpine.LSU.2.00.0901120514110.2021@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54862 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZALESr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2009 23:18:47 -0500
In-Reply-To: <alpine.LSU.2.00.0901120514110.2021@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-01-12 05:07, Patrick McHardy wrote:
>>>> The out-of-tree xt_portscan module currently (ab)uses skb->mark and
>>>> nfct->mark to store its state, but such may collide with
>>>> user-specified marks.
>>>>
>>>> Using nfct_extend alleviates that problem and hopefully paves way
>>>> for inclusion of the module.
>>> Sorry, I would not reserve an entry unless I know what xt_portscan is.
> 
> http://article.gmane.org/gmane.linux.kernel/502344

Just send the patch please.

> 
>> I feel the same way. And I would like to know why it needs
>> connection state. That seems counterintuitive to a portscan
>> detector, which is by definition trying to detect something
>> happening in multiple connections.
> 
> Is it so? Maybe it should be called portscantype then, but what's in a name.
> 

