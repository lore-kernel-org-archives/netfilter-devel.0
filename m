Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC30AC11D32
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 17:52:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85F8820836
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 17:52:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NsdmE9th"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgBXRw6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:52:58 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55781 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgBXRw6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 12:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582566776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Nok5rvcHEPwISiSBowc38lw2iibPzDdKIse0Seo+A1g=;
        b=NsdmE9thcdTSefA482gOqKyxwLGJ4gLCwLqA7bxOhlO997RhXWI/dcjlW2VVKW6Uw4pUYT
        x4t45jbDCX/i2I9qv4Y9GMdEe0lViY6m1WHUtvYqrdt4wXZsfmrhgm+Twcu06EdSfCtScC
        wErFddx5V5pnl/9aYkgR5Chr7XvX4oI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-VWrnzLyFM5CZX9F0_-gDcg-1; Mon, 24 Feb 2020 12:52:54 -0500
X-MC-Unique: VWrnzLyFM5CZX9F0_-gDcg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BED4618A5500;
        Mon, 24 Feb 2020 17:52:53 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90BA01001DC0;
        Mon, 24 Feb 2020 17:52:52 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Mithil Mhatre <mmhatre@redhat.com>
Subject: [PATCH] ipset: Update byte and packet counters regardless of whether they match
Date:   Mon, 24 Feb 2020 18:52:43 +0100
Message-Id: <f4b0ae68661c865c3083d2fa896e9a112057a82f.1582566351.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In ip_set_match_extensions(), for sets with counters, we take care of
updating counters themselves by calling ip_set_update_counter(), and of
checking if the given comparison and values match, by calling
ip_set_match_counter() if needed.

However, if a given comparison on counters doesn't match the configured
values, that doesn't mean the set entry itself isn't matching.

This fix restores the behaviour we had before commit 4750005a85f7
("netfilter: ipset: Fix "don't update counters" mode when counters used
at the matching"), without reintroducing the issue fixed there: back
then, mtype_data_match() first updated counters in any case, and then
took care of matching on counters.

Now, if the IPSET_FLAG_SKIP_COUNTER_UPDATE flag is set,
ip_set_update_counter() will anyway skip counter updates if desired.

The issue observed is illustrated by this reproducer:

  ipset create c hash:ip counters
  ipset add c 192.0.2.1
  iptables -I INPUT -m set --match-set c src --bytes-gt 800 -j DROP

if we now send packets from 192.0.2.1, bytes and packets counters
for the entry as shown by 'ipset list' are always zero, and, no
matter how many bytes we send, the rule will never match, because
counters themselves are not updated.

Reported-by: Mithil Mhatre <mmhatre@redhat.com>
Fixes: 4750005a85f7 ("netfilter: ipset: Fix "don't update counters" mode =
when counters used at the matching")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/ipset/ip_set_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_s=
et_core.c
index 69c107f9ba8d..b140e38d9333 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -649,13 +649,14 @@ ip_set_match_extensions(struct ip_set *set, const s=
truct ip_set_ext *ext,
 	if (SET_WITH_COUNTER(set)) {
 		struct ip_set_counter *counter =3D ext_counter(data, set);
=20
+		ip_set_update_counter(counter, ext, flags);
+
 		if (flags & IPSET_FLAG_MATCH_COUNTERS &&
 		    !(ip_set_match_counter(ip_set_get_packets(counter),
 				mext->packets, mext->packets_op) &&
 		      ip_set_match_counter(ip_set_get_bytes(counter),
 				mext->bytes, mext->bytes_op)))
 			return false;
-		ip_set_update_counter(counter, ext, flags);
 	}
 	if (SET_WITH_SKBINFO(set))
 		ip_set_get_skbinfo(ext_skbinfo(data, set),
--=20
2.25.0

