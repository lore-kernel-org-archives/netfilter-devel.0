Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D2FC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 23:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C066207CB
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 23:12:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EnUVz1Cg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388542AbgEYXMY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 19:12:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29163 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388013AbgEYXMY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 19:12:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590448342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nXkpnoCuomfd/APVPagAUOQAmqnAQwAuSuA/tkkwLGA=;
        b=EnUVz1CgTAOcHvKkRJ8l9bjtEPIYu/+3mcMRZjoV21ADhLuXnQ6SMNh2Zmko215He7pGBB
        MenIJylWK0uoEk8Iv9JenTGbD/sFQXVWw+fCXHvdj5M4EpJN2svUTruDnuJ1iune2KINSG
        clIivcXwsmQeQEr/KUaalF47egymg/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-Ij_RodS2MzCkdYNhky4EPQ-1; Mon, 25 May 2020 19:12:19 -0400
X-MC-Unique: Ij_RodS2MzCkdYNhky4EPQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1502E19057AD;
        Mon, 25 May 2020 23:12:18 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37CF683861;
        Mon, 25 May 2020 23:12:16 +0000 (UTC)
Date:   Tue, 26 May 2020 01:12:13 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Konstantin Khorenko <khorenko@virtuozzo.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: How to test the kernel netfilter logic?
Message-ID: <20200526011213.37df67a1@redhat.com>
In-Reply-To: <8499b3da-fef3-2e42-289a-c824837d8ca3@virtuozzo.com>
References: <e925907a-475f-725e-a2b7-6b9d78b236d1@virtuozzo.com>
        <20200525145031.42afc130@redhat.com>
        <8499b3da-fef3-2e42-289a-c824837d8ca3@virtuozzo.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 25 May 2020 17:00:24 +0300
Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> On 05/25/2020 03:50 PM, Stefano Brivio wrote:
> > Hi Konstantin,
> >
> > On Mon, 25 May 2020 11:37:57 +0300
> > Konstantin Khorenko <khorenko@virtuozzo.com> wrote:
> >  
> >> but did not find netfilter tests in kernel git repo as well.  
> >
> > Have a look at tools/testing/selftests/netfilter/, some of the tests
> > there actually send traffic and check the outcome.  
> 
> Hi Stefano,
> 
> thank you very much for the answer!
> 
> Yes, you are right, i know about that place, i just thought it's just
> for "smoke" testing:

Well, I'd say it's a bit more than that, some tests there cover
specific functionalities rather extensively. Still:

> "iptables" and "nftables" repos have many more testcases (for add/del
> rules), so i thought there is some additional place with similar very
> detailed tests for kernel part.

...I'm not aware of any (except for ipset cases that actually test both
sides with packets, see http://git.netfilter.org/ipset/tree/tests).

Sure, I think it would be great to have something with actual traffic
at the same level of detail as nft tests, though.

-- 
Stefano

