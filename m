Return-Path: <SRS0=FgsC=SC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DECC10F06
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 22:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A3082085A
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 22:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbfCaWMK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 31 Mar 2019 18:12:10 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:40540 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731324AbfCaWMJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 31 Mar 2019 18:12:09 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hAigQ-0007nW-LT; Mon, 01 Apr 2019 00:12:08 +0200
Date:   Mon, 1 Apr 2019 00:12:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 2/8] netfilter: add API to manage NAT helpers.
Message-ID: <20190331221206.fowjnjpaeofgq5it@salvia>
References: <20190326205715.22288-1-fbl@sysclose.org>
 <20190326205715.22288-3-fbl@sysclose.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326205715.22288-3-fbl@sysclose.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 26, 2019 at 05:57:09PM -0300, Flavio Leitner wrote:
[...]
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 274baf1dab87..883a8d438503 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -42,6 +42,9 @@ module_param_named(nf_conntrack_helper, nf_ct_auto_assign_helper, bool, 0644);
>  MODULE_PARM_DESC(nf_conntrack_helper,
>  		 "Enable automatic conntrack helper assignment (default 0)");
>  
> +static struct list_head nf_ct_nat_helpers __read_mostly;
> +static DEFINE_SPINLOCK(nf_ct_nat_helpers_lock);

Why a spinlock here? Use mutex instead I'd suggest.

Thanks.
