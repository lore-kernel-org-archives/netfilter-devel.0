Return-Path: <SRS0=tm+y=5H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E247C4332D
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359C920757
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUZRAou2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgCVCVQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Mar 2020 22:21:16 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:45955 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgCVCVQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Mar 2020 22:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584843675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ANSxPJpyzR0GqL0xXpZHb0vYjDlbSP34HZWZmjrVhQs=;
        b=EUZRAou2GOh54uok7qtJaIBqNZ9R+QEwAhIXcNUbL8XLq6HWsAP5SSbppKhXikYwgEREAN
        BmqNB29BUQA5Dfp1hgFQ7Xb6Dm/flP0ZBH8yXbhipWgKy3hqB9N0ACa6u7vFxCqKJCqt/g
        tTZ9fOFhfx16Tu7vMaha3WDrd5PcJ24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-n-046lH1NOKcE0x3MKkN2w-1; Sat, 21 Mar 2020 22:21:14 -0400
X-MC-Unique: n-046lH1NOKcE0x3MKkN2w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D6A11005510;
        Sun, 22 Mar 2020 02:21:13 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.40.208.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA2AC73863;
        Sun, 22 Mar 2020 02:21:11 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: [PATCH NOMERGE iptables 2/2] man: xt_set: Describe --update-counters-first flag
Date:   Sun, 22 Mar 2020 03:20:54 +0100
Message-Id: <20200322022054.3447876-3-sbrivio@redhat.com>
In-Reply-To: <20200322022054.3447876-1-sbrivio@redhat.com>
References: <20200322022054.3447876-1-sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If this flag is set, counters are updated when elements (not
necessarily rules) match, and before rule match is evaluated
as a whole.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 extensions/libxt_set.man | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index 451400dc..fb5411be 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -27,9 +27,17 @@ byte counters of the matching element in the set won't=
 be updated. By
 default, packet and byte counters are updated if the \fIrule\fP
 matches.
 .IP
-Note that a rule might not match (hence, counters won't be updated)
-even if a set element matches, depending on further options described
-below.
+Note that a rule might not match even if a set element matches,
+depending on further options described below, hence counters won't be
+updated unless the \fB\-\-update\-counters-first\fP option is given.
+.TP
+\fB\-\-update\-counters-first\fP
+Update counters before evaluating options that might affect rule
+matching: counters are updated whenever a set element matches, and
+counter comparison options described below are evaluated against the
+resulting counter values.
+.IP
+This is mutually exclusive with \fB!\fP \fB\-\-update\-counters\fP.
 .TP
 \fB!\fP \fB\-\-update\-subcounters\fP
 If the \fB\-\-update\-subcounters\fP flag is negated, then the packet an=
d
--=20
2.24.1

