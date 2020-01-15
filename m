Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409DEC33CB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 09:29:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E5ED207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 09:29:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgAOJ3M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 04:29:12 -0500
Received: from correo.us.es ([193.147.175.20]:48952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgAOJ3M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 04:29:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C4E6BFF9A5
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2020 10:29:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5653DA716
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2020 10:29:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B49D9DA712; Wed, 15 Jan 2020 10:29:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B1D66DA709;
        Wed, 15 Jan 2020 10:29:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 Jan 2020 10:29:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 971A742EF42A;
        Wed, 15 Jan 2020 10:29:07 +0100 (CET)
Date:   Wed, 15 Jan 2020 10:29:07 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 09/10] netfilter: bitwise: add
 NFTA_BITWISE_DATA attribute.
Message-ID: <20200115092907.subrj56hcjgtywze@salvia>
References: <20200114212918.134062-1-jeremy@azazel.net>
 <20200114212918.134062-10-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114212918.134062-10-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 14, 2020 at 09:29:17PM +0000, Jeremy Sowden wrote:
> Add a new bitwise netlink attribute that will be used by shift
> operations to store the size of the shift.  It is not used by boolean
> operations.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  include/uapi/linux/netfilter/nf_tables.h | 2 ++
>  net/netfilter/nft_bitwise.c              | 5 +++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index cfda75725455..7cb85fd0d38e 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -503,6 +503,7 @@ enum nft_bitwise_ops {
>   * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
>   * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
>   * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
> + * @NFTA_BITWISE_DATA: argument for non-boolean operations (NLA_U32)
>   *
>   * The bitwise expression performs the following operation:
>   *
> @@ -524,6 +525,7 @@ enum nft_bitwise_attributes {
>  	NFTA_BITWISE_MASK,
>  	NFTA_BITWISE_XOR,
>  	NFTA_BITWISE_OP,
> +	NFTA_BITWISE_DATA,
>  	__NFTA_BITWISE_MAX
>  };
>  #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> index 1d9079ba2102..72abaa83a8ca 100644
> --- a/net/netfilter/nft_bitwise.c
> +++ b/net/netfilter/nft_bitwise.c
> @@ -22,6 +22,7 @@ struct nft_bitwise {
>  	u8			len;
>  	struct nft_data		mask;
>  	struct nft_data		xor;
> +	u32			data;

Could you make this struct nft_data?

We can extend later on nft_bitwise to more operations. I was
considering to (ab)use bitwise to implement increment and decrement. I
think u32 should be enough in most cases, but I'd prefer to stick to
one 128 bit word in this case. For shift this is obviously too much,
but this would be leaving room for new operations requiring something
larger than u32.
