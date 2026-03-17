Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A702037107F
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 10:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773742544; cv=none; b=PbPjUen5deEbH6Um2ILjDw5sgTztUz0o6oCWmn1uf/WTs+ej3UmYh7SOkdc/wYb01IaXqwkHr2PqSYgIm0oZHLUBcYe+lBKuPTt5KQQ9p6R3mbH8Eq9lxUkhwX01hSlmS7HkdO74HsEG3e22A84F1/AsQoVOPdEK7o7TSdrHEEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773742544; c=relaxed/simple;
	bh=qQsRsRo1lwM6NZ4V6oJfN2UKgfC38t0H7ex14ZKedEk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CIg5+IyLsrBpSGHIrCg70MrF7RGMcZytCrHLce67Q2g+TdEIiPRf468HF5+DjBqVXFuXUfCGjOfhZffr5LKsdo24ASQ7/OTFzJThawo/48yaa87jVOpeXNaGruuLWexi2Rp4RIpf67ygbUCpvCs5b3hjkFFvJScSQmXY4gPLtH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T2wV8MV2; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T2wV8MV2"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b97bca3797dso290445566b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2026 03:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773742540; x=1774347340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iRfjqfC/TBsGVHqBrwzxSIT/mb5DrDQmAIZikbq0tmE=;
        b=T2wV8MV2NyFc103MuvEJc+GKaXi1VZl8XQR9cc65Jj8cITqe2nmlhyRT/jVOTmn5ta
         0V2lti5sbKPPHjpWy0amNJNRxPDQ1mgb5/Yi3Zrp/KS0NUj8P2g3YPjP+vCgrrLi/pV4
         j+hApRBIGHV22TsSomHI2KVKbFOwjpnuDvfl1k8bv3BRtzjxDgICpu/bCDzUGS/nXNGr
         IMWETVVglpOl3uNIC8s9P7cets1qXPJTSuVEpt4CZzhvcLVRttn4W9R2tGL1wXZXh5qq
         h2mbb5+aZdfArlc710yTktryLtbRrT0611UkH4gLUAPLkEz7D6FA0AhY2SFxJlcCVhMx
         dg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773742540; x=1774347340;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iRfjqfC/TBsGVHqBrwzxSIT/mb5DrDQmAIZikbq0tmE=;
        b=Z99JE7WfGQCyLLcCUmYKmm18RRxGUiZF7GQjuV+IIDcx0w49fFzw7Dv4TuLN/Z4kmw
         Y5UTOqIL/3d1vWflPIDyinuBZW763Kq/CfEKzzacvm4ivJ8MEylUTpLn2whoXwbZXnxr
         ggvsOoBGvJr+a2UBOKU4FE63PmYPHMbkOb1N1LKAapNhtSjEzD8g5Jx02ad5kDC6HQB2
         8UeqQoCGHKWAFL5T6L+VfSALj/jporzFinE4sRePJdxwQciyjjxfktFap2xHIhEFIQcH
         h9qptN3vc+R1Fk2fOu8/W4wHVMkChwhklWuBT9xqY5KdpNJZvOCYLI/1SmSvsMEwRzan
         23fw==
X-Gm-Message-State: AOJu0YxUWzm/E+9qBfTsUDIeOWWqgov4Ojc/+9ZMpJcETkU6lgld9pmk
	0+Qg/LWtrCqBYx3fP4R4r/ruhVnHoTBVBF8Hf89vahZ4+k3XmvT9ptOK
X-Gm-Gg: ATEYQzzxP7k8NarSfa1cOUKRzbVvuL/gZetQgbTifDTcs0cx1AAjuLRkV7rtGovifVq
	lBmIIfJGylRV086+zvVpJOHkKuYq8QMnwMAHOotAYWuezql9e4kak83VxK8gCYhesYJA2U0Bpxs
	5gnFNk21fzUfmsgpkfDtUUijBaWVuPr1fF86WRZFWmf1DeIOrXYB98J7OUtbN28ENPthwnzjUDN
	zoLTFAM+FpJurSpm2ph7r99ixgbEN/JZb9qyuXmiI1sDrMNQLfnPlRmBObFfrGOFzyamuJxJKcP
	p3HsiozS4LkhKdWMHW0B/kfxm+UpZc9mmokGeEyVs5MpTPIfwSSry/CMQgt5sSfqn48B0nc3YQ5
	nGSAyBW8Uz9Ufp+3QV9P+TzXEkm6fBCM2hMB28fHr6huWgOGO0YGhE8UCAxaPslY5qBKd4SNxb2
	Ee+25IHyoakRkhKQ88/iCacT0memlskKKv7RF5HHpo/ktAZv3ulCBsoZvz2o+CK9gzITDOnBhRl
	9oYok8xKawaWHX9EFIwf6PKnzSNf/jqUYyP5B7tEdXyps9W88xyeaQ=
X-Received: by 2002:a17:907:9343:b0:b97:3bbe:e432 with SMTP id a640c23a62f3a-b97650e9a55mr945539466b.23.1773742539481;
        Tue, 17 Mar 2026 03:15:39 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9781914f96sm656674666b.47.2026.03.17.03.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 03:15:39 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH v12 nf-next] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Tue, 17 Mar 2026 11:15:25 +0100
Message-ID: <20260317101525.358016-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
forward path is filled, ending with mediatek wlan1.

Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
with info.indev = NULL. Then nft_dev_forward_path() returns without
setting the direct transmit parameters.

This results in a neighbor transmit, and direct transmit not possible.

So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
direct transmission possible.

(Also needed for flow between bridged interfaces, maybe implemented
later.)

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
[ Rebased; moved to nf_flow_table_path.c ]

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

---

Changes in v12:
 -Split from [PATCH v11 nf-next] netfilter: fastpath fixes

Changes in v11: (results of testing with bridge_fastpath.sh)
- Dropped "No ingress_vlan forward info for dsa user port" patch.
- Added Introduce DEV_PATH_BR_VLAN_KEEP_HW, which changed from
   applying only in the bridge-fastpath to all fastpaths. Added
   a better explanation to the description.

Changes in v10:
- Split from patch-set: bridge-fastpath and related improvements v9

 net/netfilter/nf_flow_table_path.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 6bb9579dcc2a..f2d7822824bc 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -103,6 +103,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 		case DEV_PATH_TUN:
@@ -116,6 +117,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				i = stack->num_paths;
 				break;
 			}
+			if (path->type == DEV_PATH_MTK_WDMA) {
+				i = stack->num_paths;
+				break;
+			}
 
 			/* DEV_PATH_VLAN, DEV_PATH_PPPOE and DEV_PATH_TUN */
 			if (path->type == DEV_PATH_TUN) {
-- 
2.53.0

