Return-Path: <SRS0=H9P1=4W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEF1C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E55207FD
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Mar 2020 20:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4qk1Q/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgCEUeT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 15:34:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:30995 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgCEUeS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 15:34:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583440458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wBYDrzFKvbdYPaZwx64CedCJkcROH7sVVuCttU8bkLk=;
        b=b4qk1Q/TomJuymBDzhXel35iIav13oT2dWmmsZj22H5Slp22OOD45W3+Len/a2QnphHk/j
        XgmZvDZk92rc4UZiEzwRH9jZ9gHkcscxNu7mi/BKc/fLh9tV9j7ifx3nvb+0hUODQZ5oHW
        x3FuBZYt86O/mJLvHMQ3RU8wo4y2TNQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-6W-FMl6PNoauMwLrpUBuwA-1; Thu, 05 Mar 2020 15:34:16 -0500
X-MC-Unique: 6W-FMl6PNoauMwLrpUBuwA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93C86100550D;
        Thu,  5 Mar 2020 20:34:15 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-16.brq.redhat.com [10.40.200.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D0F191D9F;
        Thu,  5 Mar 2020 20:34:14 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: Introduce test for insertion of overlapping and non-overlapping ranges
Date:   Thu,  5 Mar 2020 21:34:11 +0100
Message-Id: <a0fbd674a9df38fddd9066dd4762d551c207d66a.1583438395.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Insertion of overlapping ranges should return success only if the new
elements are identical to existing ones, or, for concatenated ranges,
if the new element is less specific (in all its fields) than any
existing one.

Note that, in case the range is identical to an existing one, insertion
won't actually be performed, but no error will be returned either on
'add element'.

This was inspired by a failing case reported by Phil Sutter (where
concatenated overlapping ranges would fail insertion silently) and is
fixed by kernel series with subject:
	nftables: Consistently report partial and entire set overlaps

With that series, these tests now pass also if the call to set_overlap()
on insertion is skipped. Partial or entire overlapping was already
detected by the kernel for concatenated ranges (nft_set_pipapo) from
the beginning, and that series makes the nft_set_rbtree implementation
consistent in terms of detection and reporting. Without that, overlap
checks are performed by nft but not guaranteed by the kernel.

However, we can't just drop set_overlap() now, as we need to preserve
compatibility with older kernels.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 .../testcases/sets/0044interval_overlap_0     | 66 +++++++++++++++++++
 1 file changed, 66 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0044interval_overlap_0

diff --git a/tests/shell/testcases/sets/0044interval_overlap_0 b/tests/sh=
ell/testcases/sets/0044interval_overlap_0
new file mode 100755
index 000000000000..fad92ddcf356
--- /dev/null
+++ b/tests/shell/testcases/sets/0044interval_overlap_0
@@ -0,0 +1,66 @@
+#!/bin/sh -e
+#
+# 0044interval_overlap_0 - Add overlapping and non-overlapping intervals
+#
+# Check that adding overlapping intervals to a set returns an error, unl=
ess:
+# - the inserted element overlaps entirely, that is, it's identical to a=
n
+#   existing one
+# - for concatenated ranges, the new element is less specific than any e=
xisting
+#   overlapping element, as elements are evaluated in order of insertion
+
+#	Accept	Interval	List
+intervals_simple=3D"
+	y	 0 -  2		0-2
+	y	 0 -  2		0-2
+	n	 0 -  1		0-2
+	n	 0 -  3		0-2
+	y	 3 - 10		0-2, 3-10
+	n	 3 -  9		0-2, 3-10
+	n	 4 - 10		0-2, 3-10
+	n	 4 -  9		0-2, 3-10
+	y	20 - 30		0-2, 3-10, 20-30
+	y	11 - 12		0-2, 3-10, 11-12, 20-30
+	y	13 - 19		0-2, 3-10, 11-12, 13-19, 20-30
+	n	25 - 40		0-2, 3-10, 11-12, 13-19, 20-30
+	y	50 - 60		0-2, 3-10, 11-12, 13-19, 20-30, 50-60
+	y	31 - 49		0-2, 3-10, 11-12, 13-19, 20-30, 31-49, 50-60
+	n	59 - 60		0-2, 3-10, 11-12, 13-19, 20-30, 31-49, 50-60
+"
+
+intervals_concat=3D"
+	y	0-2 . 0-3	0-2 . 0-3
+	y	0-2 . 0-3	0-2 . 0-3
+	n	0-1 . 0-2	0-2 . 0-3
+	y	10-20 . 30-40	0-2 . 0-3, 10-20 . 30-40
+	n	15-20 . 50-60	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60
+	y	3-9 . 4-29	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29
+	y	3-9 . 4-29	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29
+	n	11-19 . 30-40	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29
+	y	15-20 . 49-61	0-2 . 0-3, 10-20 . 30-40, 15-20 . 50-60, 3-9 . 4-29, 15=
-20 . 49-61
+"
+
+$NFT add table t
+$NFT add set t s '{ type inet_service ; flags interval ; }'
+$NFT add set t c '{ type inet_service . inet_service ; flags interval ; =
}'
+
+IFS=3D'=09
+'
+set=3D"s"
+for t in ${intervals_simple} switch ${intervals_concat}; do
+	[ "${t}" =3D "switch" ] && set=3D"c"         && continue
+	[ -z "${pass}" ]      && pass=3D"${t}"     && continue
+	[ -z "${interval}" ]  && interval=3D"${t}" && continue
+
+	if [ "${pass}" =3D "y" ]; then
+		$NFT add element t ${set} "{ ${interval} }"
+	else
+		! $NFT add element t ${set} "{ ${interval} }" 2>/dev/null
+	fi
+	$NFT list set t ${set} | tr -d '\n\t' | tr -s ' ' | \
+		grep -q "elements =3D { ${t} }"
+
+	pass=3D
+	interval=3D
+done
+
+unset IFS
--=20
2.25.1

