Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883BA2BEC45
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 02:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790301631; cv=none; b=jxscwMmy75W/AAg0Rh3Xg5Aes1CvRTvmi8vzcIjTl4GPk2rvdxPk4KpDE1AMnBCBdyp8j3YVc3iH6aPvAPYXjofdzk+dQexVTlUuidRZ9vAtghMx2mxdYsTr+z+cuv6DACJUNg4oy5D6NfLtdoHz2GQ8E3T0OX+R0ZZWRqCk48Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790301631; c=relaxed/simple;
	bh=B+MQDJkbz2ZurZea5vqo3nhLCU5cbS/MTcfN28h2I6M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hQdYaGDfHw/2Xl1jvsf88xOzkGsK+TnNCmPEcjFLKuiHKK5yH+Gsfa4D8kU1rNIPeGm3o+Zrg2VI7M4bXfG8PNr1Fp29vgeHVrop49ln+gTyo85GOe4ZphW0oMjk7+YRiIWLMW+1RfDRmlrqAqdmptcvPg2yT1Z5JR6onUPmJFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TfyZPT/x; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfyZPT/x"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396672b2569so17797a91.3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2026 19:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790301630; x=1790906430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wdXQvAxDw9Kg7I9/XYmAKp3RYy+BwvAtZIh1L7zo0oo=;
        b=TfyZPT/xFN1HR3Z5zKavfCc/upNJIEs3sGNuTPXQBh9B5bb4Pn8Y1eC43JWwB7SRAS
         U+eH6/EhwxeIiut5WMN1XfxkhYa9bB0E4/p0zvLofsO/SxwpXASh4N90Jzd+3d2WdCxh
         9/953vlZYTS3mqKDFfjfCqaCTuv6KK//+Nd/9bVKo30T1GZ4RW2DdYgJOlJCVomQPT35
         99g+TuLiixef/eYUAg2I+jBDhPwqiHQV0YVLxvto0Dedo5x0Uc4raGlyAI7B2zKltrWw
         oXQ+iMNeQkFItH21L6LC7unUP1aAXvwwjT0c+fqCHoFlyqObJtXtm3LWxRUYSr+ijuh8
         vYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790301630; x=1790906430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wdXQvAxDw9Kg7I9/XYmAKp3RYy+BwvAtZIh1L7zo0oo=;
        b=NRrpJHkRUuOZGDEkCVVH7RA5JHe32+yLaP7MjO+SGGRmSgmCgXjynwJefP37F0Kq85
         xv6QsnjXAqwqKa7XnsfzgyfNNnKFTMeJ3Eg4xRTIMvogKzUfUjwvhWjM8PSiPC5jpOfT
         7a6NQonVigxQnOeYQhJY+r6sylbhXfPzV8qDCWL04G6TkE3uX2DIKz51000+YRkRFFvz
         GcfSymC0cJVG/nng688tOw/j5mhuXg0DPxwhFieae3vKyPflt8r+QDEW0GU1Xw9c41jQ
         vm4vP42k+Gdxno6Ugm3fstaSaMZoxf+sUccHccgLIVwyIJ4AOLayn4Pu3uRgkrAGZjBM
         qA5A==
X-Forwarded-Encrypted: i=1; AKwUvBzkYyPxAcuaHsrBFKOMvD+kYOl/JJl6mIwtgPZ5RoPbgV+vqtSYFRHAe+/s8ZzmgWKVuPZyRpeX/KOPia/aET8=@vger.kernel.org
X-Gm-Message-State: AFuF++kOzzsyyUKnFggD14eAleN3Om/y8ajA/ALJlgvSeqI0v0C7FqHG
	5oI7Yx+dYrf4fkPrCIscNJUfzObx1p9s3PES+xSOj0VbZHqPoj6XMTnF
