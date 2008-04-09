From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/8] [NETFILTER]: Rename ipt_recent to xt_recent
Date: Wed, 09 Apr 2008 14:53:47 +0200
Message-ID: <47FCBC5B.2030406@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <47FCBA50.9010408@trash.net> <alpine.LNX.1.10.0804091447590.4411@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45006 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbYDIMxt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:53:49 -0400
In-Reply-To: <alpine.LNX.1.10.0804091447590.4411@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-04-09 14:45, Patrick McHardy wrote:
> 
>>> --- a/net/ipv4/netfilter/ipt_recent.c
>>> +++ b/net/netfilter/xt_recent.c
>> I like this format since it only shows the real differences
>> made during the move. I'm wondering how to apply it so it
>> also performs the rename though.
>>
> 
> Does not git apply automatically do the right thing? It's git-apply
> after all, it should see when a patch was obviously created
> with git diff -M / git-format-patch -M.

Thats what I was wondering about. I didn't test since I was
afraid it might mess up my stgit stack.

> Workaround for gnupatch on the other hand: do the move by hand,
> then apply.

It applies cleanly on the tree as it is, you just have to
perform the move manually.


