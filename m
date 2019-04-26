Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA05C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 10:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14B82206A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 10:51:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="tkzzJ5Ar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfDZKvV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 06:51:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43258 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfDZKvU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 06:51:20 -0400
Received: by mail-wr1-f67.google.com with SMTP id a12so3782517wrq.10
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 03:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oYR47EfvfB3INLmcV5CUtMqytev5exvJp3sCteIx6Jo=;
        b=tkzzJ5ArDKyVndEsWm9NfYy6jIFvMjy2MOiy+V2/BVHUWkjsLUMeCSgupRDE7ADW42
         b8rGLn+n1ijUVg++vw46kEbWhqxm2UO19JEA+m+khiJDXgOzMOrbmPVAhbE4LndekdXZ
         /HPncxDU3FMFAmIedbJ9WdnHMKqEB8OR5zt3e/pRChA/1nG8OXifkc5/u+AwdTFkss0n
         r+OJt9O393b71vghxaUpXsDvVNpbSqEs3TADOZjKzfppN+POw6F+5JVLn5ZlX+JCSKER
         QiyzU7nwmS6T9hj1+aGANbQxNpNpAKAvI6ZMenvj/3HnGyNKu/Mh/z9g4GkBSAPmog2O
         /jLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oYR47EfvfB3INLmcV5CUtMqytev5exvJp3sCteIx6Jo=;
        b=j0+Bz6+t7W6QKvKu/aQDvfaD6Hq695JIQurTMxGsB8tROdzIPkfKMV6ZXOatrSWKE3
         LTTbP4qRQ1x4u9pFf8TiVCkQYuh6CgZ9JgFWa/MNlWOd2u0tkChqxyXnvslhVBQhoAxY
         a0CQlKbSktgHCpoL1mwrAqEsmUuwFJXU6HZMvniMMW2uQCqmpaHz69Gnt4ohsM8NmpqD
         zsimIbjlYbL9RFsWYNQcpHXfKfArkOyd+ppXsm+adjg7pP/nKxTknxzkG5FYZzKURDRX
         Vg+fwIAO1cga0t0sGF5UQy/xoFC8h+x2ON66MWA2d5kMNEDVqj5yn+wMG/OE7yai/RUa
         urxw==
X-Gm-Message-State: APjAAAWrmIlJ3WTnm5j8f9iQDYBLk7e0EN+/r8ddPKI/uNsWXAgjD2nz
        swLKhvklVFS8OhoNOqtDn4Q8AQ==
X-Google-Smtp-Source: APXvYqxc3sSTifRyeC9QxLaeoo+g1CWCCxOG+uRy15EAEjhf47mlHUSqTdsvhCTvGQS+S2CBqI5Vmw==
X-Received: by 2002:a5d:53c8:: with SMTP id a8mr7068895wrw.38.1556275879248;
        Fri, 26 Apr 2019 03:51:19 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id u5sm2756099wml.4.2019.04.26.03.51.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Apr 2019 03:51:18 -0700 (PDT)
Date:   Fri, 26 Apr 2019 12:51:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] netlink: make nla_nest_start() add
 NLA_F_NESTED flag
Message-ID: <20190426105117.GA2157@nanopsycho>
References: <cover.1556269635.git.mkubecek@suse.cz>
 <5278b013a953d4fb2e7944fc810f783d70ea52a5.1556269635.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278b013a953d4fb2e7944fc810f783d70ea52a5.1556269635.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fri, Apr 26, 2019 at 11:13:06AM CEST, mkubecek@suse.cz wrote:
>Even if the NLA_F_NESTED flag was introduced more than 11 years ago, most
>netlink based interfaces (including recently added ones) are still not
>setting it in kernel generated messages. Without the flag, message parsers
>not aware of attribute semantics (e.g. wireshark dissector or libmnl's
>mnl_nlmsg_fprintf()) cannot recognize nested attributes and won't display
>the structure of their contents.
>
>Unfortunately we cannot just add the flag everywhere as there may be
>userspace applications which check nlattr::nla_type directly rather than
>through a helper masking out the flags. Therefore the patch renames
>nla_nest_start() to nla_nest_start_noflag() and introduces nla_nest_start()
>as a wrapper adding NLA_F_NESTED. The calls which add NLA_F_NESTED manually
>are rewritten to use nla_nest_start().
>
>Except for changes in include/net/netlink.h, the patch was generated using
>this semantic patch:
>
>@@ expression E1, E2; @@
>-nla_nest_start(E1, E2)
>+nla_nest_start_noflag(E1, E2)
>
>@@ expression E1, E2; @@
>-nla_nest_start_noflag(E1, E2 | NLA_F_NESTED)
>+nla_nest_start(E1, E2)
>
>Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Acked-by: Jiri Pirko <jiri@mellanox.com>
