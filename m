Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABC2C34021
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6339820718
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 14:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOJae24t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgBQOvC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 09:51:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43332 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728375AbgBQOvC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 09:51:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581951061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=845PWlYqHwv2pcyBOW7I/VjLxTkGYwmQonuS9U2eQ14=;
        b=DOJae24t/KGOgF1WFLfK/x73/hJ5u625eG20t4fHRfXcPR7P9t9hHV8mGZMt33Y12sJueR
        hDToL0BzKyfCdlH9guuCUjo+3+R0004J2MGHJ1+FF5aEpBXhWK+m3F9Ulcg/b4phF6yr3q
        9FHSxQ7A+M6bxd809BUjGb0VHxnDiwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-LiCPchyZPb2ptLI4Gno2lQ-1; Mon, 17 Feb 2020 09:50:55 -0500
X-MC-Unique: LiCPchyZPb2ptLI4Gno2lQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 666EB8010F1;
        Mon, 17 Feb 2020 14:50:54 +0000 (UTC)
Received: from localhost (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 67AF95C219;
        Mon, 17 Feb 2020 14:50:53 +0000 (UTC)
Date:   Mon, 17 Feb 2020 15:50:48 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_tables: make all set structs
 const
Message-ID: <20200217155048.00c477a3@redhat.com>
In-Reply-To: <20200217095359.22791-3-fw@strlen.de>
References: <20200217095359.22791-1-fw@strlen.de>
        <20200217095359.22791-3-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, 17 Feb 2020 10:53:59 +0100
Florian Westphal <fw@strlen.de> wrote:

> -struct nft_set_type nft_set_pipapo_type __read_mostly = {
> -	.owner		= THIS_MODULE,
> +const struct nft_set_type nft_set_pipapo_type __read_mostly = {

const ... read_mostly should make no sense because const already forces
the data to a read-only segment. It might actually cause some issues,
see https://lore.kernel.org/patchwork/patch/439824/.

It's not there for the other set types, so I'm assuming it's a typo :)

-- 
Stefano

