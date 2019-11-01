Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3968CA9ECF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:02:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85F1B21734
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:02:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="V0BDUfHE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbfKAPCA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:02:00 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50402 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727365AbfKAPCA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 11:02:00 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 474QQH39BYzFbKJ;
        Fri,  1 Nov 2019 08:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1572620519; bh=t1KCqP+UvjL8QNPr1hQFilsj8rcPYv+v5ZpOegj5syY=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=V0BDUfHEeAxx0z5Hq1xeMtB7Aj+ZOSYZfDpd4avlQTDB88QwAb2cr1ew5smgExoKP
         SSV7dHvBxQDcVoWcF0UTYuHdhh2V25qADhK9ZZpeLb755JzfFWC/FT6wtQxbNkcdyR
         dpFpK89shln2QaHSAMAAHfiWWXf3Ny6AAQyQrTfM=
X-Riseup-User-ID: 38E74014142CFE4EA32B820718E8E43F29C1458EA683C5C3210CBA90B9A44E1D
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 474QQG4STqz8srF;
        Fri,  1 Nov 2019 08:01:58 -0700 (PDT)
Date:   Fri, 01 Nov 2019 16:01:51 +0100
In-Reply-To: <20191101144246.22xvyucdocmzyv73@egarver.localdomain>
References: <20190904122907.967-1-ffmancera@riseup.net> <20191101144246.22xvyucdocmzyv73@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: fix possible null-pointer dereference in object update
To:     Eric Garver <eric@garver.life>
CC:     netfilter-devel@vger.kernel.org
From:   =?ISO-8859-1?Q?Fernando_Fern=E1ndez_Mancera?= 
        <ffmancera@riseup.net>
Message-ID: <B9925CA6-AC71-4DC4-9519-204244C4AC91@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 1 de noviembre de 2019 15:42:46 CET, Eric Garver <eric@garver=2Elife> es=
cribi=C3=B3:
>Hi Fernando,
>
>On Wed, Sep 04, 2019 at 02:29:07PM +0200, Fernando Fernandez Mancera
>wrote:
>> Not all objects need an update operation=2E If the object type doesn't
>implement
>> an update operation and the user tries to update it there will be a
>EOPNOTSUPP
>> error instead of a null pointer=2E
>>=20
>> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object
>update operation")
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup=2Enet>
>> ---
>>  net/netfilter/nf_tables_api=2Ec | 3 +++
>>  1 file changed, 3 insertions(+)
>>=20
>> diff --git a/net/netfilter/nf_tables_api=2Ec
>b/net/netfilter/nf_tables_api=2Ec
>> index cf767bc58e18=2E=2E013d28899cab 100644
>> --- a/net/netfilter/nf_tables_api=2Ec
>> +++ b/net/netfilter/nf_tables_api=2Ec
>> @@ -5140,6 +5140,9 @@ static int nf_tables_updobj(const struct
>nft_ctx *ctx,
>>  	struct nft_trans *trans;
>>  	int err;
>> =20
>> +	if (!obj->ops->update)
>> +		return -EOPNOTSUPP;
>> +
>>  	trans =3D nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
>>  				sizeof(struct nft_trans_obj));
>>  	if (!trans)
>> --=20
>> 2=2E20=2E1
>
>I think this introduced a regression when adding an object that already
>exists:
>
>    # nft add table inet foobar
>    # nft add counter inet foobar my_counter
>    # nft add counter inet foobar my_counter
>    Error: Could not process rule: Operation not supported
>    add counter inet foobar my_counter
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>It applies to all objects that don't provide an update handler;
>counter,
>ct helper, ct timeout, ct exception, etc=2E

Hi Eric,

It seems that you are right=2E What would be the behaviour here? Resets th=
e object properties?

Thanks Eric!
