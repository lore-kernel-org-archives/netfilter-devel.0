Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1013EC07E96
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Jul 2021 20:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E033D61874
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Jul 2021 20:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhGHUzf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Jul 2021 16:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhGHUze (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Jul 2021 16:55:34 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BECC061574
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Jul 2021 13:52:52 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id oj10-20020a17090b4d8ab0290172f77377ebso4787379pjb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Jul 2021 13:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=xZGCZjmkGUTwlWRJQiMRR/JnxZAQQsV9xaPqG2yhwmg=;
        b=KHc3DJaYK1gg5dxOpwpQvQQjWHxcNsaL+DgRkEmOu+r5ATpYm8ywUeot8aRRDRX+Yk
         fDpzQ0RJG8YkGm8MRp2eJLEa2LZ7470jJ0IFSODWazocjA5g0zbjCH/Yi3XPWayXZa45
         fx606PwKmafT+mdtd+rUoDlkzzEl/ESwl+3938tN8iB7B/SU10JBICdCSKQEOfhi9ncJ
         vMrtlqaKD9s7IcNuehAQAfKeLMN9JL3UWVUmM+9vfDAlUrl2h+G5X9d6bOfK99ROCFOR
         f4pf248tYWr0c1buLyWta0Nhl4MCjN0LsmYqLqEdYisKhYEEBSB+W8zAuZIZ9FiO8J7T
         5LcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=xZGCZjmkGUTwlWRJQiMRR/JnxZAQQsV9xaPqG2yhwmg=;
        b=umkfjFGt817PlRCm9XaWZD516RlrPG2Z0GzUPrPieanUMB+U2D/Ojwz6SEwz3Q8OpU
         q0SulgGFaE26gwUjtoIUVnIMk+bMIB0PjVMrkNtSYKPXsedSnSS5vugPGQo+CeuSU0GD
         3L3WYIj0ioF/a5nyrO6enGnq4OdjYNdKOGan3NClhuFN0IR0lnvsCV48QMTfKp2x6AZt
         Cvv6Hjn02DpJkt3L/vSp4zLgWoTaisElYaK6yL9w883alQSu3DyJA5T025pV7vCgaRKb
         sI3nejP6GswhiaIcocC/zUM7Mfr5710W2F5HGWtRwcGdLgAn6OtpIT5lytSZ2v2Li0Jp
         Tu2Q==
X-Gm-Message-State: AOAM531VqvS3+zQ0IrmQE9J5SE4DeHZ3hSGjx8alZ0rGuLwfVNas8lRC
        su4x05HCbWR6fpbTCP1eP4yuYH0XtVzbxI7f
X-Google-Smtp-Source: ABdhPJy+fha27tWdxY+gxGy6smdkaPaOHpLvF76wMC3KWkFzN058N3+vorDN+kriXrcqKOCBclpVuA==
X-Received: by 2002:a17:902:9308:b029:129:7c79:e53d with SMTP id bc8-20020a1709029308b02901297c79e53dmr22503076plb.50.1625777571846;
        Thu, 08 Jul 2021 13:52:51 -0700 (PDT)
Received: from smtpclient.apple (softbank060108183144.bbtec.net. [60.108.183.144])
        by smtp.gmail.com with ESMTPSA id l3sm10650238pju.57.2021.07.08.13.52.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jul 2021 13:52:51 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated flows
From:   Ryoga Saito <proelbtn@gmail.com>
In-Reply-To: <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
Date:   Fri, 9 Jul 2021 05:52:45 +0900
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
References: <20210706052548.5440-1-proelbtn@gmail.com>
 <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
 <20210708133859.GA6745@salvia>
 <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
 <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear Andrea
Thanks for your reviews and comments.


> On Jul 9, 2021, at 1:32, Andrea Mayer <andrea.mayer@uniroma2.it> =
wrote:
>=20
> Dear Pablo,
> thanks for your time.
>=20
> On Thu, 8 Jul 2021 15:38:59 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>=20
>> Dear Andrea,
>>=20
>> On Thu, Jul 08, 2021 at 03:31:38AM +0200, Andrea Mayer wrote:
>>> Dear Ryoga,
>>> looking at your patch I noted several issues.
>>> I start from the decap part but the same critical aspects are =
present also in
>>> the encap one.
>>>=20
>>> On Tue, 6 Jul 2021 14:25:48 +0900
>>> Ryoga Saito <proelbtn@gmail.com> wrote:
>>>> [...]
>>>>=20
>>>>=20
>>>> +static int seg6_local_input(struct sk_buff *skb)
>>>> +{
>>>> +    if (skb->protocol !=3D htons(ETH_P_IPV6)) {
>>>> +        kfree_skb(skb);
>>>> +        return -EINVAL;
>>>> +    }
>>>> +
>>>> +    return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN, =
dev_net(skb->dev), NULL,
>>>> +               skb, skb->dev, NULL, seg6_local_input_core);
>>>> +}
>>>> +
>>>=20
>>> The main problem here concerns the use that has been made of the =
netfilter
>>> HOOKs combined with the SRv6 processing logic.
>>>=20
>>> In seg6_local_input, it is not absolutely guaranteed that the packet =
is
>>> intended to be processed and delivered locally. In fact, depending =
on the given
>>> configuration and behavior, the packet can either be i) processed =
and delivered
>>> locally or ii) processed and forwarded to another node.
>>=20
>> What SRv6 decides to do with the packet is irrelevant, see below.
>>=20
>>> In seg6_local_input, depending on the given configuration and =
behavior, the
>>> packet can either be i) processed and delivered locally or ii) =
processed and
>>> forwarded to another node. On the other hand, your code assumes that =
the packet
>>> is intended to be processed and delivered locally.
>>>=20
>>> Calling the nfhook NFPROTO_IPV6 with NF_INET_LOCAL_IN can have =
several side
>>> effects.
>>=20
>> This is how UDP tunnel encap_rcv infrastructure works: the packet
>> follows the INPUT path. The encap_rcv() might decide to reinject the
>> decapsulated packet to stack or forward it somewhere else.
>>=20
>=20
> the problem is that in SRv6 a packet to be processed by a node with an=20=