X-Gm-Gg: AYBFou3sAla7LIUSAbwtfKvmqFgAmaKr9huXYA0g/DTMmnJ5Bl9ooAXp/1R2Tdkt3ui
	zHREVQJ2tHb56rGrljjmF3ezZth9GVJge1cFA4DfWJ1zEK9GY59hQAElngS5Y7mXW5I1TqdsZAE
	9rUmsjaPdTOGdkXSzIbVRNOxFqi5s0XZEwnkKCGXCqWPUnCd6ytpVe0/UaKjVHesP2E/FBchLco
	grd/rrkw8m3Y6dqNnWM6qzHBKYr9d7VQVSMcLYJmTdJquFGkdXprAHUQyvZ3u0OQT7bOD7N287V
	TwpUDe5b6tXOvcwe8epCpRh+nb1Zvtj7zOZn8pMLZtUhutLntsN/jVlnd+O5AHHl79TXjksM3GM
	FqGIPOJl/ChqgjcfWvQIqEeDLl2NYylGKYqSjhEpsOKktsd/7sMvN8z93gOLoUO7kOlpcZo7Vi7
	/aRa42gZO/NsOLvO8qWmRSGTIKDKBZFnoKY/Zj98/qWt/oKvMetb9H2i8V1CN/qyICURFaGouaT
	ZpdQ7eMNQ4=
X-Received: by 2002:a17:90b:3889:b0:39e:55ce:af15 with SMTP id 98e67ed59e1d1-3a0b28344abmr2168977a91.5.1790301629463;
        Thu, 24 Sep 2026 19:00:29 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0ba31f408sm369914a91.3.2026.09.24.19.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 19:00:28 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH request stable 6.12 6.6 6.1] netfilter: nf_tables_netdev_event UAF of binding chain
Date: Fri, 25 Sep 2026 02:00:25 +0000
Message-ID: <20260925020025.616-1-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

Please consider a backport of the following use-after-free to the
longterm trees that still have it: 6.12, 6.6, and 6.1. 6.18 and newer
are not affected.

There is no single upstream commit to cherry-pick. On current linux.git
the netdev notifier no longer calls __nft_release_basechain(); it only
unregisters the per-device hook. That change arrived as part of the
netdev-hook rework and does not apply to these stable trees.

Bug
===

nf_tables_netdev_event() walks table->chains with
list_for_each_entry_safe. On NETDEV_UNREGISTER of the last hook,
nft_netdev_event() calls __nft_release_basechain(). Releasing the base
chain deactivates a JUMP to an NFT_CHAIN_BINDING chain, which
nft_chain_del()s that successor and nft_immediate_destroy() kfree()s
it. The walker's saved nr still points at the freed nft_chain.

Still present in:

  linux-6.12.y  (6.12.111)  nft_chain_filter.c: __nft_release_basechain()
  linux-6.6.y   (6.6.157)
  linux-6.1.y   (6.1.188)

Gone in linux-6.18.y and linux-7.0.y.

Reproducer (nftables 1.0.9)
===========================

An anonymous jump is what sets NFT_CHAIN_BINDING (chain flags 0x4).
Commit the base chain first, then add the jump in a second command.
Chains are appended to table->chains, and the walker frees the chain
that follows the base chain. One nft -f that contains both creates the
binding chain first and does not hit this path.

  ip link add br0 type bridge
  ip link set br0 up
  nft -f - <<'EOF'
  table netdev t {
          chain in {
                  type filter hook ingress device "br0" priority 0; policy accept;
          }
  }
  EOF
  nft add rule netdev t in 'jump { accept; }'
  ip link del br0

The namespace must still be alive. Netns teardown is too late: nft
pernet exit wins that race. Needs CAP_NET_ADMIN. Do not run on a host
kernel.

Confirmed on Linux 6.6.144 KASAN (same __nft_release_basechain() walk
as 6.6.y and 6.12.y). I have not booted 6.12.111 or 6.1.188.

  BUG: KASAN: slab-use-after-free in nf_tables_netdev_event+0x635/0x970
  Read of size 8 at addr ff110000037faa20 by task ip/229
  Freed by task 229:
    nft_immediate_destroy
    __nft_release_basechain_now
    __nft_release_basechain
    nf_tables_netdev_event

The read is 8 bytes at offset 32 of a kmalloc-128 object
(nft_chain.list).

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>
