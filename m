Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3663C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 09:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B030E2071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 09:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZEkB5M1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfKYJbU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 04:31:20 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34329 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725793AbfKYJbU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 04:31:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574674279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9p9bybu6CBRNtqwoXo/EhdAuLZJGY5pgoN9+Zr/bZ78=;
        b=ZEkB5M1Vn+etRjusjLDlFGW2/IDXBqmly3E3yJVMsFXH6KOH29d+YkTQsCJA052h6otykT
        Eqx7iG5y2d23daHtd2lmg7a0b2D6CpnUkkHTDXIRDulbhqjoko1nm4TO9KYmrNlvVWKSfn
        5hWjTf5PBHyc2ykErVSTUoX+BwquWGo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-yNNt5XRtMFW-1SRzX2FHsg-1; Mon, 25 Nov 2019 04:31:15 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB0E164A87;
        Mon, 25 Nov 2019 09:31:13 +0000 (UTC)
Received: from elisabeth (ovpn-200-25.brq.redhat.com [10.40.200.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C5EA60C63;
        Mon, 25 Nov 2019 09:31:10 +0000 (UTC)
Date:   Mon, 25 Nov 2019 10:31:06 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 0/8] nftables: Set implementation for
 arbitrary concatenation of ranges
Message-ID: <20191125103106.5acbc958@elisabeth>
In-Reply-To: <20191123200518.t2we5nqmmh62g5b6@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
        <20191123200518.t2we5nqmmh62g5b6@salvia>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: yNNt5XRtMFW-1SRzX2FHsg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 23 Nov 2019 21:05:18 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Fri, Nov 22, 2019 at 02:39:59PM +0100, Stefano Brivio wrote:
> [...]
> > Patch 1/8 implements the needed UAPI bits: additions to the existing
> > interface are kept to a minimum by recycling existing concepts for
> > both ranging and concatenation, as suggested by Florian.
> > 
> > Patch 2/8 adds a new bitmap operation that copies the source bitmap
> > onto the destination while removing a given region, and is needed to
> > delete regions of arrays mapping between lookup tables.
> > 
> > Patch 3/8 is the actual set implementation.
> > 
> > Patch 4/8 introduces selftests for the new implementation.  
> [...]
> 
> After talking to Florian, I'm inclined to merge upstream up to patch
> 4/8 in this merge window, once the UAPI discussion is sorted out.

Thanks for the update. Let me know if there's some specific topic or
concern I can start addressing for patches 5/8 to 8/8.

-- 
Stefano

