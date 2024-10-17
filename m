Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942471388
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2024 05:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729144555; cv=none; b=XIWmP9Un0D17flNUY3sxBjwCtoMQmI2D4YSeN/6I+OCDkIyftdvucJbDFgvKOs5aObyv2jjokfPoVcep9sOJ0o8YJJjlMkYpn5VBt3JSI74pMF1z+CjfV7p4n1cRTmEsBjUM8FmQtFv4xdiJtfQ7a7WY7AoxnbILiBw5S49of0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729144555; c=relaxed/simple;
	bh=Ujq8TV4eGfZTQmoCwFzod1oWacCB7HTV6Iki8MTdSks=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h3Z1klgNGkMwkPLKRnczRHgbb7ulRIcLmQzp+6S10t2ZOeY+35vdqClQR3KeUonHox1tR5BM7SluT/JGIEC2OILUfsPFoM5pACt9gXLNPWEWJsfk3O6bM6BQjqC1lbrI1PbDDReRL3hVUZyHKYoCsenvZDOf1dthxwUQ29ZY3Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FWTAquES; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWTAquES"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e2ed59a35eso512108a91.0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 22:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729144552; x=1729749352; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C/2rbafnfynJsQcbHaUXYG/7nB2m9AA+D9sTXbgJeG8=;
        b=FWTAquESZf1O1PDQGnoLeAjvdqqbF6teQSL+XH/0HfPipxEuDBo7RarQsLwslfizxq
         HACCPlAWIxnmhSRcojDy5zWZUjy3TMOwjxghsHd9kjcA8GGBwk1HfDf5e2LWW/ZLgP2o
         uc1YUCaKF+ijJFUxJBBaFDPm32aBdYiiVXpqIS907WRjRMgrJoQYGeQFKfNlJivdUPIa
         RR+IxsBkPtU4yRUgufH7WpWJ1P7IRPbVP4achIbj1VFO1vxsT6mhamppnGxnaAJQN1/w
         8WoLC3a/FviIZBg/0IaUkyJfy6/g2Y1M/RrPof6iJOjcS+5TDsE5z0dQ4k/4BOV0ZogU
         LAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729144552; x=1729749352;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C/2rbafnfynJsQcbHaUXYG/7nB2m9AA+D9sTXbgJeG8=;
        b=NpkwMo4QpJiDUTeMDaWek6lyImEdxBkAU6J0dqCi8HFPpJQ6UViFQDW7CGpSJUbEWQ
         HupmWq/F085r8vAPSZlQ+trOJ4PkmIuV6uf10KPrgAPme+dArZPoYuL6Fmmcl0ReHuGT
         2DrJXBMmwi4q13aGt2BJbwmCrRkk610gUHZSgKLWFCC0Rk0XbHnxN8i93OmZOCblyHsE
         xJxBv1w/vuD5ylBSwvfo0l7RXAX/RfPEXp+lGc0RhnIFRRkCjlJe311SAvD6bBUxXnvS
         Rq6s9+UH4HKiJx6yv/DFDDVOSj5XZ8nvS+I3b7gSjRlEdbp685rmyw2I/LYGg0zOp23s
         Tstg==
X-Gm-Message-State: AOJu0YyGAnunmSDxX8Gmb3LbUXyTK7MUub8WXEIrip5KDmUm3GjJIh8f
	0f7NWa/Y5ZgTYpQXTq3Kg5qMD+Pzwx1MitgwpqKxXpKaLRAtWlkcW9D/hg==
X-Google-Smtp-Source: AGHT+IGt8uTqziPJH6swZmXsGzimlRVFjkSyAWU+sVeciPGa+EjomQN4AzBWQr7Bt7w8VoRZwy8tZw==
X-Received: by 2002:a17:90b:17c2:b0:2e2:dd25:9b00 with SMTP id 98e67ed59e1d1-2e3ab821dc7mr7760731a91.22.1729144551685;
        Wed, 16 Oct 2024 22:55:51 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e3df467c61sm1049010a91.0.2024.10.16.22.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 22:55:51 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Thu, 17 Oct 2024 16:55:47 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnftnl] include: refresh nf_tables.h copy
Message-ID: <ZxCm45kYRQu77bWX@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241010125858.1540-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010125858.1540-1-pablo@netfilter.org>

Hi Pablo,

Sorry for late review - found this email in my spam folder.

