Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792605039;
	b=2ohJxSCO0D3hJLbNNWR4QbvJodrqIesPZSjCVdj2lgfKwQnxx+MHZTIhGV7ydqydIw62
	 Rr8L0O+EtEoVvUTuAwUM4yv2qR+sl1Hlex1QNpVyKsiJAuSPZl6yR0kFMIVoWJvKZ4ou2
	 Ci5cKQLZG0MUgGcbCTfUmPR1oZ3gH4Do1Z5TOnhIVAsUTzl909H0BHq/XKV0+ysvcV/+A
	 vSIJGecjzwaIADeBSZCbHTtJhMPWjc5n9KQ/gkmbCqffIPfOWZ7tnLCE0Uf5GRuJsSNhu
	 /EnWEgu+WhfrDuXQeiDaQc2DjXqVovhUO6UFmXZ1Qpj5MGzq28Z1Chbj6OnrWF3LbVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792605039;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=3IXXlI8IfKDZpuZgXXc1tKoXMbgp2GbD0gTdMvnTrJ4=;
	b=bHItHUS95k6Ik+a16pQQL/TJsir9ugKJaqc/BAnB51R/qy64128fcHYOOvGOEuG5OvKN
	 nbKcH+9L2edCp1/Pg6EVDHmx2dD08ysgdZQ0RPWUAT1IFUqB1vEAMBON4DbrjMa8Bs3TU
	 ff8sylH30/AixxonuX6o1/JU4fwVxTFPT9KOrR6yLBXCSRGqjwO1cli/DVcEaoOWH8+8s
	 8RyKHjGkrb4KdNoG5ZkWA8lB/1CMhWazgjNumlp0vXvBTpclAv7Xu+gj1GRnApSWA3TRg
	 rI6JMbHrt4TStIYU2V6st1pL8EkiDY2imewErwFe4NNMvAY5Gm7EYmz4TC3QPPcCQOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TpfpBPYe;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD847606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 17:50:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD847606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TpfpBPYe
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a2001dd4e7so9619625e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 10:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792605037; x=1793209837; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3IXXlI8IfKDZpuZgXXc1tKoXMbgp2GbD0gTdMvnTrJ4=;
        b=TpfpBPYeeTIuIkjFk4y5JTEpW/hYSuUykegBuhBmEOEPLRmqQasGei5eaxIgEHH3Db
         uOKcV6tgpQ3asqHMryqKVdTVNbA87xo2+KjQCpQEdJpcfQ2tABaybKHH/W/RsZjnQZZo
         zyUt2sGeApRazUa5R07E9kUrXlsGNXDmAjxvtzQ4zr8slKXvzVRqy7UoZTFTaYSUjd4b
         zhlgK9IOZyfMRQkyzukVxXUiUCgYMWg89VEs0YfWiSqCppHQnTn2dhCGIY4nR5aXgFAl
         d7TRr6vSgKpwOHdckKTspNuyzL6eFtUK3b679gB/fKDzQYE9Rwiy25L9kNcmF8zQXjuV
         +1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605037; x=1793209837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3IXXlI8IfKDZpuZgXXc1tKoXMbgp2GbD0gTdMvnTrJ4=;
        b=kFkf3xAxYZ+8oOk6SZ+x6PPfc/t0OVx6AvhlcJ7iYdPzGrCNkLeIPjoV+iguE+JTiQ
         sNmAvmZ5x/1adzXkX1Lfm5iCD4AK2FXgtx1A7txe9pGpbHmRdIwxq6sM6WS9XXOxAVfv
         IfjfWlwsX1Bac76ps1XwSIRW1oZOd+5Aa1pEK10IK6Pd05cgEPhV39CmJEC4Fe8xsECK
         M50Kp6rx+XJQbeYrtu6epF2x8kjtKz2oi8oHgasdQJG6tFIt5vhIApVa4T4/GE7vwlAd
         KOSkdzgWV/S+Ban+gvPRWw6JQhESNIXGvRdQ7RTk8S3a1xaF9G9X3tXLdGjmwzBdRkKv
         eSYg==
X-Gm-Message-State: AFq9FYIk4FP1bnIqNLidnAK4+kWxBDBlghJ+qhaTsaZ3ELKTpoCDVtj9
	nC13YDwmsmgQ4H4i2MBkWoAmJCKZldo3CWVhqiXs1MtJd59jG1EgYCLnwlsMpdemsCRRhQ==
