Return-Path: <SRS0=rcIs=DG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E76EC4727C
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 14:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED9782074B
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 14:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601390515;
	bh=rlxZTqkHGASpy0VXo23eN5mfvz25J2rFjnkZaQYej98=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=glYt8xJKdNlh7Enik1sxijDYpeu9MQCC5wOORlxVqVCG91rOVCEWn/Qy2i2iCZ2zu
	 U+0rZGoxAtsoMZnRlkNyX/Hj3NPHVdkDk/hFOeOSG2FsGTacMAvErmhu8LyULFUkcN
	 SgHYJ24FaSIBZgIrWSBSa7aR2uD9xpH/qN7F1q4Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbgI2Olv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 10:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728844AbgI2Olv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 10:41:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D10E2074F;
        Tue, 29 Sep 2020 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601390511;
        bh=rlxZTqkHGASpy0VXo23eN5mfvz25J2rFjnkZaQYej98=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yHDdlYwRzUhkbZyyYtV9YYBHku6hBE2UeNGym6GDDJAcRStczYOZxy/AnZ+8oUrjN
         PSywjhxEz3cqeijhgVPHGrSRiy1a55BMBsc330tzRttZe72castSolnes7h7hhW2TM
         OXpRUbNSiadzUlh+wgrxXzdHR1tkMM1Hrz5SaBfI=
Date:   Tue, 29 Sep 2020 07:41:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "longguang.yue" <bigclouds@163.com>
Cc:     yuelongguang@gmail.com, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ipvs: Add traffic statistic up even it is VS/DR or
 VS/TUN mode
Message-ID: <20200929074110.33d7d740@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200929081811.32302-1-bigclouds@163.com>
References: <20200929050302.28105-1-bigclouds@163.com>
        <20200929081811.32302-1-bigclouds@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 29 Sep 2020 16:18:11 +0800 longguang.yue wrote:
> @@ -411,10 +413,17 @@ struct ip_vs_conn *ip_vs_conn_out_get(const struct ip_vs_conn_param *p)
>  	rcu_read_lock();
>  
>  	hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[hash], c_list) {
> -		if (p->vport == cp->cport && p->cport == cp->dport &&
> +		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ){
> +			cport = cp->vport;

checkpatch says:

ERROR: space required before the open brace '{'
#25: FILE: net/netfilter/ipvs/ip_vs_core.c:1416:
+		if (IP_VS_FWD_METHOD(cp) != IP_VS_CONN_F_MASQ){
