Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41283C32771
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0778322525
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 22:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MYlCfdVd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgATWF4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 17:05:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37634 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726607AbgATWF4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 17:05:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579557955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z8AgJb+YiyPPOFzsbmjVCkTqkOuY8DbT9IWkTljaQ6k=;
        b=MYlCfdVdQ/OpUmnacIHSql9IYdzny21JwJp5k1eNET9Svz5lTTGlch9iRo9E4CvrvePgYf
        SIMGxhSMEQYtcxaNND/7FcyAoFSYZeheZjt/FAdqkE4Jd7KTWokN+KaybKs5Vy7DA+jE0m
        rAiLf+8XQdYLMKAMsXNbNGaEUMFNA9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-xahitsKYOq206noW_lGdwA-1; Mon, 20 Jan 2020 17:05:52 -0500
X-MC-Unique: xahitsKYOq206noW_lGdwA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27812DB61;
        Mon, 20 Jan 2020 22:05:50 +0000 (UTC)
Received: from elisabeth (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 634FC7C35A;
        Mon, 20 Jan 2020 22:05:47 +0000 (UTC)
Date:   Mon, 20 Jan 2020 23:05:41 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v3 5/9] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20200120230541.64a3a556@elisabeth>
In-Reply-To: <202001202149.6obFNaHi%lkp@intel.com>
References: <b976610b93dc5ee3db62d956b3e1ae8af4583312.1579434906.git.sbrivio@redhat.com>
        <202001202149.6obFNaHi%lkp@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 21 Jan 2020 00:13:17 +0800
kbuild test robot <lkp@intel.com> wrote:

> All errors (new ones prefixed by >>):
> 
> >> ERROR: "__udivdi3" [net/netfilter/nf_tables_set.ko] undefined!
> >> ERROR: "__divdi3" [net/netfilter/nf_tables_set.ko] undefined!  

Right, this needs:

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 5946fba8eb84..f0cb1e13af50 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1925,7 +1925,7 @@ static bool nft_pipapo_estimate(const struct nft_set_desc *desc, u32 features,
 
        /* Rules in lookup and mapping tables are needed for each entry */
        est->size = desc->size * entry_size;
-       if (est->size && est->size / desc->size != entry_size)
+       if (est->size && div_u64(est->size, desc->size) != entry_size)
                return false;
 
        est->size += sizeof(struct nft_pipapo) +

I will change that in the next version.

-- 
Stefano

