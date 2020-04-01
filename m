Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65710C43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 15:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35D43206F6
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 15:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gBIDwUG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733070AbgDAPCz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 11:02:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51116 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732946AbgDAPCz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 11:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585753374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kJ9JAxz5o+CvPgJD0JrhqIGtt/VfMrltkJEOWkOvrQo=;
        b=gBIDwUG4Gedv64KQ9IRpZrD5advRmsJI5lOqXhF3Y5Vzmo7vGKk6xUSuU25RN6Ce51+gV0
        xA6O/wddSwtybIy6IVHD7QXRsFa6AVzMXojnO02koz8CXJh1ceIkaLSbr6lXc/amCNSqWF
        oZ6AC9Dzyyx4Yntn5+EqOt3vvWj+9IY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-shQoCb0TOwuE0soAddAcSA-1; Wed, 01 Apr 2020 11:02:44 -0400
X-MC-Unique: shQoCb0TOwuE0soAddAcSA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C13D1800D5F;
        Wed,  1 Apr 2020 15:02:42 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F87210016EB;
        Wed,  1 Apr 2020 15:02:39 +0000 (UTC)
Date:   Wed, 1 Apr 2020 17:02:32 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Drop spurious condition for overlap
 detection on insertion
Message-ID: <20200401170232.463144f7@elisabeth>
In-Reply-To: <0ac4c2d001cfed74d3c2304151d7a44105f47552.1585752835.git.sbrivio@redhat.com>
References: <0ac4c2d001cfed74d3c2304151d7a44105f47552.1585752835.git.sbrivio@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed,  1 Apr 2020 16:54:45 +0200
Stefano Brivio <sbrivio@redhat.com> wrote:

> Case a1. for overlap detection in __nft_rbtree_insert() is not a valid
> one: start-after-start is not needed to detect any type of interval
> overlap and it actually results in a false positive if, while
> descending the tree, this is the only step we hit after starting from
> the root.

Sorry, please disregard, I sent the wrong version. v2 coming in a few
minutes.

-- 
Stefano

