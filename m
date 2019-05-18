Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935E1C04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 20:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E41C204FD
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 20:38:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="pUYcw71C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfERUi2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 16:38:28 -0400
Received: from mx1.riseup.net ([198.252.153.129]:36954 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbfERUi2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 16:38:28 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id C22EA1A22E5;
        Sat, 18 May 2019 13:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1558211907; bh=BUhSo8QoLXR8ntliUiG/YPvanuzeQr1xhVoFuQAqM5k=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=pUYcw71CIuX7bhmvUHl+0XKKQsW7pFLdjguWInEAvaw9P30QH9AY0snf+4Q8DMZV3
         QZPPwqR/4TEyJEgDwtt9bVKDY33A+rvGEsHeDjIQMbbthxv/ILtNRlemVRAQxGuTfn
         6IZ8A8EDHj1RUznX86yOfQNf7ES5gvuBPhQOeQgY=
X-Riseup-User-ID: 43B5F4FF1EEB35706D7DCBC65B7C3E98A4C63C254E1E271D53B4364268589F12
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id DC322120ED1;
        Sat, 18 May 2019 13:38:26 -0700 (PDT)
Date:   Sat, 18 May 2019 22:38:19 +0200
In-Reply-To: <20190518202032.2bjv4e547kli56c6@breakpoint.cc>
References: <20190518182151.1231-1-ffmancera@riseup.net> <20190518182151.1231-5-ffmancera@riseup.net> <20190518202032.2bjv4e547kli56c6@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 4/5 nf-next] netfilter: synproxy: extract IPv6 SYNPROXY infrastructure from ip6t_SYNPROXY
To:     Florian Westphal <fw@strlen.de>
CC:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <0719D27E-7E34-4DD5-8D1A-7B34794F272E@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

El 18 de mayo de 2019 22:20:32 CEST, Florian Westphal <fw@strlen=2Ede> esc=
ribi=C3=B3:
>Fernando Fernandez Mancera <ffmancera@riseup=2Enet> wrote:
>
>Hi Fernando
>
>> +void
>> +synproxy_send_client_synack_ipv6(struct net *net,
>> +				 const struct sk_buff *skb,
>> +				 const struct tcphdr *th,
>> +				 const struct synproxy_options *opts)
>
>[=2E=2E]
>
>> +	nth->seq	=3D htonl(__cookie_v6_init_sequence(iph, th, &mss));
>
>It seems that __cookie_v6_init_sequence() is the only dependency of
>this module on ipv6=2E
>
>If we would make it accessible via nf_ipv6_ops struct, then the
>dependency goes away and we could place ipv4 and ipv6 parts in a
>single module=2E
>
>Just saying, it would avoid adding extra modules=2E

This would be awesome but I am not sure if it is possible right now=2E I a=
m going to try it and send a new patch series=2E Thank you  about this!

>We could then have
>
>nf_synproxy=2Eko  # shared code
>nft_synproxy=2Eko # nftables frontend
>xt_SYNPROXY=2Eko	# ip(6)tables frontends

In this case, ip6t_synproxy wouldn't need to select IPV6 Cookie module rig=
ht? Thanks!
