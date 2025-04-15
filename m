Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA842DFA3A
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 18:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.252.153.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744740183; cv=none; b=Ae2H56/RL6Wg3BI5AOiPDYtZ6HJioHbyGkdnq16QfMsH4khxOnwFj6nUHCS6h84u4FO8pXZYMlpdQzyG4vMqiQtQalcHy0qPgotYwf4K7Cw2tViVkyyPwfQMMQmnW3y2j20Sczq4PwpzzKtSPd0ngnlBpVU3ejYg7yM4Kbkf8k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744740183; c=relaxed/simple;
	bh=rp6ouUx7C1S7etjLAfzMnN2t7KGJ82oQol6oWVpZNsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t4Z9zVmwihV/uBJw82A3IqqfXRuQOwQmtrvIsX+Ys5yVfRu688+PnbYovQBsQXtbUABmCEG/2a8LSFEoBredodN/VnNVwNfoBuVwVnVlUCPPKoBNsFXrYszwQkmI093ebPo7YkC3SP4Y8nUEbCZ5BKhr2I//mZzd/QMxtwXXEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net; spf=pass smtp.mailfrom=riseup.net; dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b=aDS+XGP5; arc=none smtp.client-ip=198.252.153.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riseup.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riseup.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="aDS+XGP5"
Received: from fews01-sea.riseup.net (fews01-sea-pn.riseup.net [10.0.1.109])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx0.riseup.net (Postfix) with ESMTPS id 4ZcX7n3LRnz9x16;
	Tue, 15 Apr 2025 18:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
	t=1744740181; bh=rp6ouUx7C1S7etjLAfzMnN2t7KGJ82oQol6oWVpZNsM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aDS+XGP5hGOlQk8RIjnvmGbTREYXf5VWjZJfL47D9rUxedDvoAfO2dcLGa2VpN9Dl
	 NIRV3pFk0SHkMBSiksAc8I898qQo47eja18o45s7bwA6OcfgiB3cLJ1aVaD8rRoPnb
	 /4KDV4t2RXAYZRi6+y7RYvnc19qv3Krruihaz1cA=
X-Riseup-User-ID: 3028CC693BB20178A4CD5A7E8BF64AD9B42B48E5CA8460F535BDB896ACA8F739
Received: from [127.0.0.1] (localhost [127.0.0.1])
	 by fews01-sea.riseup.net (Postfix) with ESMTPSA id 4ZcX7m56PvzJtt0;
	Tue, 15 Apr 2025 18:03:00 +0000 (UTC)
Message-ID: <55a55750-4eaf-4a0d-ac17-aafe865723e7@riseup.net>
Date: Tue, 15 Apr 2025 20:02:58 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 libnftnl] tunnel: add support to geneve
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
References: <20250415175643.4060-1-ffmancera@riseup.net>
 <20250415175643.4060-2-ffmancera@riseup.net>
Content-Language: en-US
From: Fernando Fernandez Mancera <ffmancera@riseup.net>
In-Reply-To: <20250415175643.4060-2-ffmancera@riseup.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/15/25 7:56 PM, Fernando Fernandez Mancera wrote:
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>   include/libnftnl/object.h |   5 ++
>   include/obj.h             |   6 +++
>   src/obj/tunnel.c          | 103 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 114 insertions(+)
> 
> diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
> index 9930355..0c695ea 100644
> --- a/include/libnftnl/object.h
> +++ b/include/libnftnl/object.h
> @@ -117,9 +117,14 @@ enum {
>   	NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX,
>   	NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID,
>   	NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR,
> +	NFTNL_OBJ_TUNNEL_GENEVE_CLASS,
> +	NFTNL_OBJ_TUNNEL_GENEVE_TYPE,
> +	NFTNL_OBJ_TUNNEL_GENEVE_DATA,
>   	__NFTNL_OBJ_TUNNEL_MAX,
>   };
>   
> +#define NFTNL_TUNNEL_GENEVE_DATA_MAXLEN	126
> +

I just noticed this should be 127.. anyway, it doesn't matter much as 
any length not divisible by 4 will be an invalid argument on kernel side 
so 127 won't make a difference. Maybe 124 is better?

