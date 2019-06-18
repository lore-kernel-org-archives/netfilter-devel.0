Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26645C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E99EC2070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 10:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbfFRK4P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 06:56:15 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51724 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbfFRK4P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 06:56:15 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdBmf-0007ly-1Z; Tue, 18 Jun 2019 12:56:13 +0200
Date:   Tue, 18 Jun 2019 12:56:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Mojtaba <mespio@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: working with libnetfilter_queue and linbetfilter_contrack
Message-ID: <20190618105613.qgfov6jmnov2ba3e@breakpoint.cc>
References: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
 <20190618095021.doh6pc7gzah3bnra@breakpoint.cc>
 <CABVi_EyyV6jmB8SxuiUKpHzL9NwMLUA1TPk3X=SOq58BFdG9vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVi_EyyV6jmB8SxuiUKpHzL9NwMLUA1TPk3X=SOq58BFdG9vA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mojtaba <mespio@gmail.com> wrote:
> Yes, For this reason, i should add conntrack entry before the kernel do in
> my userspace project. Because i have to forward the packet to another
> destination, i used --src-nat and --dst-nat options while adding new
>  conntrack entry. Just like as obvious in below code:
> nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
> nfct_set_attr_u32(ct, ATTR_IPV4_SRC, inet_addr("192.168.133.140"));
> nfct_set_attr_u32(ct, ATTR_IPV4_DST, inet_addr("192.168.133.108"));
> nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
> nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(6000));
> nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(5005));
> nfct_setobjopt(ct, NFCT_SOPT_SETUP_REPLY);
> nfct_set_attr_u32(ct, ATTR_TIMEOUT, 60);
> 
> *nfct_set_attr_u32(ct, ATTR_SNAT_IPV4,
> inet_addr("192.168.133.108"));nfct_set_attr_u32(ct, ATTR_DNAT_IPV4,
> inet_addr("192.168.133.150"));nfct_set_attr_u16(ct, ATTR_SNAT_PORT,
> htons(5070));*
> 
> *nfct_set_attr_u16(ct, ATTR_DNAT_PORT, htons(6000));*
> 
> As far as i know, it is possible to delegate verdict of packets to
> user-space, Here is the main point that is deriving me confused. Suppose i
> used this rule in IPTABLE:
> iptables -A INPUT -p udp --dport 5005  -j NQUEUE --queue-num 0
> Then how we could make verdict to forward the packet to another
> destination?

You can't, INPUT is too late and NFQUEUE can't tell kernel to do nat.

You could do what you want by placing NFQUEUE in raw PREROUTING,
but in that case all packets would get queued to userspace because
no conntrack information is available yet.

But if you create the conntrack entry, then after accept verdict the
kernel would find the conntrack entry in place and perform nat for it.

It would be possible to extend nfnetlink_queue to also allow changing
NAT properties of a conntrack entry provided the conntrack has not been
confirmed yet but it would require kernel changes.

So, best option afaics is to use libnetfilter_conntrack to insert
a new conntrack entry from the nfq callback.
