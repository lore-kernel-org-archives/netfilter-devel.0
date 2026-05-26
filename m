Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F923384244
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 06:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779775326; cv=none; b=as/phhhLK3o4uWbugdbbkkBdzRXY+77KT9i/oPpCcfKWbF5LYRQqrssbPtYiOBbErys71fTdbrfbSj6uFK2mhpc7yLxjmZJXNUzeqhId+86nXFY1xhosScUc1SWpzHAk2tLj69OtAbWasRcq03SlSNTfhpKDn58/4P2+JVGgWBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779775326; c=relaxed/simple;
	bh=ChxFUaH9zjpYx8BRjD9dZ1vHU8YYLfBsQ0g0/WFsa04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aB7qmzRQAFMmnbczk017o9bJ4qVfdbSlpzspEwF20/olXvvKScO11/TPfT17htAZCW9rX9giaF9ut4k+gBiKsmPBgauNYjmXT1fPtOI8pB/lNzMAdzA+RERnFUnEvO6RfQT/7Sp+5neM5dM76FWpXi56EU/M0uhqd+NxMJUxLMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q6IuZOdC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6IuZOdC"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48e8132c6d0so63743535e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2026 23:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779775323; x=1780380123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I15Qye72rXnWF52br0qRQsOfcY4+owD8kwcdhmYsCXA=;
        b=Q6IuZOdCTtzoZaDj/nzDRpZatytcBKlnePx4JQLKE82LcAmYjUMNJYGJYxw3RmWQkz
         /awJktpuJ+ZhScg8WdbZ981evwEsmTR3oQTzg4E9yjjou6iAt7thD1u1Alh5mxDlKUQH
         BwwSMFXDDHpYkTVf+iNe+y/WM1C1V6pweNWYzDf+Ix3fE+IA8SQ8WHkRPNCAwwQGrZVi
         8fpKs8xI5GoGrgGMBk1A5u89cbK95zR7XykcT0qJbTFHAUPXkexux6zAlyvGZuLMBiDk
         ySln2gzsFWHdIBDUXFfBRcy3ocBQaQSyoHdIDjzt3PDcPnuibYX2ebWvNPGJzSYWYkNh
         z9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779775323; x=1780380123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I15Qye72rXnWF52br0qRQsOfcY4+owD8kwcdhmYsCXA=;
        b=bClIbtUqwPl/VLKGNOmKa73OQa09OeLSyOS6MU5tK2cSNjE07s7RQjIMJzbZG/IE+z
         R33ZBiGv/jDkCv260vHlfSjtknaiyGp/8BUDP7lxmXTyDxdIjVrA9TWZTGf6lwg7WD9Z
         DQt+QemAAL3QpEDgfGgz9ETQBgs14NO1ERrrAHRC/03uARiMY90TV40w6zkM7BXUAR32
         kWmrr8BPPHmeujnvOoMIljLnOdfjrNXpIEe0f5wt3eCalXmY5vVPazDvlXIMga0MXc6M
         TjswkKJdQ2zwDupkBj3wC9GzrRvCRp4jxjUAVr0+yxdmD9mCid8/VYC/7RdMB/IxvZ2O
         Eu+g==
X-Forwarded-Encrypted: i=1; AFNElJ8BnSC+PaittXw1V1J62ZZamPMd2SNU55qIM6j6Zw2DSi7HpRu724iS9yxzhPDYp1hZ5kY62+zcSrtncZBG2ZM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBEEVFSzrP1BlMcadQH3IfwCnLARYkrVC9z2gcmc7SdlTGylrt
	mvTS9ESJ/0Iox7lHX5sT33mG/PdZAQ1WnQCI/u332MvuwobnU/OPOw0Y
X-Gm-Gg: Acq92OGrVv62eFp0aA832yN4ccLA0o7uwnHzBIjndQQAjYESsg361EXI7ytq0eLi2iJ
	YI35uWU/2ZQk5A8uR2IdYuqUXJA/J6Z3DhB3YWlkRqpS6WfQB4Kzf+j19+0UoU14j1e9mwwra6q
	j4V/CiH2ezNFq6OzaKjmT+1m/SGDJv2izPsSW2pLea9E+ejTjCf1Ve/j5sLB9m0oCDqrvetjcJh
	Z77UGvQHq4DpTrf69iqh/gJJi/Na9Ru58Vnls4grv60IetA+2E5zxe8svxf8SeqaczvGjLYBy5u
	XOjrlUMten0Igm4xaiR8k+i/WCXoSG/bhAg1CSy+NK9prw6QpVQEHa4B0MY5FP2i3CggBaLRv0S
	aNET8TB5y2cdWNXsAM4n1l84n4fSubotw2ZIrRQt5mBIEHDTaTf9a+BghwxMWJ7oZ87p+xa3ieS
	4wjMDGADn4GMBbrL7XU4aMDsxa1hxEYs+7mno8a/c/5tqMv5fGmUkEGHzYR8lrQZyEqlut+ldDZ
	uS82Fc=
X-Received: by 2002:a05:600d:6447:10b0:48f:d5b8:5b07 with SMTP id 5b1f17b1804b1-490426c5b1emr200251675e9.20.1779775322583;
        Mon, 25 May 2026 23:02:02 -0700 (PDT)
Received: from localhost.localdomain ([188.27.64.216])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490454b7d57sm295929035e9.15.2026.05.25.23.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 23:02:01 -0700 (PDT)
From: Adrian Bente <adibente@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org
Cc: phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	nbd@nbd.name,
	sean.wang@mediatek.com,
	lorenzo@kernel.org,
	andrew+netdev@lunn.ch,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	daniel@makrotopia.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Adrian Bente <adibente@gmail.com>
Subject: [RFC PATCH net] netfilter: flowtable: fix offloaded ct timeout never being extended
Date: Tue, 26 May 2026 09:01:38 +0300
Message-ID: <20260526060138.3924-1-adibente@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OpenWrt has recently migrated many platforms to kernel 6.18. On the
MediaTek platform, which supports hardware network offloading, WiFi
connections accelerated via the WED path were observed to drop after
roughly 300 seconds.

After several debugging sessions, assisted by the Claude LLM, the
problem was narrowed down as follows:

nf_flow_table_extend_ct_timeout() extends ct->timeout for offloaded
flows using:

	cmpxchg(&ct->timeout, expires, new_timeout);

'expires' comes from nf_ct_expires(ct) and is a relative value, while
ct->timeout holds an absolute timestamp. The two are never equal, so
the cmpxchg always fails and the timeout is never extended.

This goes unnoticed for most flows, but a long-lived hardware (WED)
offloaded flow on MediaTek MT7986 eventually has ct->timeout decay to
zero, the conntrack entry is reaped and the connection breaks.

Compare against the current ct->timeout value instead.

This patch is sent as RFC: the diagnosis is verified on hardware and
the fix resolves the drop, but review of the chosen approach is
welcome.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Signed-off-by: Adrian Bente <adibente@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -541,8 +541,10 @@
 		 * after this -- is fine, datapath is authoritative.
 		 */
 		if (new_timeout) {
+			u32 old = READ_ONCE(ct->timeout);
+
 			new_timeout += nfct_time_stamp;
-			cmpxchg(&ct->timeout, expires, new_timeout);
+			cmpxchg(&ct->timeout, old, new_timeout);
 		}
 	}
 

-- 
2.46.0
