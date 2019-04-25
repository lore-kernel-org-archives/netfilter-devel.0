Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3A1C282E3
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 09:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D6C217FA
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 09:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="ClO0D8w/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbfDYJIu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 05:08:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41727 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfDYJIt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 05:08:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id c12so23039618wrt.8
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2019 02:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8LZXN+8KU6xgMDFTMJ8Q2B9/CuRynw4V0u0ml9fm/c8=;
        b=ClO0D8w/Us+bSJBvlXAo+SKmusDbeHQhGjnO3gQdqkzTnsoU34vdxsWZVJ6dzx/Fl8
         K8cpTDOGFaJc2CQryUlMVqcLoBfHU0gBLBtAKgFgerNEwBXacfVjl4TljFsHUMmoiyG4
         xul7Ol3WcTpCYwD5j5WNEdur1/os3RnY2oKNqV8ZmRVYwl7P3UakvWZvk4cMwZT9ycBg
         t6/HuFNhvZSuMY+K09nLKP3qStiYV8vhVcdClItzK4VdHkvLsmdfBTqsBUjzQONK3yu1
         1JeGWTIV2mqkMEz1vfUTvEMrhIvVaSTO/Q5PSbopJGjRCgwKSgBi2twM1iGgJ1ONcNAn
         aS5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8LZXN+8KU6xgMDFTMJ8Q2B9/CuRynw4V0u0ml9fm/c8=;
        b=fnQrimeUFKnvgH06Ok6RsZnEvyuDiVRGfXTO7H6PhbOUpSv242gZ0pOrBeyky+rjsD
         LpafRXPAl1Q8qOvmFyKJ3O4AEroox9SJB5Pxxq6o3krCezWdLDvdN+iWohpNzenGafrH
         ZF6tsj9PG6Ea86xGGcs9vA4CUc/ET0sB9DBAMgpXOFnNFNUxfvPHsKxI0Why+gAN8Prk
         6hwMin2eU5tWCgTfSVhFNl9zqDPIP6BRax+J6VPp30oM4xqclAH3Mv8Or7R4b/jFgf18
         b4f4KUQrcLLeR4WQZsl51efviZbzcaMEAzrokht7klnWGRdmA8ua6V/iTrzCMY//rzXu
         R33Q==
X-Gm-Message-State: APjAAAVlK5pR+sif92j91LK1l7sg2SETNJxDOJX5btM7LdZW3ikWne0n
        7Lwbh1zWlUYP2Xu1d/CZ9mAo3Q==
X-Google-Smtp-Source: APXvYqxA/Qf5qIRMOWQaI6ds0SVbVZXPWJveWY03KiTcSvBsIVs4iYEkYLhNVqjPfvuO4k1hY9D6RQ==
X-Received: by 2002:a05:6000:12c7:: with SMTP id l7mr23567228wrx.4.1556183327952;
        Thu, 25 Apr 2019 02:08:47 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id r6sm15774477wmc.11.2019.04.25.02.08.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Apr 2019 02:08:47 -0700 (PDT)
Date:   Thu, 25 Apr 2019 11:08:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/3] make nla_nest_start() add NLA_F_NESTED
 flag
Message-ID: <20190425090846.GC3951@nanopsycho>
References: <cover.1556140270.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1556140270.git.mkubecek@suse.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wed, Apr 24, 2019 at 11:34:21PM CEST, mkubecek@suse.cz wrote:
>One of the comments in recent review of the ethtool netlink series pointed
>out that proposed ethnl_nest_start() helper which adds NLA_F_NESTED to
>second argument of nla_nest_start() is not really specific to ethtool
>netlink code. That is hard to argue with as closer inspection revealed that
>exactly the same helper already exists in ipset code (except it's a macro
>rather than an inline function).
>
>Another observation was that even if NLA_F_NESTED flag was introduced in
>2007, only few netlink based interfaces set it in kernel generated messages
>and even many recently added APIs omit it. That is unfortunate as without
>the flag, message parsers not familiar with attribute semantics cannot
>recognize nested attributes and do not see message structure; this affects
>e.g. wireshark dissector or mnl_nlmsg_fprintf() from libmnl.
>
>This is why I'm suggesting to rename existing nla_nest_start() to different
>name (nla_nest_start_noflag) and reintroduce nla_nest_start() as a wrapper
>adding NLA_F_NESTED flag. This is implemented in first patch which is
>mostly generated by spatch. Second patch drops ipset helper macros which
>lose their purpose. Third patch cleans up minor coding style issues found
>by checkpatch.pl in first patch.
>
>If this approach is considered too intrusive, we can leave nla_nest_start()
>untouched and simply add a wrapper adding NLA_F_NESTED but that would
>probably preserve the state when even most new code doesn't set the flag.

I like this. Long overdue...