> SRv6 End Behavior does not follow the INPUT path and its processing is=20=

> different from the UDP tunnel example that you have in mind (more info=20=

> below)
>=20
> Note that I'm referring to the SRv6 Behaviors as implemented in =
seg6_local.c

I thought SRv6 processing to be the same as encapsulation/decapsulation
processing and I implemented patch this way intentionally.

>>> I'll show you one below with an example:
>>>=20
>>> suppose you have a transit SRv6 node (which we call T) configured =
with an SRv6
>>> Behavior End (in other words, node T receives SRv6 traffic to be =
processed by
>>> SRv6 End and forwarded to another node). Such node T is configured =
with
>>> firewall rules on the INPUT CHAIN that prevent it from receiving =
traffic that
>>> was *NOT* generated by the node itself (speaking of conntrack...). =
This
>>> configuration can be enforced either through an explicit rule (i.e. =
XXX -j
>>> DROP) or by setting the default INPUT CHAIN policy to DROP (as it =
would be done
>>> in a traditional firewall configuration).
>>>=20
>>> In this patch, what happens is that when an SRv6 packet passes =
through the
>>> node, the call to the nfhook with NF_INET_LOCAL_IN triggers the call =
to the
>>> firewall and the DROP policy on INPUT kicks in. As a result, the =
packet is
>>> discarded. What makes the situation even worse is that using the =
nfhook in this
>>> way breaks the SRv6 Behavior counter system (making that totally =
unusable).
>>=20
>> By default there are no registered hooks, ie. no filtering policy in
>> place, the user needs to explicity specify a filtering policy, the
>> mechanism is not breaking anything, the user policy needs to be
>> consistent, that's all.
>>=20
>=20
> An example of consistent user policies in node T that can be installed
> now and are broken by the patch is the following:
>=20
>   ip6tables -A INPUT -i lo -j ACCEPT
>=20
>   ip6tables -A INPUT \
>          -p icmpv6 --icmpv6-type neighbor-solicitation -j ACCEPT       =
         =20
>   ip6tables -A INPUT \
>          -p icmpv6 --icmpv6-type neighbor-advertisement -j ACCEPT
>=20
>   ip6tables -A INPUT \
>          -p icmpv6 --icmpv6-type router-solicitation -j ACCEPT
>   ip6tables -A INPUT \
>          -p icmpv6 --icmpv6-type router-advertisement -j ACCEPT
>=20
>   ip6tables -A INPUT \
>          -p icmpv6 --icmpv6-type echo-request -j ACCEPT
>   ip6tables -A INPUT \
>          -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
>=20
>   ip6tables -P INPUT DROP =20
>=20
> The IPv6 destination address fc01::2 (SRv6 SID) is configured as an =
SRv6 End
> Behavior in node T. On node T we expect to receive an IPv6+SRH packet =
with
> DA equals to fc01::2.
> Please note that the fc01::2 is NOT a local address for the T node.
>=20
> In node T only the following protocols are allowed in INPUT:
>=20
>  icmpv6 RA, neigh adv/sol and echo request/reply
>=20
> while all other protocols in INPUT are discarded.
>=20
> with this consistent configuration, node T is able to correctly =
process and
> forward packets with IPv6+SRH destination address fc01::2 because the =
INPUT
> path is not taken when SRv6 implementation is processing an SRv6 End =
Behavior.
>=20
> After the introduction of the patch, this correct behavior is broken.

I considered srv6 Behaviors (e.g. T.Encaps) to be the same as the =
encapsulation
in other tunneling protocols, and srv6local Behaviors (e.g. End, =
End.DT4,
End.DT6, ...) to be the same as the decapsulation in other tunneling =
protocols
even if decapsulation isn't happened. I'm intended that SRv6 packets =
whose
destination address is SRv6 End Behavior go through INPUT path.

I think it works correctly on your situation with the following rule:

ip6tables -A INPUT --dst fc01::2 -j ACCEPT

To say more generally, SRv6 locator blocks should be allowed with =
ip6tables if
you want to change default policy of INPUT chain to DROP/REJECT.
=20
Ryoga
