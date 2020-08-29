Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A1AC433E6
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 12:24:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03AFC20776
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 12:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jHPpAGhn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgH2MYx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 08:24:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59868 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726876AbgH2MYr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 08:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598703884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eRtXm2tL1Rxrj/u7KmGvlqr05Rj9ZnYrdw/lDigWUbI=;
        b=jHPpAGhnTDHwUI+bIeLKRRTh/SpSSklfsahcRyvJ1V7lp9u+7F+tgtyB5c8UmuVCFPB9HA
        Ano8QKWi8XlppBkUJqVuNEYSXdBm5SIASF+4U/Ypv4/6/lTwUmy5c9QL5OxpYd/JO5c7Cp
        vgAX/Yx381fqBzElQgWTdIbIHBsYoWU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-EUwwn9A6NdOoqnhK7kd3Nw-1; Sat, 29 Aug 2020 08:24:39 -0400
X-MC-Unique: EUwwn9A6NdOoqnhK7kd3Nw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7BA98015F5;
        Sat, 29 Aug 2020 12:24:38 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C9936198C;
        Sat, 29 Aug 2020 12:24:36 +0000 (UTC)
Date:   Sat, 29 Aug 2020 14:24:31 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Balazs Scheidler <bazsi77@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v2 5/5] tests: allow tests/monitor to use a
 custom nft executable
Message-ID: <20200829142431.19d34600@elisabeth>
In-Reply-To: <20200829111850.GE9645@salvia>
References: <20200829070405.23636-1-bazsi77@gmail.com>
        <20200829070405.23636-6-bazsi77@gmail.com>
        <20200829111850.GE9645@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 29 Aug 2020 13:18:50 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Sat, Aug 29, 2020 at 09:04:05AM +0200, Balazs Scheidler wrote:
> > Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
> > ---
> >  tests/monitor/run-tests.sh | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
> > index ffb833a7..5a736fc6 100755
> > --- a/tests/monitor/run-tests.sh
> > +++ b/tests/monitor/run-tests.sh
> > @@ -1,7 +1,7 @@
> >  #!/bin/bash
> >  
> >  cd $(dirname $0)
> > -nft=../../src/nft
> > +nft=${NFT:-../../src/nft}
> >  debug=false
> >  test_json=false  
> 
> IIRC, Stefano mentioned this might break valgrind due to lack of
> quotes?

Wait, this is just for monitor/run-tests.sh now. The problem was on the
change proposed for shell/run_tests.sh, which wasn't needed because
it already supports passing a different command, and is not in this
version.

For monitor/run-tests.sh, I think that will need some fixing anyway (if
we want to support wrappers at all). So this change itself just
improves things.

-- 
Stefano

