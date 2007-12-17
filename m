From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Change xt_TOS v1 target to zero-out semantic
Date: Mon, 17 Dec 2007 14:13:15 +0100
Message-ID: <476675EB.7040103@trash.net>
References: <Pine.LNX.4.64.0712151447250.22877@fbirervta.pbzchgretzou.qr> <476673D8.50701@trash.net> <Pine.LNX.4.64.0712171407300.32270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57362 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbXLQNOD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 08:14:03 -0500
In-Reply-To: <Pine.LNX.4.64.0712171407300.32270@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Dec 17 2007 14:04, Patrick McHardy wrote:
>
>> I'd prefer:
>>
>> --set-tos: set exact value, no mask
>> --or-tos: set single bits
>> --xor-tos: flip single bits
>> --and-tos: mask single bits
>>
> 
> Ok, I'll add these. However, since they get transformed to xmark 
> internally, they would normally be displayed as
> 
> 	--set-tos value/mask (iptables-save, iptables -nL)
> 	TOS set value/mask (iptables -L)
> 
> Is that ok, or should I figure out some math to transform it back to 
> --{or,xor,and}-tos for the human-readable (iptables -L) case?


That would be better. The mark patch I pointer you to some
time ago did this:

+print_mark(unsigned long mark, unsigned long mask, int numeric)
  {
-       printf("0x%lx ", mark);
+       if (mask == 0)
+               printf("set 0x%lx ", mark);
+       else if (mark == ~mask)
+               printf("or 0x%lx ", mark);
+       else if ((mark & mask) == 0)
+               printf("set 0x%lx/0x%lx ", mark, ~mask);
+       else {
+               if (mask != ~0UL)
+                       printf("and 0x%lx ", mask);
+               if (mark)
+                       printf("xor 0x%lx ", mark);
+       }
  }

which I guess would also work for tos.
