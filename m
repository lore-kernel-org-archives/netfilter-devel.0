Return-Path: <SRS0=kbfM=4I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBFEC11D04
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 11:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDB3F208C4
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Feb 2020 11:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BW4x4plh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgBTLE6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 06:04:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25860 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726825AbgBTLE6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 06:04:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582196697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Em0pBunduecOBbUuv0pBY92SZyGjtPCxIS4F2yaMuM=;
        b=BW4x4plh357Kn9HnGPj5z8jXDkOz7ouSLZDl0Ev5MVDFheXLOMYzc5c40XAMVqn+7IBUg7
        CeE98HZZXOWAO5Y6vTMk4xtvAUmVFIjQFDeUxssmypxYX7kgNvZlAnDcBd7UyVNgJJSgWa
        afPdJHyzGLT101xr1huMQy6abt0qh7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-7K6P05pbNDqPXQuvtfdHxg-1; Thu, 20 Feb 2020 06:04:54 -0500
X-MC-Unique: 7K6P05pbNDqPXQuvtfdHxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A21E189F763;
        Thu, 20 Feb 2020 11:04:52 +0000 (UTC)
Received: from elisabeth (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 957518CCC5;
        Thu, 20 Feb 2020 11:04:48 +0000 (UTC)
Date:   Thu, 20 Feb 2020 12:04:40 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nf-next v4 0/9] nftables: Set implementation for
 arbitrary concatenation of ranges
Message-ID: <20200220120331.334b13b0@elisabeth>
In-Reply-To: <20200220105240.GG20005@orbyte.nwl.cc>
References: <cover.1579647351.git.sbrivio@redhat.com>
        <20200220105240.GG20005@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, 20 Feb 2020 11:52:41 +0100
Phil Sutter <phil@nwl.cc> wrote:

> Hi Stefano,
> 
> When playing with adding multiple elements, I suddenly noticed a
> disturbance in the force (general protection fault). Here's a
> reproducer:
> 
> | $NFT -f - <<EOF
> | table t {
> |         set s {
> |                 type ipv4_addr . inet_service
> |                 flags interval
> |         }
> | }
> | EOF
> | 
> | $NFT add element t s '{ 10.0.0.1 . 22-25, 10.0.0.1 . 10-20 }'
> | $NFT flush set t s
> | $NFT add element t s '{ 10.0.0.1 . 10-20, 10.0.0.1 . 22-25 }'
> 
> It is pretty reliable, though sometimes needs a second call. Looks like some
> things going on in parallel which shouldn't. Here's a typical last breath:
> 
> [   71.319848] general protection fault, probably for non-canonical address 0x6f6b6e696c2e756e: 0000 [#1] PREEMPT SMP PTI
> [   71.321540] CPU: 3 PID: 1201 Comm: kworker/3:2 Not tainted 5.6.0-rc1-00377-g2bb07f4e1d861 #192
> [   71.322746] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190711_202441-buildvm-armv7-10.arm.fedoraproject.org-2.fc31 04/01/2014
> [   71.324430] Workqueue: events nf_tables_trans_destroy_work [nf_tables]
> [   71.325387] RIP: 0010:nft_set_elem_destroy+0xa5/0x110 [nf_tables]

Ouch, thanks for reporting, I'll check in a few hours.

-- 
Stefano

