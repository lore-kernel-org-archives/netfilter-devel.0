Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06EEC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 13:36:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A31922075C
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 13:36:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YeBevrpz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfKYNgd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:36:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28514 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725924AbfKYNgd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 08:36:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574688991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jB6a8/KfYFMLRN8o4YAVR0UXV3eJzLTdEHCS97czg2Q=;
        b=YeBevrpzbQsGe8soKBt4hE5m2wuPd2IwiqUTx60hn96zRZnq7krTd4DTXhxBI5QZA8AqDR
        QsyF4lKjMXBQ09XIQXtx1TC5fd4ZN/7hNHBmEn+SAqYf2bI0NvIWggJEBEPEatiGSNy6is
        a/89714WMEdzZB0Qk4UwnrDVlfyqe4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-9jjBrL48MN-wOTTcb8esuA-1; Mon, 25 Nov 2019 08:36:28 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F35BFDB31;
        Mon, 25 Nov 2019 13:36:26 +0000 (UTC)
Received: from elisabeth (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F3B01001901;
        Mon, 25 Nov 2019 13:36:24 +0000 (UTC)
Date:   Mon, 25 Nov 2019 14:36:18 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 0/8] nftables: Set implementation for
 arbitrary concatenation of ranges
Message-ID: <20191125143618.4b28ca62@elisabeth>
In-Reply-To: <20191125100214.ke2inuq7cequbdgx@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
        <20191123200518.t2we5nqmmh62g5b6@salvia>
        <20191125103106.5acbc958@elisabeth>
        <20191125100214.ke2inuq7cequbdgx@salvia>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: 9jjBrL48MN-wOTTcb8esuA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 25 Nov 2019 11:02:14 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> BTW, do you have numbers comparing the AVX2 version with the C code? I
> quickly had a look at your numbers, but not clear to me if this is
> compared there.

No, sorry, I didn't report that anywhere, I probably should have in
the commit messages for 4/8 and 5/8. This was from v1 at 4/8, single
thread on AMD Epyc 7351, C implementation without unrolled loops:

TEST: performance
  net,port                                                      [ OK ]
    baseline (drop from netdev hook):               9971887pps
    baseline hash (non-ranged entries):             5991032pps
    baseline rbtree (match on first field only):    2666255pps
    set with  1000 full, ranged entries:            2220404pps
  port,net                                                      [ OK ]
    baseline (drop from netdev hook):              10004499pps
    baseline hash (non-ranged entries):             6011221pps
    baseline rbtree (match on first field only):    4035566pps
    set with   100 full, ranged entries:            4018240pps
  net6,port                                                     [ OK ]
    baseline (drop from netdev hook):               9497500pps
    baseline hash (non-ranged entries):             4685436pps
    baseline rbtree (match on first field only):    1354978pps
    set with  1000 full, ranged entries:            1052188pps
  port,proto                                                    [ OK ]
    baseline (drop from netdev hook):              10749256pps
    baseline hash (non-ranged entries):             6774103pps
    baseline rbtree (match on first field only):    2819211pps
    set with 30000 full, ranged entries:             283492pps
  net6,port,mac                                                 [ OK ]
    baseline (drop from netdev hook):               9463935pps
    baseline hash (non-ranged entries):             3777039pps
    baseline rbtree (match on first field only):    2943527pps
    set with    10 full, ranged entries:            1927899pps
  net6,port,mac,proto                                           [ OK ]
    baseline (drop from netdev hook):               9502200pps
    baseline hash (non-ranged entries):             3637739pps
    baseline rbtree (match on first field only):    1342323pps
    set with  1000 full, ranged entries:             753960pps
  net,mac                                                       [ OK ]
    baseline (drop from netdev hook):              10065715pps
    baseline hash (non-ranged entries):             5082895pps
    baseline rbtree (match on first field only):    2677391pps
    set with  1000 full, ranged entries:            1215104pps

I would re-run tests on v3 patches and include the comparisons in
commit messages. 

By the way, as you can see, even though the comparison with rbtree is
unfair (comparing > 1 fields adds substantial complexity), without AVX2
it doesn't scale as nicely. I plan to propose some optimisations that
should substantially improve the non-vectorised case, but what I have
in mind right now is a bit convoluted and I would skip it in this
initial submission.

-- 
Stefano

