Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E79EC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Feb 2022 00:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiBRAGO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 19:06:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiBRAFz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 19:05:55 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E25750479;
        Thu, 17 Feb 2022 16:05:35 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id j12so16270300ybh.8;
        Thu, 17 Feb 2022 16:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1b3R4PmIE+LoqveblWnosi/2gsm7ieCpBCaquGk7eNc=;
        b=O1ReGt6OyItd0l+2qzTdz4kjQFiranmvYkSI3ZhAHafP6xRDLnGiej9iriSvjmciaY
         tEV3eynvsB/i1iaGw88QyezIC8yeThET2ReI3GlEWuouGHFFBfsjjqjfzlofaRk1EPAr
         mnJn9OfCOAousRt1IEsUA80HDubQXDVTYAM6uHGqgFm6ctgdL8iePgFgVw2vk8sNFBBt
         rxeJBQInrc9mTdKvH3LldXZJZ4TO+hpdCknVpdK7Cgnk4hlufEcCovZOxQtZCMLWPIch
         SI8DdA29VyFrpOVPd2nOe7syGnw3nRzeElm2OggVbcTfM9MODh4vdEq6qtuOvCPGPKzu
         SaEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1b3R4PmIE+LoqveblWnosi/2gsm7ieCpBCaquGk7eNc=;
        b=NuqfyHFY3PP0NX6mDB+LsXqd9+f4ceCK0WVuCEVCdk8UGkHr3rbUJPop3EeK7OFvUg
         7Do1NsZJ8h0MxO2f/9Dy6xnnr2E2/ZBz5AAa/qbs3LqTvEnFlE7doTQrdqUuzf/ZgaiQ
         aU7k9nFKTaRx9ocTuiy/0ePGfAdlFl01kf2HGuh3pDC7ivaIYFSus111arMVIXYMm8KF
         xlI+jpnDYHZHwCKcTNSqkCJXFEWjZDUkrkfjEJnPiuU5hxlE3jzHQR1O/FMOvMgNdVdl
         jFbFyfqtaSgnjekkb9uwGAhQrl080EvVPanOl6d2S1LIi2KMUlKWjYqrMy6684f2URB1
         liOw==
X-Gm-Message-State: AOAM531N9owIhMbe7uKNszVBUN20yyy5gJv/6HTyL9kuo9shuNOrwFLB
        bpv13wfSQTB0Rd4sD5E39kPSIxq9aLlrWw==
X-Google-Smtp-Source: ABdhPJxuYnWRcjSVo5eCzjBJ8ZbOKPwkzHK1nDvdX0f0//7KxEmvGgVF/YSamCN2Ll7BfjsuIaD5Ng==
X-Received: by 2002:a9d:198d:0:b0:5ad:bbb:682e with SMTP id k13-20020a9d198d000000b005ad0bbb682emr1749413otk.360.1645140430411;
        Thu, 17 Feb 2022 15:27:10 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:d388:56d5:efed:1209:97f5])
        by smtp.gmail.com with ESMTPSA id o15sm362992ooi.31.2022.02.17.15.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 15:27:10 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 86D50167748; Thu, 17 Feb 2022 20:27:08 -0300 (-03)
Date:   Thu, 17 Feb 2022 20:27:08 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Paul Blakey <paulb@nvidia.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        davem@davemloft.net, Jiri Pirko <jiri@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>, coreteam@netfilter.org
Subject: Re: [PATCH net 1/1] net/sched: act_ct: Fix flow table lookup failure
 with no originating ifindex
Message-ID: <20220217232708.yhigtv2ssrlfsexs@t14s.localdomain>
References: <20220217093424.23601-1-paulb@nvidia.com>
 <Yg5Tz5ucVAI3zOTs@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg5Tz5ucVAI3zOTs@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Feb 17, 2022 at 02:55:27PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 17, 2022 at 11:34:24AM +0200, Paul Blakey wrote:
> > After cited commit optimizted hw insertion, flow table entries are
> > populated with ifindex information which was intended to only be used
> > for HW offload. This tuple ifindex is hashed in the flow table key, so
> > it must be filled for lookup to be successful. But tuple ifindex is only
> > relevant for the netfilter flowtables (nft), so it's not filled in
> > act_ct flow table lookup, resulting in lookup failure, and no SW
> > offload and no offload teardown for TCP connection FIN/RST packets.
> > 
> > To fix this, allow flow tables that don't hash the ifindex.
> > Netfilter flow tables will keep using ifindex for a more specific
> > offload, while act_ct will not.
> 
> Using iif == zero should be enough to specify not set?

You mean, when searching, if search input iif == zero, to simply not
check it? That seems dangerous somehow.
