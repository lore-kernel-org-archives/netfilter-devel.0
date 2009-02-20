From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: functions returning structs: is it perfectly legal and how
 efficient?
Date: Fri, 20 Feb 2009 12:00:05 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902201155090.9626@fbirervta.pbzchgretzou.qr>
References: <885896af0902200115t49d86f26t65d981f6fab603cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:32972 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZBTLAI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:00:08 -0500
In-Reply-To: <885896af0902200115t49d86f26t65d981f6fab603cf@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-02-20 10:15, Giacomo wrote:
>
>Suppose we have a very little data structure - in kernel space - :
>
>typedef struct
>{
>  __u32 saddr, daddr;
>  __u16 sport, dport;
>  short int valid;
>} net_quadruplet;

Phew - http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/

>[case 1]:
>net_quadruplet get_quad_from_skb(const struct sk_buff* skb)
>{
>	net_quadruplet netquad;
>	memset(&netquad, 0, sizeof(net_quadruplet));
>        netquad.valid = 1;
>        ...
>        return netquad;
>}
>
>Is it perfectly legal?

That's a question for a C forum/channel, but yes, it is valid.

>[code 2]:
>Would it be more efficient
>
>int get_quad_from_skb(const struct sk_buff* skb, net_quadruplet* nquad)
>{
>   int return_value = 0;
>   /* modify nquad
>      .....
>   */
>   return return_value;
>}
>
>?

Depends on architecture and compiler. Usually it is said that the
compiler will transparently transform the first case into variant 2.
This need not always be the case however, returning an aggregate
object such as a struct could also be accomplished by filling
registers, where there are enough available to do so. This is all
highly implementation-dependent though.
