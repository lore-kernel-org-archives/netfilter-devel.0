Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE162C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 13:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82AC2071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 13:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbfKRNJj convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 08:09:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32440 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726178AbfKRNJj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 08:09:39 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-zWw1agpiNyOiBNw13u3MQQ-1; Mon, 18 Nov 2019 08:09:35 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85D98100EF0E;
        Mon, 18 Nov 2019 13:09:34 +0000 (UTC)
Received: from egarver (ovpn-121-25.rdu2.redhat.com [10.10.121.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02359627DF;
        Mon, 18 Nov 2019 13:09:33 +0000 (UTC)
Date:   Mon, 18 Nov 2019 08:09:32 -0500
From:   Eric Garver <eric@garver.life>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnftnl] flowtable: remove NFTA_FLOWTABLE_SIZE
Message-ID: <20191118130932.2hxeegeplgv52kui@egarver>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191115215421.5023-1-pablo@netfilter.org>
MIME-Version: 1.0
In-Reply-To: <20191115215421.5023-1-pablo@netfilter.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: zWw1agpiNyOiBNw13u3MQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 15, 2019 at 10:54:21PM +0100, Pablo Neira Ayuso wrote:
> Never defined in upstream Linux kernel uAPI, remove it.
> 
> Reported-by: Eric Garver <eric@garver.life>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/linux/netfilter/nf_tables.h | 2 --
>  src/flowtable.c                     | 6 ------
>  2 files changed, 8 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 81c27d3c9ffd..bb9b049310df 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -1518,7 +1518,6 @@ enum nft_object_attributes {
>   * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
>   * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
>   * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
> - * @NFTA_FLOWTABLE_SIZE: maximum size (NLA_U32)
>   * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
>   */
>  enum nft_flowtable_attributes {
> @@ -1529,7 +1528,6 @@ enum nft_flowtable_attributes {
>  	NFTA_FLOWTABLE_USE,
>  	NFTA_FLOWTABLE_HANDLE,
>  	NFTA_FLOWTABLE_PAD,
> -	NFTA_FLOWTABLE_SIZE,
>  	NFTA_FLOWTABLE_FLAGS,
>  	__NFTA_FLOWTABLE_MAX
>  };
> diff --git a/src/flowtable.c b/src/flowtable.c
> index ec89b952e47d..324e80f7e6ad 100644
> --- a/src/flowtable.c
> +++ b/src/flowtable.c
> @@ -324,8 +324,6 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
>  		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_FLAGS, htonl(c->ft_flags));
>  	if (c->flags & (1 << NFTNL_FLOWTABLE_USE))
>  		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_USE, htonl(c->use));
> -	if (c->flags & (1 << NFTNL_FLOWTABLE_SIZE))
> -		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_SIZE, htonl(c->size));
>  	if (c->flags & (1 << NFTNL_FLOWTABLE_HANDLE))
>  		mnl_attr_put_u64(nlh, NFTA_FLOWTABLE_HANDLE, htobe64(c->handle));
>  }
> @@ -489,10 +487,6 @@ int nftnl_flowtable_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_flowtab
>  		c->use = ntohl(mnl_attr_get_u32(tb[NFTA_FLOWTABLE_USE]));
>  		c->flags |= (1 << NFTNL_FLOWTABLE_USE);
>  	}
> -	if (tb[NFTA_FLOWTABLE_SIZE]) {
> -		c->size = ntohl(mnl_attr_get_u32(tb[NFTA_FLOWTABLE_SIZE]));
> -		c->flags |= (1 << NFTNL_FLOWTABLE_SIZE);
> -	}
>  	if (tb[NFTA_FLOWTABLE_HANDLE]) {
>  		c->handle = be64toh(mnl_attr_get_u64(tb[NFTA_FLOWTABLE_HANDLE]));
>  		c->flags |= (1 << NFTNL_FLOWTABLE_HANDLE);
> -- 
> 2.11.0

Thanks Pablo.

Acked-by: Eric Garver <eric@garver.life>

