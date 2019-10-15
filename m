Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81046C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D87C20854
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733169AbfJOPwt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:52:49 -0400
Received: from correo.us.es ([193.147.175.20]:49638 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728624AbfJOPws (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 11:52:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D14DC1A16
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:52:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F329CA0F2
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:52:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5413BD2B1D; Tue, 15 Oct 2019 17:52:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52A46DA840;
        Tue, 15 Oct 2019 17:52:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 17:52:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3020E42EE38E;
        Tue, 15 Oct 2019 17:52:42 +0200 (CEST)
Date:   Tue, 15 Oct 2019 17:52:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 3/6] set_elem: Validate nftnl_set_elem_set()
 parameters
Message-ID: <20191015155244.int6uix23brc4iug@salvia>
References: <20191015141658.11325-1-phil@nwl.cc>
 <20191015141658.11325-4-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015141658.11325-4-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 04:16:55PM +0200, Phil Sutter wrote:
> Copying from nftnl_table_set_data(), validate input to
> nftnl_set_elem_set() as well. Given that for some attributes the
> function assumes passed data size, this seems necessary.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Before pushing out this, see below.

> ---
>  include/libnftnl/set.h |  2 ++
>  src/set_elem.c         | 10 ++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> index 6640ad929f346..2ea2e9a56ce4f 100644
> --- a/include/libnftnl/set.h
> +++ b/include/libnftnl/set.h
> @@ -104,7 +104,9 @@ enum {
>  	NFTNL_SET_ELEM_USERDATA,
>  	NFTNL_SET_ELEM_EXPR,
>  	NFTNL_SET_ELEM_OBJREF,
> +	__NFTNL_SET_ELEM_MAX
>  };
> +#define NFTNL_SET_ELEM_MAX (__NFTNL_SET_ELEM_MAX - 1)
>  
>  struct nftnl_set_elem;
>  
> diff --git a/src/set_elem.c b/src/set_elem.c
> index 3794f12594079..4225a96ee5a0a 100644
> --- a/src/set_elem.c
> +++ b/src/set_elem.c
> @@ -96,10 +96,20 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
>  	s->flags &= ~(1 << attr);
>  }
>  
> +static uint32_t nftnl_set_elem_validate[NFTNL_SET_ELEM_MAX + 1] = {
> +	[NFTNL_SET_ELEM_FLAGS]		= sizeof(uint32_t),
> +	[NFTNL_SET_ELEM_VERDICT]	= sizeof(int), /* FIXME: data.verdict is int?! */

This is uint32_t, update this before pushing out this.

> +	[NFTNL_SET_ELEM_TIMEOUT]	= sizeof(uint64_t),
> +	[NFTNL_SET_ELEM_EXPIRATION]	= sizeof(uint64_t),
> +};
> +
>  EXPORT_SYMBOL(nftnl_set_elem_set);
>  int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
>  		       const void *data, uint32_t data_len)
>  {
> +	nftnl_assert_attr_exists(attr, NFTNL_SET_ELEM_MAX);
> +	nftnl_assert_validate(data, nftnl_set_elem_validate, attr, data_len);
> +
>  	switch(attr) {
>  	case NFTNL_SET_ELEM_FLAGS:
>  		memcpy(&s->set_elem_flags, data, sizeof(s->set_elem_flags));
> -- 
> 2.23.0
> 
