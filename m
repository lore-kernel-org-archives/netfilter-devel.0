Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8906DC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E72A2084D
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 10:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389146AbgFXK65 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 06:58:57 -0400
Received: from correo.us.es ([193.147.175.20]:47212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389088AbgFXK64 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 06:58:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 97746E8E84
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:58:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 89404DA78D
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 12:58:55 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7D2AADA78B; Wed, 24 Jun 2020 12:58:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 575C7DA789;
        Wed, 24 Jun 2020 12:58:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 12:58:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 38FF342EF42C;
        Wed, 24 Jun 2020 12:58:53 +0200 (CEST)
Date:   Wed, 24 Jun 2020 12:58:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel =?iso-8859-1?Q?Gr=F6ber?= <dxld@darkboxed.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnf_ct resend PATCH 6/8] Fix buffer overflow on invalid icmp
 type in setters
Message-ID: <20200624105852.GB20575@salvia>
References: <20200623123403.31676-1-dxld@darkboxed.org>
 <20200623123403.31676-7-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623123403.31676-7-dxld@darkboxed.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 23, 2020 at 02:34:01PM +0200, Daniel Gröber wrote:
> When type is out of range for the invmap_icmp{,v6} array we leave rtype at
> zero which will map to type=255 just like other error cases in this
> function.
> 
> Signed-off-by: Daniel Gröber <dxld@darkboxed.org>
> ---
>  src/conntrack/grp_setter.c |  8 +++++---
>  src/conntrack/setter.c     | 11 +++++++----
>  2 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/src/conntrack/grp_setter.c b/src/conntrack/grp_setter.c
> index fccf578..dfbdc91 100644
> --- a/src/conntrack/grp_setter.c
> +++ b/src/conntrack/grp_setter.c
> @@ -85,18 +85,20 @@ static void set_attr_grp_repl_port(struct nf_conntrack *ct, const void *value)
>  
>  static void set_attr_grp_icmp(struct nf_conntrack *ct, const void *value)
>  {
> -	uint8_t rtype;
> +	uint8_t rtype = 0;
>  	const struct nfct_attr_grp_icmp *this = value;
>  
>  	ct->head.orig.l4dst.icmp.type = this->type;
>  
>  	switch(ct->head.orig.l3protonum) {
>  		case AF_INET:
> -			rtype = invmap_icmp[this->type];
> +			if(this->type < asizeof(invmap_icmp))
> +				rtype = invmap_icmp[this->type];

Probably add a small helper function for this?

static inline uint8_t icmp_invmap(uint8_t type)
{
        assert(this->type < ARRAY_SIZE(invmap_icmp));

        return invmap_icmp[this->type];
}

> diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
> index 0157de4..ed65ba0 100644
> --- a/src/conntrack/setter.c
> +++ b/src/conntrack/setter.c
> @@ -124,17 +124,20 @@ set_attr_repl_zone(struct nf_conntrack *ct, const void *value, size_t len)
>  static void
>  set_attr_icmp_type(struct nf_conntrack *ct, const void *value, size_t len)
>  {
> -	uint8_t rtype;
> +        uint8_t type = *((uint8_t *) value);
> +	uint8_t rtype = 0;
>  
> -	ct->head.orig.l4dst.icmp.type = *((uint8_t *) value);
> +	ct->head.orig.l4dst.icmp.type = type;
>  
>  	switch(ct->head.orig.l3protonum) {
>  		case AF_INET:
> -			rtype = invmap_icmp[*((uint8_t *) value)];
> +                        if(type < asizeof(invmap_icmp))
> +                                rtype = invmap_icmp[type];

Make sure indentation tab is 8-char instead of spaces.

Thanks.
