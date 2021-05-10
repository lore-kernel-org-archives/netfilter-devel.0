Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F378C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 May 2021 05:59:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05B0861432
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 May 2021 05:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhEJGAF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:00:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40601 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229608AbhEJGAE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620626340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w7JtVmLjbXPMOL7+Qh9GK/jGZwj1USDaLyLUlp8aJRM=;
        b=KvvelxzaDSc7Vj1CX1TChsqsclZ8DNYgWCP9xiLWiEJmtYXhtt1OYmdR2KslI6T8tjOugG
        mrbmc8SU919OJlOcQxSQvb1J5Ih689217p6GvBTXGOoztuxrK6uL7kiHIRRHVUwKotpngZ
        WACZ36zpVmVlJw1AuIbC0gJ/1sJSaDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-q38awlZOMSKkTnXvJOvX4w-1; Mon, 10 May 2021 01:58:56 -0400
X-MC-Unique: q38awlZOMSKkTnXvJOvX4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2599801107;
        Mon, 10 May 2021 05:58:55 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E69601037F20;
        Mon, 10 May 2021 05:58:54 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Andy Lutomirski <luto@kernel.org>, netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] nft_set_pipapo_avx2: Skip LDMXCSR, we don't need a valid MXCSR state
Date:   Mon, 10 May 2021 07:58:52 +0200
Message-Id: <1c53a6ec42c6ee933231eeeca27285f405cb0bf4.1620613229.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We don't need a valid MXCSR state for the lookup routines, none of
the instructions we use rely on or affect any bit in the MXCSR
register.

Instead of calling kernel_fpu_begin(), we can pass 0 as mask to
kernel_fpu_begin_mask() and spare one LDMXCSR instruction.

Commit 49200d17d27d ("x86/fpu/64: Don't FNINIT in kernel_fpu_begin()")
already speeds up lookups considerably, and by dropping the MCXSR
initialisation we can now get a much smaller, but measurable, increase
in matching rates.

The table below reports matching rates and a wild approximation of
clock cycles needed for a match in a "port,net" test with 10 entries
from selftests/netfilter/nft_concat_range.sh, limited to the first
field, i.e. the port (with nft_set_rbtree initialisation skipped), run
on a single AMD Epyc 7351 thread (2.9GHz, 512 KiB L1D$, 8 MiB L2$).

The (very rough) estimation of clock cycles is obtained by simply
dividing frequency by matching rate. The "cycles spared" column refers
to the difference in cycles compared to the previous row, and the rate
increase also refers to the previous row. Results are averages of six
runs.

Merely for context, I'm also reporting packet rates obtained by
skipping kernel_fpu_begin() and kernel_fpu_end() altogether (which
shows a very limited impact now), as well as skipping the whole lookup
function, compared to simply counting and dropping all packets using
the netdev hook drop (see nft_concat_range.sh for details). This
workload also includes packet generation with pktgen and the receive
path of veth.

                                      |matching|  est.  | cycles |  rate  |
                                      |  rate  | cycles | spared |increase|
                                      | (Mpps) |        |        |        |
--------------------------------------|--------|--------|--------|--------|
FNINIT, LDMXCSR (before 49200d17d27d) |  5.245 |    553 |      - |      - |
LDMXCSR only (with 49200d17d27d)      |  6.347 |    457 |     96 |  21.0% |
Without LDMXCSR (this patch)          |  6.461 |    449 |      8 |   1.8% |
-------- for reference only: ---------|--------|--------|--------|--------|
Without kernel_fpu_begin()            |  6.513 |    445 |      4 |   0.8% |
Without actual matching (return true) |  7.649 |    379 |     66 |  17.4% |
Without lookup operation (netdev drop)| 10.320 |    281 |     98 |  34.9% |

The clock cycles spared by avoiding LDMXCSR appear to be in line with CPI
and latency indicated in the manuals of comparable architectures: Intel
Skylake (CPI: 1, latency: 7) and AMD 12h (latency: 12) -- I couldn't find
this information for AMD 17h.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo_avx2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index d65ae0e23028..26cbd5a0da36 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1133,8 +1133,13 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 
 	m = rcu_dereference(priv->match);
 
-	/* This also protects access to all data related to scratch maps */
-	kernel_fpu_begin();
+	/* This also protects access to all data related to scratch maps.
+	 *
+	 * Note that we don't need a valid MXCSR state for any of the
+	 * operations we use here, so pass 0 as mask and spare a LDMXCSR
+	 * instruction.
+	 */
+	kernel_fpu_begin_mask(0);
 
 	scratch = *raw_cpu_ptr(m->scratch_aligned);
 	if (unlikely(!scratch)) {
-- 
2.30.2