On Thu, Oct 10, 2024 at 02:58:58PM +0200, Pablo Neira Ayuso wrote:
> Fetch what we have in the kernel tree.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/linux/netfilter/nf_tables.h | 46 +++++++++++++++++++++++------
>  1 file changed, 37 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index c48b19333630..9e9079321380 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
> @@ -97,6 +97,15 @@ enum nft_verdicts {
>   * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
>   * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
>   * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
> + * @NFT_MSG_GETRULE_RESET: get rules and reset stateful expressions (enum nft_obj_attributes)
> + * @NFT_MSG_DESTROYTABLE: destroy a table (enum nft_table_attributes)
> + * @NFT_MSG_DESTROYCHAIN: destroy a chain (enum nft_chain_attributes)
> + * @NFT_MSG_DESTROYRULE: destroy a rule (enum nft_rule_attributes)
> + * @NFT_MSG_DESTROYSET: destroy a set (enum nft_set_attributes)
> + * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
> + * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
> + * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
> + * @NFT_MSG_GETSETELEM_RESET: get set elements and reset attached stateful expressions (enum nft_set_elem_attributes)
>   */
>  enum nf_tables_msg_types {
>  	NFT_MSG_NEWTABLE,
> @@ -124,6 +133,15 @@ enum nf_tables_msg_types {
>  	NFT_MSG_NEWFLOWTABLE,
>  	NFT_MSG_GETFLOWTABLE,
>  	NFT_MSG_DELFLOWTABLE,
> +	NFT_MSG_GETRULE_RESET,
> +	NFT_MSG_DESTROYTABLE,
> +	NFT_MSG_DESTROYCHAIN,
> +	NFT_MSG_DESTROYRULE,
> +	NFT_MSG_DESTROYSET,
> +	NFT_MSG_DESTROYSETELEM,
> +	NFT_MSG_DESTROYOBJ,
> +	NFT_MSG_DESTROYFLOWTABLE,
> +	NFT_MSG_GETSETELEM_RESET,
>  	NFT_MSG_MAX,
>  };
>
> @@ -161,13 +179,17 @@ enum nft_hook_attributes {
>   * enum nft_table_flags - nf_tables table flags
>   *
>   * @NFT_TABLE_F_DORMANT: this table is not active
> + * @NFT_TABLE_F_OWNER:   this table is owned by a process
> + * @NFT_TABLE_F_PERSIST: this table shall outlive its owner
>   */
>  enum nft_table_flags {
>  	NFT_TABLE_F_DORMANT	= 0x1,
>  	NFT_TABLE_F_OWNER	= 0x2,
> +	NFT_TABLE_F_PERSIST	= 0x4,
>  };
>  #define NFT_TABLE_F_MASK	(NFT_TABLE_F_DORMANT | \
> -				 NFT_TABLE_F_OWNER)
> +				 NFT_TABLE_F_OWNER | \
> +				 NFT_TABLE_F_PERSIST)
>
>  /**
>   * enum nft_table_attributes - nf_tables table netlink attributes
> @@ -245,6 +267,7 @@ enum nft_chain_attributes {
>   * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
>   * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
>   * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
> + * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
>   */
>  enum nft_rule_attributes {
>  	NFTA_RULE_UNSPEC,
> @@ -266,9 +289,11 @@ enum nft_rule_attributes {
>  /**
>   * enum nft_rule_compat_flags - nf_tables rule compat flags
>   *
> + * @NFT_RULE_COMPAT_F_UNUSED: unused
>   * @NFT_RULE_COMPAT_F_INV: invert the check result
>   */
>  enum nft_rule_compat_flags {
> +	NFT_RULE_COMPAT_F_UNUSED = (1 << 0),
>  	NFT_RULE_COMPAT_F_INV	= (1 << 1),
>  	NFT_RULE_COMPAT_F_MASK	= NFT_RULE_COMPAT_F_INV,
>  };
> @@ -411,7 +436,7 @@ enum nft_set_elem_flags {
>   * @NFTA_SET_ELEM_KEY: key value (NLA_NESTED: nft_data)
>   * @NFTA_SET_ELEM_DATA: data value of mapping (NLA_NESTED: nft_data_attributes)
>   * @NFTA_SET_ELEM_FLAGS: bitmask of nft_set_elem_flags (NLA_U32)
> - * @NFTA_SET_ELEM_TIMEOUT: timeout value (NLA_U64)
> + * @NFTA_SET_ELEM_TIMEOUT: timeout value, zero means never times out (NLA_U64)
>   * @NFTA_SET_ELEM_EXPIRATION: expiration time (NLA_U64)
>   * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
>   * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
> @@ -669,7 +694,7 @@ enum nft_range_ops {
>   * enum nft_range_attributes - nf_tables range expression netlink attributes
>   *
>   * @NFTA_RANGE_SREG: source register of data to compare (NLA_U32: nft_registers)
> - * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_cmp_ops)
> + * @NFTA_RANGE_OP: cmp operation (NLA_U32: nft_range_ops)
>   * @NFTA_RANGE_FROM_DATA: data range from (NLA_NESTED: nft_data_attributes)
>   * @NFTA_RANGE_TO_DATA: data range to (NLA_NESTED: nft_data_attributes)
>   */
> @@ -783,6 +808,7 @@ enum nft_payload_csum_flags {
>  enum nft_inner_type {
>  	NFT_INNER_UNSPEC	= 0,
>  	NFT_INNER_VXLAN,
> +	NFT_INNER_GENEVE,
>  };
>
>  enum nft_inner_flags {
> @@ -792,7 +818,7 @@ enum nft_inner_flags {
>  	NFT_INNER_TH		= (1 << 3),
>  };
>  #define NFT_INNER_MASK		(NFT_INNER_HDRSIZE | NFT_INNER_LL | \
> -				 NFT_INNER_NH |  NFT_INNER_TH)
> +				 NFT_INNER_NH | NFT_INNER_TH)
>
>  enum nft_inner_attributes {
>  	NFTA_INNER_UNSPEC,
> @@ -842,12 +868,14 @@ enum nft_exthdr_flags {
>   * @NFT_EXTHDR_OP_TCP: match against tcp options
>   * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
>   * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
> + * @NFT_EXTHDR_OP_DCCP: match against dccp otions
>   */
>  enum nft_exthdr_op {
>  	NFT_EXTHDR_OP_IPV6,
>  	NFT_EXTHDR_OP_TCPOPT,
>  	NFT_EXTHDR_OP_IPV4,
>  	NFT_EXTHDR_OP_SCTP,
> +	NFT_EXTHDR_OP_DCCP,
>  	__NFT_EXTHDR_OP_MAX
>  };
>  #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
> @@ -861,7 +889,7 @@ enum nft_exthdr_op {
>   * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
>   * @NFTA_EXTHDR_FLAGS: extension header flags (NLA_U32)
>   * @NFTA_EXTHDR_OP: option match type (NLA_U32)
> - * @NFTA_EXTHDR_SREG: option match type (NLA_U32)
> + * @NFTA_EXTHDR_SREG: source register (NLA_U32: nft_registers)
>   */
>  enum nft_exthdr_attributes {
>  	NFTA_EXTHDR_UNSPEC,
> @@ -1245,10 +1273,10 @@ enum nft_last_attributes {
>  /**
>   * enum nft_log_attributes - nf_tables log expression netlink attributes
>   *
> - * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
> + * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U16)
>   * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
>   * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
> - * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
> + * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U16)
>   * @NFTA_LOG_LEVEL: log level (NLA_U32)
>   * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
>   */
> @@ -1348,7 +1376,7 @@ enum nft_secmark_attributes {
>  #define NFTA_SECMARK_MAX	(__NFTA_SECMARK_MAX - 1)
>
>  /* Max security context length */
> -#define NFT_SECMARK_CTX_MAXLEN		256
> +#define NFT_SECMARK_CTX_MAXLEN		4096
>
>  /**
>   * enum nft_reject_types - nf_tables reject expression reject types
> @@ -1666,7 +1694,7 @@ enum nft_flowtable_flags {
>   *
>   * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
>   * @NFTA_FLOWTABLE_NAME: name of this flow table (NLA_STRING)
> - * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
> + * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration (NLA_NESTED)
>   * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
>   * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
>   * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
> --
> 2.30.2
>
>
Suggest a better patch would be to delete this file.

linux/netfilter/nf_tables.h is generated by kernel `make headers_install`, as is
linux/errno.h (required by errno.h) and asm/socket.h (required by sys/socket.h).

We don't cache linux/errno.h or asm/socket.h, so why cache
linux/netfilter/nf_tables.h?

Cheers ... Duncan.
