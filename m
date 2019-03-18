Return-Path: <SRS0=5Ubq=RV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4292C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 03:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9763A2085A
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Mar 2019 03:23:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cn59wRrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfCRDXD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Mar 2019 23:23:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35699 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727699AbfCRDXD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Mar 2019 23:23:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id j5so10300746pfa.2;
        Sun, 17 Mar 2019 20:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7p//1PR5F/sgyDj76MSBQjRYE5FlynCqfv62Ie5Gow8=;
        b=cn59wRrAp5A+zB8KgE+uWFKMDkFIDNuj5W9La9KiX3AWNv0YbpN4J28/uT3K90s14W
         kQyOL9AAscoPfFUqRa+Kg7sTjQ0Kcje+pEx6kBGE8Qx/yY2Iqa4T7bvs3joS6CEtWA5n
         ohtumfXYqI6yjgZJalWSVoV/8/3v438c9wzsjDACAkW7gqQrUXvSdaH/tmAGkzFEDXvv
         VLeVQz+NdqlzSyB1VaIChVZr1cCRq++nk581Ni4Lxb7ZB9P/UrGnMvCE5u0hIrhy0Qav
         Jch/aOf0V67zX7R97cGG8p+7WexQ6E3QbKTFn/ESRSoFS1uNCUU+u0tw7TUBI9Qnf5g0
         HpXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7p//1PR5F/sgyDj76MSBQjRYE5FlynCqfv62Ie5Gow8=;
        b=IMeiKhItNb0ImCaVO21WHCFDirOeoZjnkYCo9Ko+Sz1YcirOdOvQtIwj9XO+qN8GcU
         GPtJUdryy7TWaFRO4iVBGjuxHGqIpqmb6s27xaItL+Gl7T+Xxx8JxeMjb16ENBM/J29X
         ktg2C2jnJP4ICaiy0VPnI+kfVy5f0IX866HCZoL1XyGX5KoAlvvAgfMxtjNHrvJivK3J
         CsLgYWXXZzu5/xXeWAXZdqmBFdPYXFqgCmEzezgvuxvOJnLZ1szpz9MD7TF9eGaY3LRD
         SQlx6vWJUuyW4al913dx3UWbRw8QAsaZXsWc4DYc3F2D6Ly6zKfIfeLqm9eqL8TupKC8
         GxNw==
X-Gm-Message-State: APjAAAUAUGpsDTZhez2x4LKEyN3DsIa089L3UC2emo8IRNTnQq+rW+NV
        5V1Dj6xe8Tc7uWhu1ziuhQ==
X-Google-Smtp-Source: APXvYqxSrI436CjuM8FHWOSocoMZyZrHUlYdFoW3Pw9MUYq7V+yB3sCzEYzONmvgmd567KtR0W3jhQ==
X-Received: by 2002:a17:902:56a:: with SMTP id 97mr17410615plf.320.1552879381789;
        Sun, 17 Mar 2019 20:23:01 -0700 (PDT)
Received: from localhost (2.172.220.35.bc.googleusercontent.com. [35.220.172.2])
        by smtp.gmail.com with ESMTPSA id d3sm8994197pfc.125.2019.03.17.20.22.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Mar 2019 20:23:00 -0700 (PDT)
Date:   Mon, 18 Mar 2019 11:22:56 +0800
From:   Jacky Hu <hengqing.hu@gmail.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, jacky.hu@walmart.com, jason.niesz@walmart.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v4] ipvs: allow tunneling with gue encapsulation
Message-ID: <20190318032256.GA21124@i716>
References: <20190317155200.16586-1-hengqing.hu@gmail.com>
 <201903181001.7czsRhlB%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201903181001.7czsRhlB%lkp@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 18, 2019 at 10:10:20AM +0800, kbuild test robot wrote:
