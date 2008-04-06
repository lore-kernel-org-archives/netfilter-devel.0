From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [NETFILTER]: Use bool type in struct nf_conntrack_l3proto
Date: Sun, 06 Apr 2008 17:22:14 +0200
Message-ID: <47F8EAA6.1040406@trash.net>
References: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0804060544190.30794@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36923 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYDFPWI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:22:08 -0400
In-Reply-To: <alpine.LNX.1.10.0804060544190.30794@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit bb84a3dab22636fbf691b913a4ceff836c21ffb4
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Sat Mar 8 15:16:53 2008 +0100
> 
>     [NETFILTER]: Use bool type in struct nf_conntrack_l3proto
> 
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

> -    int (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
> -                struct nf_conntrack_tuple *tuple);
> +    bool (*pkt_to_tuple)(const struct sk_buff *skb, unsigned int nhoff,
> +                         struct nf_conntrack_tuple *tuple);
> 

This doesn't apply because of whitespace damage:

          * Try to fill in the third arg: nhoff is offset of l3 proto
            * hdr.  Return true if possible. 

^^^^^^^^^^ spaces that are not present in the tree

I even tried the files taken from Maildir/, so its not mailer related.

Besides that it *still* uses spaced for indentation. I didn't
mean you should run it through your own checkpatch.pl version that
doesn't complain about whitespace but through the one contained in
the kernel tree.


