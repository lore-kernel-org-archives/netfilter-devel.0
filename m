Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43C5C07E99
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Jul 2021 16:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E53B61879
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Jul 2021 16:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhGHQf5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Jul 2021 12:35:57 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:47535 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhGHQf4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Jul 2021 12:35:56 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 168GWiv9006368;
        Thu, 8 Jul 2021 18:32:49 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 5504A120542;
        Thu,  8 Jul 2021 18:32:40 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1625761960; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfT8n5gOFy8VE79tMPTzYgudtfE6SF9DWU6OBhqfbJg=;
        b=0cxkYERycThJSO06g27jc4OyQ6XgSeQub3CB+QQmdhAgSozgqsw3zRagA1tnqsLQcMAaDW
        RLrB4Et0GvO1sMDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1625761960; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EfT8n5gOFy8VE79tMPTzYgudtfE6SF9DWU6OBhqfbJg=;
        b=PJCXXx6dVetTHTLJ4X0JmYxOq2kzYMKF9mJnhVYdHmwcnRFYFZX9x24JevavFGvJP3a8Be
        ZaLowxy63XECsdf3VFMO2O3M/3hoh5Ww2NzkoiuS+jstNmBXbWTRTJq1feUKXKjlsA2WY9
        b7UAAx49k8Mp5l971N60aFmlY5f96RUUNvVYbkQZglu3CqPrTaKkm4IhRvSHvU7PAjX5Mf
        PIXF0Z9bgsFpLPTj/o0qtp57Uz10g4dRt2nQAXyEMDJfKChDGPCQx5c5Yg6cGZtXseQpct
        X9/JKX5ysV3hSGnef1zBupQrjZ+0s3BBdQSi/+SEu+ujV8qogsYIi4OcvQ6IEA==
Date:   Thu, 8 Jul 2021 18:32:39 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Ryoga Saito <proelbtn@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated
 flows
Message-Id: <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
In-Reply-To: <20210708133859.GA6745@salvia>
References: <20210706052548.5440-1-proelbtn@gmail.com>
        <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
        <20210708133859.GA6745@salvia>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear Pablo,
thanks for your time.

On Thu, 8 Jul 2021 15:38:59 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Dear Andrea,
> 
> On Thu, Jul 08, 2021 at 03:31:38AM +0200, Andrea Mayer wrote:
> > Dear Ryoga,
> > looking at your patch I noted several issues.
> > I start from the decap part but the same critical aspects are present also in
> > the encap one.
> > 
> > On Tue, 6 Jul 2021 14:25:48 +0900
> > Ryoga Saito <proelbtn@gmail.com> wrote:
> > > [...]
> > >
> > >
> > > +static int seg6_local_input(struct sk_buff *skb)
> > > +{
> > > +    if (skb->protocol != htons(ETH_P_IPV6)) {
> > > +        kfree_skb(skb);
> > > +        return -EINVAL;
> > > +    }
> > > +
> > > +    return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN, dev_net(skb->dev), NULL,
> > > +               skb, skb->dev, NULL, seg6_local_input_core);
> > > +}
> > > +
> > 
> > The main problem here concerns the use that has been made of the netfilter
> > HOOKs combined with the SRv6 processing logic.
> > 
> > In seg6_local_input, it is not absolutely guaranteed that the packet is
> > intended to be processed and delivered locally. In fact, depending on the given
> > configuration and behavior, the packet can either be i) processed and delivered
> > locally or ii) processed and forwarded to another node.
> 
> What SRv6 decides to do with the packet is irrelevant, see below.
> 
> > In seg6_local_input, depending on the given configuration and behavior, the
> > packet can either be i) processed and delivered locally or ii) processed and
> > forwarded to another node. On the other hand, your code assumes that the packet
> > is intended to be processed and delivered locally.
> >
> > Calling the nfhook NFPROTO_IPV6 with NF_INET_LOCAL_IN can have several side
> > effects.
> 
> This is how UDP tunnel encap_rcv infrastructure works: the packet
> follows the INPUT path. The encap_rcv() might decide to reinject the
> decapsulated packet to stack or forward it somewhere else.
> 

the problem is that in SRv6 a packet to be processed by a node with an 
SRv6 End Behavior does not follow the INPUT path and its processing is 
different from the UDP tunnel example that you have in mind (more info 
below)

Note that I'm referring to the SRv6 Behaviors as implemented in seg6_local.c

> > I'll show you one below with an example:
> > 
> > suppose you have a transit SRv6 node (which we call T) configured with an SRv6
> > Behavior End (in other words, node T receives SRv6 traffic to be processed by
> > SRv6 End and forwarded to another node). Such node T is configured with
> > firewall rules on the INPUT CHAIN that prevent it from receiving traffic that
> > was *NOT* generated by the node itself (speaking of conntrack...). This
> > configuration can be enforced either through an explicit rule (i.e. XXX -j
> > DROP) or by setting the default INPUT CHAIN policy to DROP (as it would be done
> > in a traditional firewall configuration).
> > 
> > In this patch, what happens is that when an SRv6 packet passes through the
> > node, the call to the nfhook with NF_INET_LOCAL_IN triggers the call to the
> > firewall and the DROP policy on INPUT kicks in. As a result, the packet is
> > discarded. What makes the situation even worse is that using the nfhook in this
> > way breaks the SRv6 Behavior counter system (making that totally unusable).
> 
> By default there are no registered hooks, ie. no filtering policy in
> place, the user needs to explicity specify a filtering policy, the
> mechanism is not breaking anything, the user policy needs to be
> consistent, that's all.
> 

An example of consistent user policies in node T that can be installed
now and are broken by the patch is the following:
 
   ip6tables -A INPUT -i lo -j ACCEPT

   ip6tables -A INPUT \
          -p icmpv6 --icmpv6-type neighbor-solicitation -j ACCEPT                 
   ip6tables -A INPUT \
          -p icmpv6 --icmpv6-type neighbor-advertisement -j ACCEPT
                                                              
   ip6tables -A INPUT \
          -p icmpv6 --icmpv6-type router-solicitation -j ACCEPT
   ip6tables -A INPUT \
          -p icmpv6 --icmpv6-type router-advertisement -j ACCEPT

   ip6tables -A INPUT \
          -p icmpv6 --icmpv6-type echo-request -j ACCEPT
   ip6tables -A INPUT \
          -p icmpv6 --icmpv6-type echo-reply -j ACCEPT

   ip6tables -P INPUT DROP  

The IPv6 destination address fc01::2 (SRv6 SID) is configured as an SRv6 End
Behavior in node T. On node T we expect to receive an IPv6+SRH packet with
DA equals to fc01::2.
Please note that the fc01::2 is NOT a local address for the T node.

In node T only the following protocols are allowed in INPUT:

  icmpv6 RA, neigh adv/sol and echo request/reply

while all other protocols in INPUT are discarded.

with this consistent configuration, node T is able to correctly process and
forward packets with IPv6+SRH destination address fc01::2 because the INPUT
path is not taken when SRv6 implementation is processing an SRv6 End Behavior.

After the introduction of the patch, this correct behavior is broken.

If you want I can provide a diagram with the full description of this 
scenario and all the scripts to reproduce the issue.

Andrea
