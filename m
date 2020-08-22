Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7F0C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 09:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAB66207C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 09:16:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GkGUDYSa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgHVJQl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 05:16:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33320 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgHVJQl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 05:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598087800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lIagPR/nGAuKCjwxq/LKoAOpoQOhfSj4LS7PGfQwDwI=;
        b=GkGUDYSaeg3BCs8f3U6e3KJkmJc+lf2agUO8cwKJdMQW32bVqid1b7IjczfbUNzOAtZeHf
        xJYf9+SmULzFYt0VIFw9h21Z7HkqS5FTk/1GJJbGeW3wal2Xy2vrakC8koExE9XlyPdBEc
        r4Ms3aOVomXNLOmhdg5T2jAf3x4S2rw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-X2Wg1oazPOqH0rgJnUmvTQ-1; Sat, 22 Aug 2020 05:16:38 -0400
X-MC-Unique: X2Wg1oazPOqH0rgJnUmvTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93AF9801AAB;
        Sat, 22 Aug 2020 09:16:37 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 560405F704;
        Sat, 22 Aug 2020 09:16:36 +0000 (UTC)
Date:   Sat, 22 Aug 2020 11:16:31 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Balazs Scheidler <bazsi77@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 3/4] tests: added "socked wildcard" testcases
Message-ID: <20200822111631.5ccca43d@elisabeth>
In-Reply-To: <20200822062203.3617-4-bazsi77@gmail.com>
References: <20200822062203.3617-1-bazsi77@gmail.com>
        <20200822062203.3617-4-bazsi77@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 22 Aug 2020 08:22:02 +0200
Balazs Scheidler <bazsi77@gmail.com> wrote:

> Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>

Nit, in case you re-post: s/socked/socket/.

-- 
Stefano

