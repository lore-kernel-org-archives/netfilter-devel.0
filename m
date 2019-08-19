Return-Path: <SRS0=DEFU=WP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29235C41514
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 13:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D531620843
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Aug 2019 13:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="TvrPzTRx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfHSNRB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Aug 2019 09:17:01 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39972 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfHSNRA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Aug 2019 09:17:00 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id A0D0E1A0687;
        Mon, 19 Aug 2019 06:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566220619; bh=mhb6wAkb61/nV4M3CPwdz+LRGUNsLaCKR6vYY1lESxU=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=TvrPzTRxzGrndIySb+cUGSM4zPnNNZiYEumGXmJVxt1KFzCzEnGLL2u+ab+t+OHNI
         HmXbKN3KufjRqdos7iTOLifWMENglY4xshDPCv81vY2qXmg57bYjMCGg/Tis9sKHq2
         3djpfKg+I6sTvcqcwr1tLa3q72Zn1SAwJRdtaHPg=
X-Riseup-User-ID: 72232D3F2F87FE4214167E3DCA87B346FFE0CD08C1C618B24380A316848CD8DF
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 805F22238EF;
        Mon, 19 Aug 2019 06:16:58 -0700 (PDT)
Date:   Mon, 19 Aug 2019 15:16:51 +0200
In-Reply-To: <20190819115527.GH2588@breakpoint.cc>
References: <20190819111914.10514-1-ffmancera@riseup.net> <20190819115527.GH2588@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH WIP nf-next] netfilter: nf_tables: Introduce stateful object update operation
To:     Florian Westphal <fw@strlen.de>
CC:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <84BAB422-02BE-48D8-9805-79B4810D6194@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

El 19 de agosto de 2019 13:55:27 CEST, Florian Westphal <fw@strlen=2Ede> e=
scribi=C3=B3:
>Fernando Fernandez Mancera <ffmancera@riseup=2Enet> wrote:
>> This is a WIP patch version=2E I still having some issues in userspace
>but I
>> would like to get feedback about the kernel-side patch=2E Thanks!
>>=20
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup=2Enet>
>> ---
>>  include/net/netfilter/nf_tables=2Eh |  6 +++
>>  net/netfilter/nf_tables_api=2Ec     | 73
>++++++++++++++++++++++++++++---
>>  2 files changed, 72 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/include/net/netfilter/nf_tables=2Eh
>b/include/net/netfilter/nf_tables=2Eh
>> index dc301e3d6739=2E=2Edc4e32040ea9 100644
>> --- a/include/net/netfilter/nf_tables=2Eh
>> +++ b/include/net/netfilter/nf_tables=2Eh
>> @@ -1123,6 +1123,9 @@ struct nft_object_ops {
>>  	int				(*dump)(struct sk_buff *skb,
>>  						struct nft_object *obj,
>>  						bool reset);
>> +	int				(*update)(const struct nft_ctx *ctx,
>> +						  const struct nlattr *const tb[],
>> +						  struct nft_object *obj);
>>  	const struct nft_object_type	*type;
>>  };
>> =20
>> @@ -1405,10 +1408,13 @@ struct nft_trans_elem {
>> =20
>>  struct nft_trans_obj {
>>  	struct nft_object		*obj;
>> +	bool				update;
>>  };
>> =20
>>  #define nft_trans_obj(trans)	\
>>  	(((struct nft_trans_obj *)trans->data)->obj)
>> +#define nft_trans_obj_update(trans)	\
>> +	(((struct nft_trans_obj *)trans->data)->update)
>> =20
>>  struct nft_trans_flowtable {
>>  	struct nft_flowtable		*flowtable;
>> diff --git a/net/netfilter/nf_tables_api=2Ec
>b/net/netfilter/nf_tables_api=2Ec
>> index fe3b7b0c6c66=2E=2Ed7b94904599c 100644
>> --- a/net/netfilter/nf_tables_api=2Ec
>> +++ b/net/netfilter/nf_tables_api=2Ec
>> @@ -5122,6 +5122,48 @@ nft_obj_type_get(struct net *net, u32 objtype)
>>  	return ERR_PTR(-ENOENT);
>>  }
>> =20
>> +static int nf_tables_updobj(const struct nft_ctx *ctx,
>> +			    const struct nft_object_type *type,
>> +			    const struct nlattr *attr,
>> +			    struct nft_object *obj)
>> +{
>> +	struct nft_trans *trans;
>> +	struct nlattr **tb;
>> +	int err =3D -ENOMEM;
>> +
>> +	trans =3D nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
>> +				sizeof(struct nft_trans_obj));
>> +	if (!trans)
>> +		return -ENOMEM;
>> +
>> +	tb =3D kmalloc_array(type->maxattr + 1, sizeof(*tb), GFP_KERNEL);
>
>You can use kcalloc here and then remove the memset()=2E
>p
>> +	err =3D obj->ops->update(ctx, (const struct nlattr * const *)tb,
>obj);
>> +	if (err < 0)
>> +		goto err;
>
>This looks wrong, see below=2E
>
>> @@ -5161,7 +5203,13 @@ static int nf_tables_newobj(struct net *net,
>struct sock *nlsk,
>>  			NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
>>  			return -EEXIST;
>>  		}
>> -		return 0;
>> +		if (nlh->nlmsg_flags & NLM_F_REPLACE)
>> +			return -EOPNOTSUPP;
>> +
>> +		type =3D nft_obj_type_get(net, objtype);
>> +		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
>> +
>> +		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
>>  	}
>> =20
>>  		case NFT_MSG_NEWOBJ:
>> -			nft_clear(net, nft_trans_obj(trans));
>> -			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
>> -					     NFT_MSG_NEWOBJ);
>> -			nft_trans_destroy(trans);
>> +			if (nft_trans_obj_update(trans)) {
>> +				nf_tables_obj_notify(&trans->ctx,
>> +						     nft_trans_obj(trans),
>> +						     NFT_MSG_NEWOBJ);
>
>I would have expected the ->update() here, when committing the batch=2E
>Under what conditions can an update() fail?

It depends on the object type=2E In the quota case it can fail if the quot=
a have invalid values=2E