X-Gm-Gg: AYBFou3Lp5azWjavFSfpsFUvW9TKkwiVi/TgKHjTIlmAcxWfoND8Zi0LrrtMVycJ3hN
	Ked2gX5PrLmgFtZW68+joK4v+3CeTFAz+wQZ+uw6uGEndq87HKgJocZSEzyEL05lkfUPwVM+lvM
	yQ41JIrSZh9EderGzZMipPhzvu8aCNVB7CjY4vENzC8LjheAQ1Z2yRRSeh+DOC2u9dv+OsBlPws
	nq5ax8A2C8ul92zLzlUlAj7JZ79Fi9FSeg3kjHsZ1fhUkk2KxeavvvjtA4OAm7KJAWfNK2GlKL1
	3jdLk1BYjtCnqdr5LdGEaLOTkV7jyXJ/fD/4AKOttHBmYS7CUsfDJUNNB7kkqP6SRddOYW2ckfx
	lvAivomS3TFq/dgndQPaVYPomnu3w4Fr6IikyNBvvOZ18Tw1D086oCyram54AhjYTmm0IbFUQZw
	4jqosWAI1VbLEK2e2q7I9YZcisdRwhQnvNVelgau3QeV5wx4dFXj44EWsWVIKhtubtjCIzTDQB/
	Q4gCjgxbyE9MGBZJBWINyd7PlZymq3QE7d61pT6LWc6MMbYNgLEwjoma7+KxF0T7Q==
X-Received: by 2002:a05:600c:4713:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4a1fd8a675emr63145365e9.1.1792605036893;
        Wed, 21 Oct 2026 10:50:36 -0700 (PDT)
Received: from DebianTestingKDE-VM ([213.16.57.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828e54sm7228186f8f.27.2026.10.21.10.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 10:50:36 -0700 (PDT)
From: Valentin Berezhnoy <dreyksmail@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	coreteam@netfilter.org,
	Valentin Berezhnoy <dreyksmail@gmail.com>
Subject: [PATCH nf] netfilter: flowtable: fetch hardware counters before removing a flow
Date: Wed, 21 Oct 2026 20:50:30 +0300
Message-ID: <20261021175030.4800-1-dreyksmail@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The counters of hardware offloaded flows are added to the conntrack
entry by the stats work, which nf_flow_offload_stats() queues only once
a tenth of the flow timeout has passed since the last update, i.e.
about every 3 seconds with the default nf_flowtable_tcp_timeout of 30
seconds. When a flow is torn down, e.g. after a TCP FIN or RST,
flow_offload_work_del() removes the hardware entries without fetching
their counters, so the traffic since the last update never reaches
conntrack.

At gigabit speeds that can be several hundred megabytes per connection.
On a MediaTek MT7622 router with hardware flow offloading, a 300 MiB
download that closed its connection right after the transfer was
accounted at 69-84% by conntrack, but at 105% (payload plus headers)
when the connection stayed open for 10 seconds before closing, i.e.
after one more stats update.

Fetch the counters once more in the delete work, before the hardware
entries are removed. The flow and its conntrack entry are still
referenced at that point: the garbage collector only releases the flow
once NF_FLOW_HW_DEAD is set at the end of the delete work.

Fixes: ef803b3cf96a ("netfilter: flowtable: add counter support in HW offload")
Assisted-by: LLM
Signed-off-by: Valentin Berezhnoy <dreyksmail@gmail.com>
---

Notes:
    This patch and its changelog were written with an AI coding assistant
    (Claude), which also ran the tests below; I reviewed the change and the
    results.
    
    Testing:
    - Runtime: OpenWrt main (Linux 6.18.55) on a Redmi AX6S (MediaTek
      MT7622) with flowtable hardware offloading and WED, counters read
      through nlbwmon (conntrack). 300 MiB downloads that close their
      connection right after the transfer are now accounted at 105.0 %
      (3 of 3 runs; payload plus TCP/IP headers), 30 downloads of 10 MiB
      on separate connections at 104.9 %, the same as a download whose
      connection stays open 10 s before closing (105.0 %). That kernel also
      carries a fix for OpenWrt's out-of-tree mtk_ppe accounting patch,
      which is needed on that driver for the final poll to read the
      counters of an entry the PPE already unbound after the FIN.
    - Build: net/netfilter/nf_flow_table_offload.o on this tree with W=1
      (x86_64 defconfig plus netfilter), no warnings. Not runtime-tested on
      this tree itself.

 net/netfilter/nf_flow_table_offload.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 436585922..056c000a6 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -989,15 +989,6 @@ static void flow_offload_work_add(struct flow_offload_work *offload)
 	nf_flow_offload_destroy(flow_rule);
 }
 
-static void flow_offload_work_del(struct flow_offload_work *offload)
-{
-	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
-	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
-	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
-		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
-	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
-}
-
 static void flow_offload_tuple_stats(struct flow_offload_work *offload,
 				     enum flow_offload_tuple_dir dir,
 				     struct flow_stats *stats)
@@ -1034,6 +1025,22 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 	}
 }
 
+static void flow_offload_work_del(struct flow_offload_work *offload)
+{
+	/* Stats are only polled every few seconds: fetch the counters of the
+	 * hardware entries one last time before they are removed, so that the
+	 * traffic since the last poll is not lost for conntrack accounting.
+	 */
+	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER)
+		flow_offload_work_stats(offload);
+
+	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
+	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
+	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
+		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
+	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
+}
+
 static void flow_offload_work_handler(struct work_struct *work)
 {
 	struct flow_offload_work *offload;
-- 
2.53.0

