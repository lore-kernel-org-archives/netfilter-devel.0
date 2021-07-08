Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05AEC07E95
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Jul 2021 01:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D51E61CCA
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Jul 2021 01:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhGHBmv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 21:42:51 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:58367 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbhGHBmv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 21:42:51 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jul 2021 21:42:50 EDT
Received: from smtpauth-2019-1.uniroma2.it (smtpauth-2019-1.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 1681VhNH024695;
        Thu, 8 Jul 2021 03:31:48 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 3A5FF1208DB;
        Thu,  8 Jul 2021 03:31:39 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1625707899; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NF/VX5BnHW6AZ/Wr7EKFCio+w1If5QiP2hzEitZAA0=;
        b=zFEjwnwgIeN/9eSUBudsQWX0K278g5gA+gqooxJsBEtkKzin1a8/3JXKBNxIG6pRevojLX
        J6sVuBBCLw9rYaAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1625707899; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NF/VX5BnHW6AZ/Wr7EKFCio+w1If5QiP2hzEitZAA0=;
        b=HodhESQfqOdwodvjsmNBViTin3HsttXT9744aRwr8hSGDMCuFDwB9FBXxfrx9CX1QMnH8F
        bhzhSb7hv80VaSQPU157isRTc0Wa7wG8xL1WU8Fuo+ibHxTzvKcz2JxYHk/q2wwQqqqmtW
        8omqWkCy1e5wn2wauyphk0uG5bs95wS/tdyP0nCuFun5hfdK5qNvPOkZEh4xZYtCPHccUU
        bS/xg/JqzWyBQpAYVoEouKbx1/pDXmebqiyLV3KdCBqvgknN6zFQVbOeDuzopO7xgd05n6
        k3HXuG+GBckJrGeszp++RiGQy2wyOZBDNlhf67XJhDq4DUmNEHp3UVjJnMAQzQ==
Date:   Thu, 8 Jul 2021 03:31:38 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Ryoga Saito <proelbtn@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        "Stefano Salsano <stefano.salsano@uniroma2.it>"@smtp-2015.uniroma2.it,
        "Paolo Lungaroni <paolo.lungaroni@uniroma2.it>"@smtp-2015.uniroma2.it,
        "Andrea Mayer <andrea.mayer@uniroma2.it>"@smtp-2015.uniroma2.it
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated
 flows
Message-Id: <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
In-Reply-To: <20210706052548.5440-1-proelbtn@gmail.com>
References: <20210706052548.5440-1-proelbtn@gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear Ryoga,
looking at your patch I noted several issues.
I start from the decap part but the same critical aspects are present also in
the encap one.

On Tue, 6 Jul 2021 14:25:48 +0900
Ryoga Saito <proelbtn@gmail.com> wrote:
> [...]
>
>
> +static int seg6_local_input(struct sk_buff *skb)
> +{
> +    if (skb->protocol != htons(ETH_P_IPV6)) {
> +        kfree_skb(skb);
> +        return -EINVAL;
> +    }
> +
> +    return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN, dev_net(skb->dev), NULL,
> +               skb, skb->dev, NULL, seg6_local_input_core);
> +}
> +

The main problem here concerns the use that has been made of the netfilter
HOOKs combined with the SRv6 processing logic.

In seg6_local_input, it is not absolutely guaranteed that the packet is
intended to be processed and delivered locally. In fact, depending on the given
configuration and behavior, the packet can either be i) processed and delivered
locally or ii) processed and forwarded to another node.

In seg6_local_input, depending on the given configuration and behavior, the
packet can either be i) processed and delivered locally or ii) processed and
forwarded to another node. On the other hand, your code assumes that the packet
is intended to be processed and delivered locally.


Calling the nfhook NFPROTO_IPV6 with NF_INET_LOCAL_IN can have several side
effects. I'll show you one below with an example:

suppose you have a transit SRv6 node (which we call T) configured with an SRv6
Behavior End (in other words, node T receives SRv6 traffic to be processed by
SRv6 End and forwarded to another node). Such node T is configured with
firewall rules on the INPUT CHAIN that prevent it from receiving traffic that
was *NOT* generated by the node itself (speaking of conntrack...). This
configuration can be enforced either through an explicit rule (i.e. XXX -j
DROP) or by setting the default INPUT CHAIN policy to DROP (as it would be done
in a traditional firewall configuration).

In this patch, what happens is that when an SRv6 packet passes through the
node, the call to the nfhook with NF_INET_LOCAL_IN triggers the call to the
firewall and the DROP policy on INPUT kicks in. As a result, the packet is
discarded. What makes the situation even worse is that using the nfhook in this
way breaks the SRv6 Behavior counter system (making that totally unusable).


> +static int input_action_end_dx4(struct sk_buff *skb,
> +                struct seg6_local_lwt *slwt)
> +{
[...]

Similar problems with the inappropriate use of the hook also exist in
action_end_dx4.

> +static int seg6_input(struct sk_buff *skb)
> +{
> +    int proto;
> +
> +    if (skb->protocol == htons(ETH_P_IPV6))
> +        proto = NFPROTO_IPV6;
> +    else if (skb->protocol == htons(ETH_P_IP))
> +        proto = NFPROTO_IPV4;
> +    else
> +        return -EINVAL;
> +
> +    return NF_HOOK(proto, NF_INET_POST_ROUTING, dev_net(skb->dev), NULL,
> +               skb, NULL, skb_dst(skb)->dev, seg6_input_core);
> +}
> +
>


Another example where the normal processing flow is altered is in the
seg6_input() function (on the encap side). The seg6_input function should be
called in case of i) local processing and delivery or ii) local processing and
forwarding of the packet to another node. However, in this case a nfhook with
POST_ROUTING is called.

> +static int seg6_output_core(struct net *net, struct sock *sk,
> +                struct sk_buff *skb)
> {
>     struct dst_entry *orig_dst = skb_dst(skb);
>     struct dst_entry *dst = NULL;
> @@ -387,12 +411,28 @@ static int seg6_output(struct net *net, struct sock > > *sk, struct sk_buff *skb)
>     if (unlikely(err))
>         goto drop;
>
> -    return dst_output(net, sk, skb);
> +    return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk, skb, NULL,
> +               skb_dst(skb)->dev, dst_output);
>

In turn, the seg6_input_core function calls the nfhook set with
NF_INET_LOCAL_OUT. Doing that side effects may be expected, because the natural
order of packet processing in netfilter, or more specifically in the SRv6
framework, has been changed.

There are also some minor issues, such as trying to follow the coding style of
the SRv6 Networking subsystem (this applies also to the Networking subsystem in
general). For example here:

+static int input_action_end_dx6_finish(struct net *net, struct sock *sk,
+                       struct sk_buff *skb)
+{
+    struct dst_entry *orig_dst = skb_dst(skb);
+    struct seg6_local_lwt *slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
+    struct in6_addr *nhaddr = NULL;
+    [...]

The code should respect the Reverse Christmas tree, i.e:

    struct dst_entry *orig_dst = skb_dst(skb);
    struct in6_addr *nhaddr = NULL;
    struct seg6_local_lwt *slwt;

    slwt = seg6_local_lwtunnel(orig_dst->lwtstate);
    [...]


Ciao,
Andrea
