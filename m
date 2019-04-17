Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96333C10F12
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 08:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 628A82054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 08:02:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="GyOoXYjk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfDQICv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:02:51 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40391 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbfDQICv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 04:02:51 -0400
Received: by mail-pg1-f196.google.com with SMTP id d31so11631183pgl.7
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 01:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=5OmcLxs+6ap9qXsYo6r9CEMetiIlBxlqFVbPLd7Tdkc=;
        b=GyOoXYjk0rSW5DrOrUFZp+s/xMpDkZm3D8uexzZMgJuXvSnD7ecOU1ZptSOe46Y47o
         Ak2mRHyNv9X4H3usGaopTr5JPbMDTEQ7MQ4sUAK3pW7DFvD/TzH0mMWKyK2ePKezAcKC
         u459cApaa3YFqpH+fsXk4gWAmubd9lmLGaFFEoaFJnwF/SXxLPF4DURCs1nW+/modYZj
         6oVjP6cgaMdjjfKtPOHfLIymCwreUBtdFi7OyD0n9vpylj9THL5sUUlV/VhSsgauIspF
         7ah9fxuQwpmS1FfSk6bw0aOM9Uip8nwif98wKsWSGzU3SgtifRln/AITfHJzfWNi8Vim
         RRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5OmcLxs+6ap9qXsYo6r9CEMetiIlBxlqFVbPLd7Tdkc=;
        b=Na+GVaDvYwaexuR2gJ0hRcvwH84U1Z6FnTFReQ90ZGJYvj50kAbpLl+BIR5Dv6ZYxb
         vSAhRbXd3uTJURORR0w3pya4c0PkEzTXTVgzwkxuN1pWndcfmhI02l2YtEDZyJZJJrc/
         c+bdeLIpBfEJ7T0n5ahRFT4e4yrHDe9brhHNk4Y3wxJLEq0xryeFyCswsfw/FvRYWWRx
         MCvtekcK2svL/+550mRu1oXDgXcmYjMsSJOCuY4T9oh3tlloWzXtbPwWTIcub+N6fQep
         nDc3C4DZVlnPlp9ValSd+AqhA1GbsWrEwbXtRwwgN249P3V5CBTWiRZ5hq9Js0sgsH6P
         EGMw==
X-Gm-Message-State: APjAAAU+vswt2/WGuJ/XdpDqf4Wy9enVK0YPyFFmjWf26CZ9UPvuhE5q
        wQX+OWlD/jDYyY4/p53fR4Dowg==
X-Google-Smtp-Source: APXvYqwbPpVWscMSFucp4GgYZMDx7RRLX1ouAyd0UVlJy4H+NAapaSnXljH3gR+5jUs9tIdvndVJHg==
X-Received: by 2002:a63:7444:: with SMTP id e4mr82289609pgn.261.1555488169941;
        Wed, 17 Apr 2019 01:02:49 -0700 (PDT)
Received: from bytedancedeMacBook-Air.local ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id q11sm72334699pgs.94.2019.04.17.01.02.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 01:02:49 -0700 (PDT)
Date:   Wed, 17 Apr 2019 16:02:44 +0800
From:   Xiaozhou Liu <liuxiaozhou@bytedance.com>
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, zhangyongsu@bytedance.com,
        wenxudong@bytedance.com
Subject: RFC: NAT's default behavior of forwarding un-NATed packets
Message-ID: <20190417080242.jas4vongrv5fivzx@bytedancedeMacBook-Air.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180323
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

We find that our SNAT sometimes forwards un-NATed packets out as-is. This
behavior confused us for a while until we saw this in
net/netfilter/nf_nat_core.c:

       ct = nf_ct_get(skb, &ctinfo);
       /* Can't track?  It's not due to stress, or conntrack would
        * have dropped it.  Hence it's the user's responsibilty to
        * packet filter it out, or implement conntrack/NAT for that
        * protocol. 8) --RR
        */
       if (!ct)
              return NF_ACCEPT;

The code and comment are very clear. So it is not kernel's responsibility,
at least in RR's point of view. We added filtering shortly afterwards.

But as normal users, we really want a NAT server which can work out of box as
expected from users' point of view. That said, if any packet that is bad (in
our case, orphaned SYN-ACK and FIN packets going out without getting a chance
to setup conntrack), it's better to drop them in kernel by default.

Is there any possibility to change this default behavior?

Any comments on this is appreciated.


Thanks,
Xiaozhou
