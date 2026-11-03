Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793744599;
	b=GGz1BXiyEoEV+mrDFvg9mXNy0Q742/Z52z591kSLTIFGntD0kHkikFVGJFyt2D7CzniI
	 pRKLzUPFkwCP4k1fmiXt4yOLFbaVkM1fhEOI3m+L8MJU6+dupf6XuMaaP6c6An+spPCqi
	 NGu67O93p+Fu8zcWzdaxuZ6mCUuS4hhreeGvHJnxm9TbldCEPveYjZoO9Y1QxeqPOVS4W
	 qWI+cN0rgJHPlq8vnOBE35aex+LY1jBKOsQU62kNXu+Hj3ETjwC4L/t0Bl7rfAGwzRxPn
	 dtSRI9nNEOtq3DoBH8ICQ+6Z9nFtvmYb6b3/IGd8lFDI7eCDV/ZK99jbIth2cWVtvJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793744599;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=iGr4yuTjefH8ZNfeidLmCflxZz4RxW5d0w05fPgAcqY=;
	b=YExYLpqLX9h8lnWtw4LX4B/72VLa8lTcUJVwaRkKJMhFbDcaNZ9FxGTB/+mlMCnWbADv
	 jlR30j/4uA0NWfJ1eWOpLnnzhNnsjzAl3hJGkC7UAcZfMJh3BZ4//E+A1FfmeY2mzD8jJ
	 +rRF8P3JWagXtH6jKTu5YoiRrIYHG/8fpZXQk2zOawt6tiFQBDltmo/DtHiRbC6a5E0KO
	 QQFBNWK2YD4IfUn0PbAI6JOaLTkoCGnWDZaKYOfIxGid63gp7y3Ewx6zSvidybyiWbx21
	 bfmM9Ts1UO530kYKILPUWMk4cqvB9wBnfY9X3vKIN7MvnZbAxUxZTZPz+s97NnUKV4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c1a4sCHR;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5230D606D831
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 22:23:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5230D606D831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c1a4sCHR
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so57419f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 14:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793744598; x=1794349398; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iGr4yuTjefH8ZNfeidLmCflxZz4RxW5d0w05fPgAcqY=;
        b=c1a4sCHRs1R+HVGA0+smgfHw8U77MLHfiDhHaSSDZM0rMyYJM6NJ7y/aLc9PMYvMVE
         aEImCURBIakHt1zdqXNFUDlV84a+zq9LpoM/Ew4Ftv/eOqVx8RM3fsncbkztSwk0HToa
         qmHe5uB8FlQrv3tM9B0mYp9yro7N2iJaDYVtBUcGeFYvnatIZpoz4H7ofchRtbc1FeQ6
         HmUTIn4o6jUP2sEpSnVxWb4t8Bynx1S+XGYDDBPYxgJN8MIenxD88qEmzlw2EgKYjbrH
         J8ntbQ+3vS64o+r+cxZC3TgvBHdZ620m577ridfNOYiwXfFxvLYn0iqRsn6swLbP0Q0m
         RuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793744598; x=1794349398;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iGr4yuTjefH8ZNfeidLmCflxZz4RxW5d0w05fPgAcqY=;
        b=M8UN3kdnDOHwxXDeTc05VZhAVyYw1R05AuQdYVwbbgKg0GXj/caUncYTjf9sLyICkf
         p8MWPJ8b9AooSawF/B2vC+1pVZ0x2rd6XxCTvsTOGfJCzL4hVAPuc8ZzB/tKwm9TdOMc
         fZrjfadWQiAi57SlTyTNniJu1upWXc9/qITVyaZlAjMzvDIPPro20AL2jhPXY6VjqSGF
         g8FImDwyTJ8k0c0ZF/N3sy0ojEu/G6UuXWIYlridb4wkE8yanA0jfZ2Vl7X0sRderkBG
         GmK4o92YYy/P6hHRPJ7i6XUoYfpNYesNv89J5Sg3Gg7IsrtaK60xuQ5zgeZH/5lLn3o5
         d40Q==
X-Gm-Message-State: APuU4Z9tKCtxdNZBKVOkU/hys6P9o4yKRvAdS+wg6FTOFmk/PISHl/TI
	Apqchu4uZ6G0N/4xMUXFGGfunethOpHpdSb9LnaUQbvisp8RKgbNQw31AEVVEhI=
