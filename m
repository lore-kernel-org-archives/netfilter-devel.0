From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: ct_extend: alloc space for xt_portscan
Date: Mon, 12 Jan 2009 05:07:08 +0100
Message-ID: <496AC1EC.1070006@trash.net>
References: <alpine.LSU.2.00.0901080924030.2273@fbirervta.pbzchgretzou.qr> <496633BF.7060609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54705 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZALEHY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jan 2009 23:07:24 -0500
In-Reply-To: <496633BF.7060609@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>> parent b58602a4bac012b5f4fc12fe6b46ab237b610d5d
>> commit 7634e5f586394eafc85973712ff11e60a9ae2f70
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Thu Jan 8 09:20:03 2009 +0100
>>
>> netfilter: ct_extend: alloc space for xt_portscan
>>
>> The out-of-tree xt_portscan module currently (ab)uses skb->mark and
>> nfct->mark to store its state, but such may collide with
>> user-specified marks.
>>
>> Using nfct_extend alleviates that problem and hopefully paves way
>> for inclusion of the module.
>>
> 
> Sorry, I would not reserve an entry unless I know what xt_portscan is.

I feel the same way. And I would like to know why it needs
connection state. That seems counterintuitive to a portscan
detector, which is by definition trying to detect something
happening in multiple connections.
