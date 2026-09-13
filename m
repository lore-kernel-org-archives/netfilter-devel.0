Received: from mail-ej2-f6.google.com (mail-ej2-f6.google.com [74.125.228.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585473839B8
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 10:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789296175; cv=none; b=ljFXQhYgLIR1zu9cLQzPZA+92ElJU0/7ZBe1kNsmiQqzQl8c0h046tEFLFmwLkEbMnPkMxvSiYX6jhyiw2erOmbIunVuyTfiz2mnsgyrOaNp3I6YTp8awCtZDRNEeZ+w+5rZ2LKxAF/k0dxCBfxB6jYDOqdIc+4mJzgMnEG28AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789296175; c=relaxed/simple;
	bh=Hgj7etMDcCAJvV15w/tbXFhz6t0NQuJpjZlontCcE+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoX7O5g3+0d8yhaxYnKoMKLEjhEkkX1HAniwDd72HPYdxZcMal+O53TBzpvtebRjDGMVUsh1SOLZbawc2C+eFoukQ0WIP3cuh9sRIX9fFbCrgxm8jU+3YMzJ+QaPzAeiS9cDsOHUqPIFu300m/JGFZOtkPw9NddZadK92iIuBq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=LlWu4H64; arc=none smtp.client-ip=74.125.228.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="LlWu4H64"
Received: by mail-ej2-f6.google.com with SMTP id a640c23a62f3a-c294716dbf3so174876766b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 03:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789296172; x=1789900972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L7E6Jghy9mgdjP+MNRkB5vpWmg9D4fAqbUGCwdvSH9A=;
        b=LlWu4H64sijtqwvN3Ptqdhc+cOGNCMWNtLhJJ/dILKk2H40UNZSDL/irzxZ4jLiTJq
         DmlNYek7sNAHEvF52/cX0clvKnZFkRvpCq6u4DXhrT1tH11JxushNkRcZzxR1GFvVss2
         VKNjtf7PD5f5wYt7aMLrw9OdioU4BeeMLkjGbSFqCOmCqUdDiBUVRWv0/Ql6PDdFF7M7
         Z+YmV3jNU3/1SvcyShAnMTori55OmCjo8RL//yYXt4PApO9RTCMRyBd40KD8FkXg5Kn5
         ikfJEzBrcTzI1W2T/TpzG/kuI2PMIStr6miwRoLZXH8b4kCVxh/yhrezt2lmrYjsqzA5
         J0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789296172; x=1789900972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L7E6Jghy9mgdjP+MNRkB5vpWmg9D4fAqbUGCwdvSH9A=;
        b=qrbDkimSdj6KvXLrHG2ZMrSYgRWXJgYC4t2mkRci1SFjLZhW25CaJQulP2CFR52eMV
         xz9DeWaOmfvlg1RKHWd/xKvKHT5DqmNo0CRxic5Szc4ewDcIJ/iVY1cRWoz6fyv8F98s
         egUS5KHZsK2BQyrXaOpcmVhIQiSBAN267/0muBpD4lwzkCpcDux/IgOQah7s+Fyx0M0X
         XWlX6t1vkZL1UTjDUKSYIzeq0eNQSD4CTi3i2q2Yc1y9tzLFXal7k5btAi3rSQ5UKw9g
         GQCDemf/tFxVI5LZwL4zcaH/dIECm09LKXoW501C/HHJAL64SjLCPU8FcHYKAuoG/lbn
         nAKg==
X-Gm-Message-State: AFuF++lyl7t4oqjWYGcELzDnWh8FsJdoF0zhGpyeLmqKGExbLNNNMmhL
	1qXqog1cHmJq6EW3iHjWVtlwpvrLmj446s/a5nn3dZw1KSfuEkKnd+vs3PFXntrklhAU7HU5R+w
	X2HYBzpGphe6Fv6Kt
X-Gm-Gg: AYBFou36t9WQExg7kxiTQmFpTZcykz0saw9ZYxBRUxqaDa5c32cYSy7VqM4Km/lrX2V
	5rzDyDVKnj5H4Myzue8a1tkRrYyU6L3CT+NpwSEuam2Lv8BYg9LJasz53m5E98EFqBFCGUc5Cvx
	Rc4ShtZqDoV4uykTQcwwFTg8FHD2mq7wTE2CY1y5xlqa8fJiVU6c7IFos7rmiMikY7QbGvtjHGO
	gksfFmGrsFJzq1LSIV/HeCUdy2BXI8d7/8bvTTPiD5MmtRodIad1rYf5Lcv68sarDSIxIcIlx91
	x2mgD3cEbYW7VpPKQoWxMrJyPg5Nx7dDlwowjrFfpssay3lH4RgsTNh3QPVE4aogevLPp9OR7v0
	yOBbWJGgzio/5Q62a+7BgpoaA3jRQwePq3pwDtgyAtxkpB2M4g738Zed4rbLWxRadjDMzBzPHgj
	CYzLw9sIogY7RtLnYYQNJQHh6u4nQRrM05TO9i8QxeSk/WYfWFwWY9XXa9Phf3Wa+lNoWMdzzUT
	Ko/709vGMSx91Yi4i9k8LYaa+jJnVjAPJf85r2c5r0tME7wh9R3VeFI8U2bRSCrAZ8+SMiTrWG2
	huUX332oeT+pxvbx5mb5J3kBAraieiiYwgm71Jm97gJelepn63Ao8VWc6pGuHaIC+nkAOXfd1yt
	OFWfVd8vKyndUljj9h/te8sKTjsTFfM/vzyUl868ObaZXEElio1EtgLCocqZ3501SOa66sUNudX
	Hv1c/5znCC4Wqcn8TeM/LpU20=
X-Received: by 2002:a17:907:c708:b0:c26:1691:b36e with SMTP id a640c23a62f3a-c2985880e9dmr342461566b.39.1789296172284;
        Sun, 13 Sep 2026 03:42:52 -0700 (PDT)
Received: from Desktop (p54aff833.dip0.t-ipconnect.de. [84.175.248.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296605b438sm278678266b.26.2026.09.13.03.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 03:42:51 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	wenxu@ucloud.cn,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com
Subject: [PATCH nf v2 0/2] netfilter: flowtable: correct and advertise the vlan match
Date: Sun, 13 Sep 2026 12:42:49 +0200
Message-ID: <20260913104251.648421-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260906141947.480524-1-julius@bairaktaris.de>
References: <20260906141947.480524-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_flow_rule_match() builds a vlan match for an offloaded flow and
never declares it in used_keys, so no driver reads it. Patch 1
restricts the vlan key to the tag that is outermost on the frame.
Patch 2 sets the used_keys bits.

mlx5e is the in-tree driver that reads the vlan key. With the key
undeclared, __parse_cls_flower() installs an untagged-only match for a
flow whose ingress path carries a tag. After patch 2, mlx5 hardware without
outer_second_vid support rejects a double-tagged flow instead of
installing a match that cannot hit, and the flow stays in the software
path as before.

An 802.1ad tag is neither matched nor popped, before and after this
series, and a flow with an 802.1ad tag outside an 802.1Q tag gets no
vlan key after patch 1, as a flow with a single 802.1ad tag does
today. The pop action for the inner 802.1Q tag stays: mtk and airoha
ignore the vlan keys and FLOW_ACTION_VLAN_POP and accept that rule
today, so patch 1 does not reject it. Matching and popping 802.1ad is
a separate change.

Patch 2 is tested with an out-of-tree driver on IPQ8074 (6.18): the
driver reads the ingress vid and offloads the flow. The mlx5e
behaviour is read from the driver and was not run on mlx5 hardware.

Changes in v2:
- Name mlx5e as the consumer instead of mtk. mtk_flow_offload_replace()
  reads the vlan key only in its addr_type == 0 arm, which a flowtable
  rule never takes.
- Add patch 1. The else branch of the second encapsulation block was
  also reached with an 802.1ad tag outside an 802.1Q tag and described
  the inner tag as the outer one.
- v1: https://lore.kernel.org/netfilter-devel/20260906141947.480524-1-julius@bairaktaris.de/

Julius Bairaktaris (2):
  netfilter: flowtable: fill the vlan key from the outermost tag only
  netfilter: flowtable: advertise the vlan match in used_keys

 net/netfilter/nf_flow_table_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
2.53.0

