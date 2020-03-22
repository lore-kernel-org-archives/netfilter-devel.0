Return-Path: <SRS0=tm+y=5H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34322C4332E
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BED220754
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Mar 2020 02:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GnhSDy0n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgCVCVP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Mar 2020 22:21:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40966 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726409AbgCVCVP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Mar 2020 22:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584843674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ybwNPEi8V7QE8z+/jlUqmibYLBnlsIAyAxG0RGCv2A=;
        b=GnhSDy0nXGMi/gouQsIfvjB+Wk4jmBeo/tDkWrTLnlqlwVjpFCjvp9KsM7xXzRJLpl/mT+
        jp9YgrjLF2EO+TXifoYg6Aol0WyWYthgKmnYdfr/7wavQe9Ahh1h9XxiB61IgLZVqjRHhk
        /JYdO6GJ9ZxLaMBEIPW/9JfkXLZPueg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-37M20hvVOs6JpvL2CsI9zQ-1; Sat, 21 Mar 2020 22:21:12 -0400
X-MC-Unique: 37M20hvVOs6JpvL2CsI9zQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6ABFC13E2;
        Sun, 22 Mar 2020 02:21:11 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.40.208.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BD1573863;
        Sun, 22 Mar 2020 02:21:09 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: [PATCH NOMERGE iptables 1/2] man: xt_set: Reflect current behaviour of counter update and match flags
Date:   Sun, 22 Mar 2020 03:20:53 +0100
Message-Id: <20200322022054.3447876-2-sbrivio@redhat.com>
In-Reply-To: <20200322022054.3447876-1-sbrivio@redhat.com>
References: <20200322022054.3447876-1-sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since kernel commit 4750005a85f7 ("netfilter: ipset: Fix "don't
update counters" mode when counters used at the matching"), if
a rule doesn't match, counters are not updated, and counter
comparison flags are also evaluated before, and regardless of,
set element matching.

The current description for counter options seems instead to
suggest that counters are updated whenever set elements match,
and the user might assume that comparisons are performed against
updated counter values.

Reflect, instead, the fact that counter flags are updated only
if *rules* (not elements) match, and that packets and bytes
counter specifiers are evaluated against the existing counter
value, before updates (that might not take place).

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 extensions/libxt_set.man | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/extensions/libxt_set.man b/extensions/libxt_set.man
index 5c6f64e3..451400dc 100644
--- a/extensions/libxt_set.man
+++ b/extensions/libxt_set.man
@@ -23,37 +23,43 @@ match with a plain element returns \fBfalse\fP.
 .TP
 \fB!\fP \fB\-\-update\-counters\fP
 If the \fB\-\-update\-counters\fP flag is negated, then the packet and
-byte counters of the matching element in the set won't be updated. Defau=
lt
-the packet and byte counters are updated.
+byte counters of the matching element in the set won't be updated. By
+default, packet and byte counters are updated if the \fIrule\fP
+matches.
+.IP
+Note that a rule might not match (hence, counters won't be updated)
+even if a set element matches, depending on further options described
+below.
 .TP
 \fB!\fP \fB\-\-update\-subcounters\fP
 If the \fB\-\-update\-subcounters\fP flag is negated, then the packet an=
d
 byte counters of the matching element in the member set of a list type o=
f
-set won't be updated. Default the packet and byte counters are updated.
+set won't be updated. By default, packet and byte counters of the member
+set are updated if the \fIrule\fP matches.
 .TP
 [\fB!\fP] \fB\-\-packets\-eq\fP \fIvalue\fP
-If the packet is matched an element in the set, match only if the
-packet counter of the element matches the given value too.
+The rule will match only if the counter for the matching set
+element reports the given amount of packets.
 .TP
 \fB\-\-packets\-lt\fP \fIvalue\fP
-If the packet is matched an element in the set, match only if the
-packet counter of the element is less than the given value as well.
+The rule will match only if the counter for the matching set
+element reports fewer packets than the given value.
 .TP
 \fB\-\-packets\-gt\fP \fIvalue\fP
-If the packet is matched an element in the set, match only if the
-packet counter of the element is greater than the given value as well.
+The rule will match only if the counter for the matching set
+element reports more packets than the given value.
 .TP
 [\fB!\fP] \fB\-\-bytes\-eq\fP \fIvalue\fP
-If the packet is matched an element in the set, match only if the
-byte counter of the element matches the given value too.
+The rule will match only if the counter for the matching set
+element reports the given amount of bytes.
 .TP
 \fB\-\-bytes\-lt\fP \fIvalue\fP
-If the packet is matched an element in the set, match only if the
-byte counter of the element is less than the given value as well.
+The rule will match only if the counter for the matching set
+element reports fewer bytes than the given value.
 .TP
 \fB\-\-bytes\-gt\fP \fIvalue\fP
-If the packet is matched an element in the set, match only if the
-byte counter of the element is greater than the given value as well.
+The rule will match only if the counter for the matching set
+element reports more packets than the given value.
 .PP
 The packet and byte counters related options and flags are ignored
 when the set was defined without counter support.
--=20
2.24.1

