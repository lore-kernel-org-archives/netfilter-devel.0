Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B4CC10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DA0020854
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728624AbfJOP5V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:57:21 -0400
Received: from correo.us.es ([193.147.175.20]:51832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfJOP5V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 11:57:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4190BA1B1
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:57:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C667CDA8E8
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:57:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BBF1DDA801; Tue, 15 Oct 2019 17:57:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C1B81D1911;
        Tue, 15 Oct 2019 17:57:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 17:57:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A1B4C42EE38E;
        Tue, 15 Oct 2019 17:57:14 +0200 (CEST)
Date:   Tue, 15 Oct 2019 17:57:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 5/6] obj/ct_timeout: Avoid array overrun in
 timeout_parse_attr_data()
Message-ID: <20191015155716.n5amfyrcs5pe42cd@salvia>
References: <20191015141658.11325-1-phil@nwl.cc>
 <20191015141658.11325-6-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015141658.11325-6-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 04:16:57PM +0200, Phil Sutter wrote:
> Array 'tb' has only 'attr_max' elements, the loop overstepped its
> boundary by one. Copy array_size() macro from include/utils.h in
> nftables.git to make sure code does the right thing.
> 
> Fixes: 0adceeab1597a ("src: add ct timeout support")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/utils.h      | 8 ++++++++
>  src/obj/ct_timeout.c | 2 +-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/utils.h b/include/utils.h
> index 3cc659652fe2e..91fbebb1956fd 100644
> --- a/include/utils.h
> +++ b/include/utils.h
> @@ -58,6 +58,14 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
>  		ret = remain;				\
>  	remain -= ret;					\
>  
> +
> +#define BUILD_BUG_ON_ZERO(e)	(sizeof(char[1 - 2 * !!(e)]) - 1)
> +
> +#define __must_be_array(a) \
> +	BUILD_BUG_ON_ZERO(__builtin_types_compatible_p(typeof(a), typeof(&a[0])))
> +
> +#define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
> +
>  const char *nftnl_family2str(uint32_t family);
>  int nftnl_str2family(const char *family);
>  
> diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
> index a439432deee18..a09e25ae5d44f 100644
> --- a/src/obj/ct_timeout.c
> +++ b/src/obj/ct_timeout.c
> @@ -134,7 +134,7 @@ timeout_parse_attr_data(struct nftnl_obj *e,
>  	if (mnl_attr_parse_nested(nest, parse_timeout_attr_policy_cb, &cnt) < 0)
>  		return -1;
>  
> -	for (i = 1; i <= attr_max; i++) {
> +	for (i = 1; i < array_size(tb); i++) {

Are you sure this is correct?

array use NFTNL_CTTIMEOUT_* while tb uses netlink NFTA_* attributes.

>  		if (tb[i]) {
>  			nftnl_timeout_policy_attr_set_u32(e, i-1,
>  				ntohl(mnl_attr_get_u32(tb[i])));
> -- 
> 2.23.0
> 