>   enum {
>   	NFTNL_OBJ_SECMARK_CTX	= NFTNL_OBJ_BASE,
>   	__NFTNL_OBJ_SECMARK_MAX,
> diff --git a/include/obj.h b/include/obj.h
> index fc78e2a..e6c1cbf 100644
> --- a/include/obj.h
> +++ b/include/obj.h
> @@ -92,6 +92,12 @@ struct nftnl_obj {
>   						} v2;
>   					} u;
>   				} tun_erspan;
> +				struct {
> +					uint16_t	geneve_class;
> +					uint8_t		type;
> +					uint8_t		data[NFTNL_TUNNEL_GENEVE_DATA_MAXLEN];
> +					uint32_t	data_len;
> +				} tun_geneve;
>   			} u;
>   		} tunnel;
>   		struct nftnl_obj_secmark {
> diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
> index 8941e39..27a6acd 100644
> --- a/src/obj/tunnel.c
> +++ b/src/obj/tunnel.c
> @@ -72,6 +72,16 @@ nftnl_obj_tunnel_set(struct nftnl_obj *e, uint16_t type,
>   	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
>   		memcpy(&tun->u.tun_erspan.u.v2.dir, data, data_len);
>   		break;
> +	case NFTNL_OBJ_TUNNEL_GENEVE_CLASS:
> +		memcpy(&tun->u.tun_geneve.geneve_class, data, data_len);
> +		break;
> +	case NFTNL_OBJ_TUNNEL_GENEVE_TYPE:
> +		memcpy(&tun->u.tun_geneve.type, data, data_len);
> +		break;
> +	case NFTNL_OBJ_TUNNEL_GENEVE_DATA:
> +		memcpy(&tun->u.tun_geneve.data, data, data_len);
> +		tun->u.tun_geneve.data_len = data_len;
> +		break;
>   	}
>   	return 0;
>   }
> @@ -131,6 +141,15 @@ nftnl_obj_tunnel_get(const struct nftnl_obj *e, uint16_t type,
>   	case NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR:
>   		*data_len = sizeof(tun->u.tun_erspan.u.v2.dir);
>   		return &tun->u.tun_erspan.u.v2.dir;
> +	case NFTNL_OBJ_TUNNEL_GENEVE_CLASS:
> +		*data_len = sizeof(tun->u.tun_geneve.geneve_class);
> +		return &tun->u.tun_geneve.geneve_class;
> +	case NFTNL_OBJ_TUNNEL_GENEVE_TYPE:
> +		*data_len = sizeof(tun->u.tun_geneve.type);
> +		return &tun->u.tun_geneve.type;
> +	case NFTNL_OBJ_TUNNEL_GENEVE_DATA:
> +		*data_len = tun->u.tun_geneve.data_len;
> +		return &tun->u.tun_geneve.data;
>   	}
>   	return NULL;
>   }
> @@ -240,6 +259,21 @@ nftnl_obj_tunnel_build(struct nlmsghdr *nlh, const struct nftnl_obj *e)
>   		mnl_attr_nest_end(nlh, nest_inner);
>   		mnl_attr_nest_end(nlh, nest);
>   	}
> +	if (e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_CLASS) &&
> +	    e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_TYPE) &&
> +	    e->flags & (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_DATA)) {
> +		nest = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS);
> +		nest_inner = mnl_attr_nest_start(nlh, NFTA_TUNNEL_KEY_OPTS_GENEVE);
> +		mnl_attr_put_u16(nlh, NFTA_TUNNEL_KEY_GENEVE_CLASS,
> +				 htons(tun->u.tun_geneve.geneve_class));
> +		mnl_attr_put_u8(nlh, NFTA_TUNNEL_KEY_GENEVE_TYPE,
> +				tun->u.tun_geneve.type);
> +		mnl_attr_put(nlh, NFTA_TUNNEL_KEY_GENEVE_DATA,
> +			     tun->u.tun_geneve.data_len,
> +			     tun->u.tun_geneve.data);
> +		mnl_attr_nest_end(nlh, nest_inner);
> +		mnl_attr_nest_end(nlh, nest);
> +	}
>   }
>   
>   static int nftnl_obj_tunnel_ip_cb(const struct nlattr *attr, void *data)
> @@ -335,6 +369,68 @@ static int nftnl_obj_tunnel_parse_ip6(struct nftnl_obj *e, struct nlattr *attr,
>   	return 0;
>   }
>   
> +static int nftnl_obj_tunnel_geneve_cb(const struct nlattr *attr, void *data)
> +{
> +	const struct nlattr **tb = data;
> +	int type = mnl_attr_get_type(attr);
> +
> +	if (mnl_attr_type_valid(attr, NFTA_TUNNEL_KEY_GENEVE_MAX) < 0)
> +		return MNL_CB_OK;
> +
> +	switch (type) {
> +	case NFTA_TUNNEL_KEY_GENEVE_CLASS:
> +		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
> +			abi_breakage();
> +		break;
> +	case NFTA_TUNNEL_KEY_GENEVE_TYPE:
> +		if (mnl_attr_validate(attr, MNL_TYPE_U8) < 0)
> +			abi_breakage();
> +		break;
> +	case NFTA_TUNNEL_KEY_GENEVE_DATA:
> +		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
> +			abi_breakage();
> +		break;
> +	}
> +
> +	tb[type] = attr;
> +	return MNL_CB_OK;
> +}
> +
> +static int
> +nftnl_obj_tunnel_parse_geneve(struct nftnl_obj *e, struct nlattr *attr,
> +			      struct nftnl_obj_tunnel *tun)
> +{
> +	struct nlattr *tb[NFTA_TUNNEL_KEY_GENEVE_MAX + 1] = {};
> +
> +	if (mnl_attr_parse_nested(attr, nftnl_obj_tunnel_geneve_cb, tb) < 0)
> +		return -1;
> +
> +	if (tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]) {
> +		tun->u.tun_geneve.geneve_class =
> +			ntohs(mnl_attr_get_u16(tb[NFTA_TUNNEL_KEY_GENEVE_CLASS]));
> +		e->flags |= (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_CLASS);
> +	}
> +
> +	if (tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]) {
> +		tun->u.tun_geneve.type =
> +			mnl_attr_get_u8(tb[NFTA_TUNNEL_KEY_GENEVE_TYPE]);
> +		e->flags |= (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_TYPE);
> +	}
> +
> +	if (tb[NFTA_TUNNEL_KEY_GENEVE_DATA]) {
> +		uint32_t len = mnl_attr_get_payload_len(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]);
> +
> +		memcpy(tun->u.tun_geneve.data,
> +		       mnl_attr_get_payload(tb[NFTA_TUNNEL_KEY_GENEVE_DATA]),
> +		       len);
> +		tun->u.tun_geneve.data_len = len;
> +
> +		e->flags |= (1ULL << NFTNL_OBJ_TUNNEL_GENEVE_DATA);
> +	}
> +
> +	return 0;
> +}
> +
>   static int nftnl_obj_tunnel_vxlan_cb(const struct nlattr *attr, void *data)
>   {
>   	const struct nlattr **tb = data;
> @@ -441,6 +537,7 @@ static int nftnl_obj_tunnel_opts_cb(const struct nlattr *attr, void *data)
>   	switch (type) {
>   	case NFTA_TUNNEL_KEY_OPTS_VXLAN:
>   	case NFTA_TUNNEL_KEY_OPTS_ERSPAN:
> +	case NFTA_TUNNEL_KEY_OPTS_GENEVE:
>   		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
>   			abi_breakage();
>   		break;
> @@ -466,6 +563,9 @@ nftnl_obj_tunnel_parse_opts(struct nftnl_obj *e, struct nlattr *attr,
>   	} else if (tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN]) {
>   		err = nftnl_obj_tunnel_parse_erspan(e, tb[NFTA_TUNNEL_KEY_OPTS_ERSPAN],
>   						    tun);
> +	} else if (tb[NFTA_TUNNEL_KEY_OPTS_GENEVE]) {
> +		err = nftnl_obj_tunnel_parse_geneve(e, tb[NFTA_TUNNEL_KEY_OPTS_GENEVE],
> +						    tun);
>   	}
>   
>   	return err;
> @@ -549,6 +649,9 @@ static struct attr_policy obj_tunnel_attr_policy[__NFTNL_OBJ_TUNNEL_MAX] = {
>   	[NFTNL_OBJ_TUNNEL_ERSPAN_V1_INDEX] = { .maxlen = sizeof(uint32_t) },
>   	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_HWID] = { .maxlen = sizeof(uint8_t) },
>   	[NFTNL_OBJ_TUNNEL_ERSPAN_V2_DIR] = { .maxlen = sizeof(uint8_t) },
> +	[NFTNL_OBJ_TUNNEL_GENEVE_CLASS]	= { .maxlen = sizeof(uint16_t) },
> +	[NFTNL_OBJ_TUNNEL_GENEVE_TYPE]	= { .maxlen = sizeof(uint8_t) },
> +	[NFTNL_OBJ_TUNNEL_GENEVE_DATA]	= { .maxlen = NFTNL_TUNNEL_GENEVE_DATA_MAXLEN},
>   };
>   
>   struct obj_ops obj_ops_tunnel = {