X-Gm-Gg: AYBFou3MRh2rIku5ae/kHZE79QUZPu/ZwX+IRL+1NzPszFyYo/G6MDWEvJ+9SO0KliZ
	NCjHuOl5oJSvHgfXkQKMwj8NlJYimV95o+o+K8pUqWerTG1/1sTBAPbtGzboBHB3Zg9+3LvyJ0H
	9jORaS1iU/LsuwWhyFSPbxcmDJHfTksb7nB9CUiFCbt1d44c33rtH3XIlp5oSGYAmYAI1Pmuwqw
	C1mmEhFwb3e/ut0XoWrohxNrPGd8WAAWYAxo2nioKuG3hcvqsiMHpk/0JuuR/BhJeuhM7x0OmG9
	JSlAoDhiwcKGQuhCRhQkIPyJk2VqoZjnMZvqdAugeGLb8kiK4cWHRBpoACc2yLsSDZOOCzGi4A6
	oa2AreFi/fh39P3XigxGPSVFf1dOemuCFLqLfZ5hsucHouPoET8Cvy1TjIzrxhq2p9oL979aZKd
	kD3Rr/3qpyjsetnJdfXIe2aZCXD2Xq6rh3ZbSgJ9pC1reHu0AbG4XXrHKZQwd+d9gpo8klct4g2
	YjjvOLtujGKDGHmJbAwQ2X730B3eIIAXFtK4rzXbMMrvFeK7B0kh/wVP9DEt3xuhFvd7k/ci0vc
	AQfWXDb/blmhYhkvX20CWAA3ihaLD50qc2Bro5jvDZX57lbROdmtA1LFfg==
X-Received: by 2002:a05:6000:26c5:b0:48b:e50:714e with SMTP id ffacd0b85a97d-48e6e50d8a5mr30353676f8f.36.1793744597651;
        Tue, 03 Nov 2026 14:23:17 -0800 (PST)
Received: from ps42.lan.pis.avalls.dev ([2a0c:5a83:540e:7d02::ed7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed551dc5sm279312f8f.34.2026.11.03.14.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:23:17 -0800 (PST)
From: Arnau Valls <vallsfustearnau@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Arnau Valls <vallsfustearnau@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: remove hw flows before unbinding the flow block
Date: Tue,  3 Nov 2026 23:22:43 +0100
Message-ID: <20261103222243.445644-1-vallsfustearnau@gmail.com>
X-Mailer: git-send-email 2.54.0
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

Since commit 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable
binding"), deleting a flowtable unbinds the driver callbacks at commit
time, before nf_flow_table_free() queues FLOW_CLS_DESTROY for the
remaining flows. The destroy requests find an empty cb_list and the
flows stay in hardware.

Conntrack then times the entries out while the hardware keeps forwarding
them. Once one direction ages out of the hardware table, its packets hit
the stack without a conntrack entry and get rejected. This breaks
long-lived UDP flows such as WireGuard whenever the flowtable is
recreated, for example on every firewall reload in OpenWrt.

Remove the device's flows on FLOW_BLOCK_UNBIND while the driver is still
bound, as nf_flow_table_indr_cleanup() does for indirect blocks. The gc
skips flows with pending offload work, so run one more pass and flush.

Tested on MT7981 (mtk_eth_soc PPE) with v7.4-rc1 and 6.12.74. Found and
fixed with help from an AI assistant (Claude).

Fixes: 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable binding")
Cc: stable@vger.kernel.org
Link: https://github.com/openwrt/openwrt/issues/17915
Signed-off-by: Arnau Valls <vallsfustearnau@gmail.com>
---

Notes:
    Reproducer: hw-offloaded UDP flow through NAT, then delete and recreate
    the flowtable in one transaction (fw4 reload). Without the patch the
    conntrack entry gets a timeout and the PPE entries stay bound. With it
    the PPE entries are removed and the flow is offloaded again within a
    second, no packet loss over six reloads.
    
    Not tested: lockdep, other drivers, the indirect block path.

 net/netfilter/nf_flow_table_offload.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4365859220e6..68654d243bae 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1279,6 +1279,15 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 	if (!nf_flowtable_hw_offload(flowtable))
 		return nf_flow_offload_xdp_setup(flowtable, dev, cmd);
 
+	/* Flush this device's hw flows while the driver is still bound. The
+	 * second gc pass catches flows skipped due to pending offload work.
+	 */
+	if (cmd == FLOW_BLOCK_UNBIND) {
+		nf_flow_table_gc_cleanup(flowtable, dev);
+		nf_flow_table_gc_run(flowtable);
+		nf_flow_table_offload_flush(flowtable);
+	}
+
 	if (dev->netdev_ops->ndo_setup_tc)
 		err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd,
 						&extack);

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.54.0

