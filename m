Return-Path: <SRS0=Gx1r=YZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F84CA9ECF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78E8021734
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Nov 2019 15:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfKAPMG convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:12:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25552 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727326AbfKAPMG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Nov 2019 11:12:06 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-OhmBX7ksPauSjlw_Hyt62A-1; Fri, 01 Nov 2019 11:12:01 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D585F107ACC0;
        Fri,  1 Nov 2019 15:12:00 +0000 (UTC)
Received: from egarver.localdomain (ovpn-123-10.rdu2.redhat.com [10.10.123.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 767261001281;
        Fri,  1 Nov 2019 15:12:00 +0000 (UTC)
Date:   Fri, 1 Nov 2019 11:11:59 -0400
From:   Eric Garver <eric@garver.life>
To:     Fernando =?utf-8?Q?Fern=C3=A1ndez?= Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2] netfilter: nf_tables: fix possible
 null-pointer dereference in object update
Message-ID: <20191101151159.aqmtvo6xwlwqh3yd@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Fernando =?utf-8?Q?Fern=C3=A1ndez?= Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190904122907.967-1-ffmancera@riseup.net>
 <20191101144246.22xvyucdocmzyv73@egarver.localdomain>
 <B9925CA6-AC71-4DC4-9519-204244C4AC91@riseup.net>
MIME-Version: 1.0
In-Reply-To: <B9925CA6-AC71-4DC4-9519-204244C4AC91@riseup.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: OhmBX7ksPauSjlw_Hyt62A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 01, 2019 at 04:01:51PM +0100, Fernando Fernández Mancera wrote:
> El 1 de noviembre de 2019 15:42:46 CET, Eric Garver <eric@garver.life> escribió:
> >Hi Fernando,
> >
> >On Wed, Sep 04, 2019 at 02:29:07PM +0200, Fernando Fernandez Mancera
> >wrote:
> >> Not all objects need an update operation. If the object type doesn't
> >implement
> >> an update operation and the user tries to update it there will be a
> >EOPNOTSUPP
> >> error instead of a null pointer.
> >> 
> >> Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object
> >update operation")
> >> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> >> ---
> >>  net/netfilter/nf_tables_api.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >> 
> >> diff --git a/net/netfilter/nf_tables_api.c
> >b/net/netfilter/nf_tables_api.c
> >> index cf767bc58e18..013d28899cab 100644
> >> --- a/net/netfilter/nf_tables_api.c
> >> +++ b/net/netfilter/nf_tables_api.c
> >> @@ -5140,6 +5140,9 @@ static int nf_tables_updobj(const struct
> >nft_ctx *ctx,
> >>  	struct nft_trans *trans;
> >>  	int err;
> >>  
> >> +	if (!obj->ops->update)
> >> +		return -EOPNOTSUPP;
> >> +
> >>  	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
> >>  				sizeof(struct nft_trans_obj));
> >>  	if (!trans)
> >> -- 
> >> 2.20.1
> >
> >I think this introduced a regression when adding an object that already
> >exists:
> >
> >    # nft add table inet foobar
> >    # nft add counter inet foobar my_counter
> >    # nft add counter inet foobar my_counter
> >    Error: Could not process rule: Operation not supported
> >    add counter inet foobar my_counter
> >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> >It applies to all objects that don't provide an update handler;
> >counter,
> >ct helper, ct timeout, ct exception, etc.
> 
> Hi Eric,
> 
> It seems that you are right. What would be the behaviour here? Resets the object properties?

I don't know what the correct behavior is in the kernel - maybe it
silently skips it. i.e. no attempt to update, but returns no error.

From a user perspective it should happily accept the re-add.

    # nft add table inet foobar
    # nft add counter inet foobar my_counter
    # nft add counter inet foobar my_counter
    ** no error **

Unless the "create" verb is used, then we should get an error:

    # nft create counter inet foobar my_counter
    Error: Could not process rule: File exists
    create counter inet foobar my_counter
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

