Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F87C352A3
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0778E20661
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XzsSz7LA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgBJPJ0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:09:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37501 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726809AbgBJPJ0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 10:09:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581347365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kQQ//ZOg0XlTiCuMUJxXjZnM/wJUT5yRNtpkCKSra+c=;
        b=XzsSz7LAJObPfDR3EeG8tKjV+03cZR/aRoORLeLiBcOC8E5pWVoCgeh+BhK+eB9RWVu0AD
        ohsABMAAbs/HLGD3M/KoJexKHilwsVjLLpdW/hDZ257EbOzXLIsaRfnI4Gz2Rodq7s/VSv
        XfHYE+fvDdYVPQvgeC4EALtEvN4D1JY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-AWwpTm3zPbm8Tdb-jX1XHA-1; Mon, 10 Feb 2020 10:09:18 -0500
X-MC-Unique: AWwpTm3zPbm8Tdb-jX1XHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AA51DBA6;
        Mon, 10 Feb 2020 15:09:17 +0000 (UTC)
Received: from localhost (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 235C4388;
        Mon, 10 Feb 2020 15:09:14 +0000 (UTC)
Date:   Mon, 10 Feb 2020 16:09:10 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v4 3/4] src: Add support for concatenated set ranges
Message-ID: <20200210160910.28763684@redhat.com>
In-Reply-To: <20200207111811.rybiyyacprywswig@salvia>
References: <cover.1580342294.git.sbrivio@redhat.com>
 <92d2e10dda6dbb8443383606bde835ca1e9da834.1580342294.git.sbrivio@redhat.com>
 <20200207111811.rybiyyacprywswig@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 7 Feb 2020 12:18:11 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Thu, Jan 30, 2020 at 01:16:57AM +0100, Stefano Brivio wrote:
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index 55591f5f3526..208250715e1f 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -136,6 +136,11 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
> >  
> >  	if ((*expr)->byteorder == byteorder)
> >  		return 0;
> > +
> > +	/* Conversion for EXPR_CONCAT is handled for single composing ranges */
> > +	if ((*expr)->etype == EXPR_CONCAT)
> > +		return 0;  
> 
> Are you also sure this is correct?

Yes, I think so: if we add a set with a concatenation of three
elements, byteorder_conversion() will be called three times with
(*expr)->etype == EXPR_VALUE (which is what we might actually need to
convert), and then once with EXPR_CONCAT, for which we have nothing to
do.

> This code was probably not exercised before with non-range
> concatenations.

I've seen it called for ranges in general. Do you mean we'd never get
past:

	if ((*expr)->byteorder == byteorder)
		return 0;

?

-- 
Stefano

