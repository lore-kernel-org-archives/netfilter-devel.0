Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3285FC35DE1
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 12:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E8B9720637
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 12:45:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IX2lPC/3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbgBYMpn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 07:45:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45988 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729781AbgBYMpn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 07:45:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582634742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SuOKtXzGM4yNlsL5c+F8OnQudDWg7CDp22KK33b6sm8=;
        b=IX2lPC/3pGcozrywhw1JVuvG47BKDsP0y/XBPhdTJcw0CgVJvaOyFlyfow7foRyB90CAmm
        N6jdWd8mCWw9r5iXsbil2evlOUMZu93Xnvfdf91wjJ9OFR36MWTfgWWa1xBkLverhyc/Cw
        kCnmhvxhBP8lpQQct+3zeyRyNWVq2Qo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476--y1rygb7NCCdTgcepxNFhg-1; Tue, 25 Feb 2020 07:45:38 -0500
X-MC-Unique: -y1rygb7NCCdTgcepxNFhg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5B8E1005F70;
        Tue, 25 Feb 2020 12:45:37 +0000 (UTC)
Received: from localhost (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18ACB5C1D6;
        Tue, 25 Feb 2020 12:45:35 +0000 (UTC)
Date:   Tue, 25 Feb 2020 13:45:29 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200225134529.5c57c71d@redhat.com>
In-Reply-To: <20200225123934.p3vru3tmbsjj2o7y@salvia>
References: <cover.1582250437.git.sbrivio@redhat.com>
        <20200221211704.GM20005@orbyte.nwl.cc>
        <20200221232218.2157d72b@elisabeth>
        <20200222011933.GO20005@orbyte.nwl.cc>
        <20200223222258.2bb7516a@redhat.com>
        <20200225123934.p3vru3tmbsjj2o7y@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 25 Feb 2020 13:39:34 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> (just added a slightly large range). I tried _without_ these patches.

As a side note (I'll answer later), just for clarity: these patches
have nothing to do with this problem.

-- 
Stefano

