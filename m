Return-Path: <SRS0=FgsC=SC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1221BC10F06
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 22:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D446A2084B
	for <netfilter-devel@archiver.kernel.org>; Sun, 31 Mar 2019 22:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfCaWHt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 31 Mar 2019 18:07:49 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:41251 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbfCaWHt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 31 Mar 2019 18:07:49 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hAicC-0007kt-KZ; Mon, 01 Apr 2019 00:07:46 +0200
Date:   Mon, 1 Apr 2019 00:07:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Flavio Leitner <fbl@sysclose.org>
Cc:     netdev@vger.kernel.org, Joe Stringer <joe@ovn.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/8] netfilter: use macros to create module
 aliases.
Message-ID: <20190331220743.uwlpdr77cpuhh7fb@salvia>
References: <20190326205715.22288-1-fbl@sysclose.org>
 <20190326205715.22288-2-fbl@sysclose.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326205715.22288-2-fbl@sysclose.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 26, 2019 at 05:57:08PM -0300, Flavio Leitner wrote:
> Each NAT helper creates a module alias which follows a pattern.
> Use macros for consistency.
> 
> Signed-off-by: Flavio Leitner <fbl@sysclose.org>
> ---
>  include/net/netfilter/nf_conntrack_helper.h | 4 ++++
>  net/ipv4/netfilter/nf_nat_h323.c            | 2 +-
>  net/ipv4/netfilter/nf_nat_pptp.c            | 2 +-
>  net/netfilter/nf_nat_amanda.c               | 2 +-
>  net/netfilter/nf_nat_ftp.c                  | 2 +-
>  net/netfilter/nf_nat_irc.c                  | 2 +-
>  net/netfilter/nf_nat_sip.c                  | 2 +-
>  net/netfilter/nf_nat_tftp.c                 | 2 +-
>  8 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
> index ec52a8dc32fd..e86fadf7e7c5 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -15,6 +15,10 @@
>  #include <net/netfilter/nf_conntrack_extend.h>
>  #include <net/netfilter/nf_conntrack_expect.h>
>  
> +#define NF_CT_NAT_HELPER_MOD_NAME(name)	"ip_nat_" name

I'd suggest a rename from NF_CT_NAT_HELPER_MOD_NAME() to
NF_NAT_HELPER_NAME().

Please, also use "nf_nat_" prefix instead, "ip_nat" is legacy stuff.

> +#define MODULE_ALIAS_NFCT_HELPER_NAT(name) \
> +	MODULE_ALIAS(NF_CT_NAT_HELPER_MOD_NAME(name))

Probably:

        MODULE_ALIAS_NF_NAT_HELPER

instead of MODULE_ALIAS_NFCT_HELPER_NAT.
