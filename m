Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F312CCA9ED0
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4747217D9
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:14:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="HTsWDf0s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfKAPOI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:14:08 -0400
Received: from mx1.riseup.net ([198.252.153.129]:33110 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbfKAPOH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 11:14:07 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 474QhG3F0YzDrDL;
        Fri,  1 Nov 2019 08:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1572621246; bh=l585Z8tMoM3DDPZRNn/7xc2sABJaCxA6UKGopdCFTWQ=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=HTsWDf0sPYrUuft4FDDet+resZs17fytglk7J2XXyeFMK0EwqIL1yQbnwjG0b+L5u
         ZqIsdQg6i7voUmcuMdNSIPwJ+4Gg2Qpx8Pdi2M887ioAyHL1zpGiwOg2bhJAUBaW1m
         XRAu54EVgmKa8ijD57RF4K1zKTwsUCVjE3q6SuUo=
X-Riseup-User-ID: CC7E9EB16388AAB63C8D9E9EF4C2B1462FA8C2029C06DD593EDA9DC7DA144EB0
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 474QhF5xQJzJnct;
        Fri,  1 Nov 2019 08:14:05 -0700 (PDT)
Date:   Fri, 01 Nov 2019 16:13:59 +0100
In-Reply-To: <20191101151159.aqmtvo6xwlwqh3yd@egarver.localdomain>
References: <20190904122907.967-1-ffmancera@riseup.net> <20191101144246.22xvyucdocmzyv73@egarver.localdomain> <B9925CA6-AC71-4DC4-9519-204244C4AC91@riseup.net> <20191101151159.aqmtvo6xwlwqh3yd@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: fix possible null-pointer dereference in object update
To:     Eric Garver <eric@garver.life>
CC:     netfilter-devel@vger.kernel.org
From:   =?ISO-8859-1?Q?Fernando_Fern=E1ndez_Mancera?= 
        <ffmancera@riseup.net>
Message-ID: <B54B2DB0-93E4-4CC5-99AE-0913EABF3DCB@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 1 de noviembre de 2019 16:11:59 CET, Eric Garver <eric@garver=2Elife> es=
cribi=C3=B3:
>On Fri, Nov 01, 2019 at 04:01:51PM +0100, Fernando Fern=C3=A1ndez Mancera
>wrote:
>> El 1 de noviembre de 2019 15:42:46 CET, Eric Garver
><eric@garver=2Elife> escribi=C3=B3:
>> >Hi Fernando,
>> >
>> >On Wed, Sep 04, 2019 at 02:29:07PM +0200, Fernando Fernandez Mancera
>> >wrote:
>> >> Not all objects need an update operation=2E If the object type
>doesn't
>> >implement
>> >> an update operation and the user tries to update it there will be
>a
>> >EOPNOTSUPP
>> >> error instead of a null pointer=2E
>> >>=20
>> >> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful
>object
>> >update operation")
>> >> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup=2Enet>
>> >> ---
>> >>  net/netfilter/nf_tables_api=2Ec | 3 +++
>> >>  1 file changed, 3 insertions(+)
>> >>=20
>> >> diff --git a/net/netfilter/nf_tables_api=2Ec
>> >b/net/netfilter/nf_tables_api=2Ec
>> >> index cf767bc58e18=2E=2E013d28899cab 100644
>> >> --- a/net/netfilter/nf_tables_api=2Ec
>> >> +++ b/net/netfilter/nf_tables_api=2Ec
>> >> @@ -5140,6 +5140,9 @@ static int nf_tables_updobj(const struct
>> >nft_ctx *ctx,
>> >>  	struct nft_trans *trans;
>> >>  	int err;
>> >> =20
>> >> +	if (!obj->ops->update)
>> >> +		return -EOPNOTSUPP;
>> >> +
>> >>  	trans =3D nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
>> >>  				sizeof(struct nft_trans_obj));
>> >>  	if (!trans)
>> >> --=20
>> >> 2=2E20=2E1
>> >
>> >I think this introduced a regression when adding an object that
>already
>> >exists:
>> >
>> >    # nft add table inet foobar
>> >    # nft add counter inet foobar my_counter
>> >    # nft add counter inet foobar my_counter
>> >    Error: Could not process rule: Operation not supported
>> >    add counter inet foobar my_counter
>> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> >
>> >It applies to all objects that don't provide an update handler;
>> >counter,
>> >ct helper, ct timeout, ct exception, etc=2E
>>=20
>> Hi Eric,
>>=20
>> It seems that you are right=2E What would be the behaviour here? Resets
>the object properties?
>
>I don't know what the correct behavior is in the kernel - maybe it
>silently skips it=2E i=2Ee=2E no attempt to update, but returns no error=
=2E
>
>From a user perspective it should happily accept the re-add=2E
>
>    # nft add table inet foobar
>    # nft add counter inet foobar my_counter
>    # nft add counter inet foobar my_counter
>    ** no error **
>
>Unless the "create" verb is used, then we should get an error:
>
>    # nft create counter inet foobar my_counter
>    Error: Could not process rule: File exists
>    create counter inet foobar my_counter
>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sure, I am going to prepare a patch for this=2E Sorry about the regression=
=2E Thanks!