> Hi Jacky,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on ipvs-next/master]
> [also build test WARNING on v5.1-rc1 next-20190306]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Jacky-Hu/ipvs-allow-tunneling-with-gue-encapsulation/20190318-070156
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git master
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
> 
> 
> sparse warnings: (new ones prefixed by >>)
> 
>    net/netfilter/ipvs/ip_vs_ctl.c:835:42: sparse: incorrect type in argument 2 (different base types) @@    expected int [signed] i @@    got restricted __be1int [signed] i @@
>    net/netfilter/ipvs/ip_vs_ctl.c:835:42:    expected int [signed] i
>    net/netfilter/ipvs/ip_vs_ctl.c:835:42:    got restricted __be16 [usertype] tun_port
>    net/netfilter/ipvs/ip_vs_ctl.c:1197:44: sparse: expression using sizeof(void)
> >> net/netfilter/ipvs/ip_vs_ctl.c:3207:37: sparse: incorrect type in argument 3 (different base types) @@    expected restricted __be16 [usertype] value @@    got e] value @@
>    net/netfilter/ipvs/ip_vs_ctl.c:3207:37:    expected restricted __be16 [usertype] value
>    net/netfilter/ipvs/ip_vs_ctl.c:3207:37:    got int
>    net/netfilter/ipvs/ip_vs_ctl.c:1313:27: sparse: dereference of noderef expression
> 
> vim +3207 net/netfilter/ipvs/ip_vs_ctl.c
> 
>   3187	
>   3188	static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
>   3189	{
>   3190		struct nlattr *nl_dest;
>   3191		struct ip_vs_kstats kstats;
>   3192	
>   3193		nl_dest = nla_nest_start(skb, IPVS_CMD_ATTR_DEST);
>   3194		if (!nl_dest)
>   3195			return -EMSGSIZE;
>   3196	
>   3197		if (nla_put(skb, IPVS_DEST_ATTR_ADDR, sizeof(dest->addr), &dest->addr) ||
>   3198		    nla_put_be16(skb, IPVS_DEST_ATTR_PORT, dest->port) ||
>   3199		    nla_put_u32(skb, IPVS_DEST_ATTR_FWD_METHOD,
>   3200				(atomic_read(&dest->conn_flags) &
>   3201				 IP_VS_CONN_F_FWD_MASK)) ||
>   3202		    nla_put_u32(skb, IPVS_DEST_ATTR_WEIGHT,
>   3203				atomic_read(&dest->weight)) ||
>   3204		    nla_put_u8(skb, IPVS_DEST_ATTR_TUN_TYPE,
>   3205			       atomic_read(&dest->tun_type)) ||
>   3206		    nla_put_be16(skb, IPVS_DEST_ATTR_TUN_PORT,
> > 3207				 atomic_read(&dest->tun_port)) ||

    Should I change the type of tun_port from __be16 to u16?
    Looks like kbuild bugs a lot on this.

>   3208		    nla_put_u32(skb, IPVS_DEST_ATTR_U_THRESH, dest->u_threshold) ||
>   3209		    nla_put_u32(skb, IPVS_DEST_ATTR_L_THRESH, dest->l_threshold) ||
>   3210		    nla_put_u32(skb, IPVS_DEST_ATTR_ACTIVE_CONNS,
>   3211				atomic_read(&dest->activeconns)) ||
>   3212		    nla_put_u32(skb, IPVS_DEST_ATTR_INACT_CONNS,
>   3213				atomic_read(&dest->inactconns)) ||
>   3214		    nla_put_u32(skb, IPVS_DEST_ATTR_PERSIST_CONNS,
>   3215				atomic_read(&dest->persistconns)) ||
>   3216		    nla_put_u16(skb, IPVS_DEST_ATTR_ADDR_FAMILY, dest->af))
>   3217			goto nla_put_failure;
>   3218		ip_vs_copy_stats(&kstats, &dest->stats);
>   3219		if (ip_vs_genl_fill_stats(skb, IPVS_DEST_ATTR_STATS, &kstats))
>   3220			goto nla_put_failure;
>   3221		if (ip_vs_genl_fill_stats64(skb, IPVS_DEST_ATTR_STATS64, &kstats))
>   3222			goto nla_put_failure;
>   3223	
>   3224		nla_nest_end(skb, nl_dest);
>   3225	
>   3226		return 0;
>   3227	
>   3228	nla_put_failure:
>   3229		nla_nest_cancel(skb, nl_dest);
>   3230		return -EMSGSIZE;
>   3231	}
>   3232	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
