Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095671E5203;
	Tue,  8 Apr 2025 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122451; cv=none; b=RuPDem33fv3S0DHKGZcgYBhQ/nGM7EakjIiSlgyF7gYAFY1fe7wLAMMYNu+kZ0Y4AcC6z1UerzSewyahpcCB6VjlbqoPlJ0fJUSy8eU2fhXwXsLPyxGuqJ4AamehD8v2eUvGA3r4IQpofXfHCXQfCUDNwpS4iBPReE937vnZgdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122451; c=relaxed/simple;
	bh=skNX0VMpyq4TImbnITCqWtOmd+XstuAPKR34qrWn8TY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CNMpqjXmUndgAmE2At7EpxZRSzQReHzwLB6VnqhOD38pZON4xB/2B/lDCWTabF7aBSL2heeTMX/HiMbV7ssgyQnAXAZkb7wH4T7uXg+WkQrZx6aIpnTjAS36fo64AZmUiMwwuDwlrsD0WV7VK+WQmaliJHlGRQq5um5wQ1qcbOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMpyWD24; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMpyWD24"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ac25d2b2354so1035977466b.1;
        Tue, 08 Apr 2025 07:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122448; x=1744727248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VUm9gQnvGQXKP6784F7H7/avPA/P9IgZ4HfULi58AjM=;
        b=iMpyWD24S5N9aMem0Bebrwtr+9aV/m7L298awG8YL98L3hUVlwbBdcvGKYMZrxdmaf
         ItJAO5dpWAPhdkzVElO2k6KDZQgooUHGeWgNHaHO0OmU5x0YHJH/eYoTt0y3S8z/fHNh
         rnMYTNXfC5bfSyJuXLgUsjNLBOWzWC7f8wuMirtx9bzR9wC9cSdKPf6Dg9b1816WR35N
         rKRsA/VSM/43t9hn6Z1FMNteLmchKpL76QFf4XXdM3JUy5vwDMlpBQnflyCuA5zQjRGG
         XNGNbbqLT/RjV+xkQnCZdCFA/4Qqoxc8i/XUSHmiQQtWhFH1P97FMFNdPEsfBl5o/uPz
         +yCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122448; x=1744727248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VUm9gQnvGQXKP6784F7H7/avPA/P9IgZ4HfULi58AjM=;
        b=jLyZ8/y7b6dByVb9ZlohlBPqDJakVtA0LsUtYGhRHzeLvpUz5lDyVNgOy+CNPWIerf
         yS7iT6pKCkIW60cdoRiq8W4Uk05gxAua2oYMPslXQFcGbdZkEXO0QWi5mBqa3RF91rkP
         elRcKuYfoF+p7uwq8aFSIWSqzs0T/cCz0Hi9JTQq0LWlPhWiGfnW/Qa2AR3XYT2LffWh
         CuaY8uDNGwCm/8LyVfbjqGeNcSL6xjV+4yGO4jL5VIkB/j4Srue6+nkTvqG0c2vT+ioC
         qMZSv/BWKgYXX0+KR9qLfUquq/xU+8GuL0KEZMalawf9oZNCuIo7+4scQMu50Q6gKv9f
         fTqw==
X-Forwarded-Encrypted: i=1; AJvYcCVDP/M1tLbPc962X0N2/vdGF9Sx4mxcraIcNt1aor2ek1aXxpiuuLVrLc/FyexP//R231cm4aUCndeUp4Em83Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVUwpx+Y4ShQZpknwCm8taGeyabNUOLD1wXKXE0mOJ3xxjsMc4
	C9RvP4ekgEJRYfuCVW4qLIVix0+9N1GMnmocRsAMSrBR8/9Nrcgo
X-Gm-Gg: ASbGnctLi07Jrz9QbAZGVNNGHR23xcEdvWtdSoWM/lXkJiWCoSNvoXIf9Zmsm40QtOE
	DtX4nWA8jUNdzcGmnqRNQJyBc0bi7upkFWKg06iRsH03U3aJUvXAVrdJJ58QhCVBV+UCCG/1M2A
	AWK8OuiFFT0c2vKninyYfY4KMO/GC8FP/KakRAJ/DFxDFwN7hihIDrGJ2MUv5ilq4LHM253RbtE
	anERyWQot8cBQpcA9uvcYWIjYpXDoCjFucWK3ja5utMfdWlrglrQcwAylPNzU3Y7lGJNsuy19cr
	uc2xrzX5xMcAt4uUfWin42woHHewPWRvi8n8wLaNe4TV93okLduaBZX4bfJfmLTz9RotSgz5Uzv
	Nl1lGWyoHwDGTvqA5DG8NsBJS1prkGqvdrvKPmkTZy5OKvIIneKHhxhV7H65kChE=
X-Google-Smtp-Source: AGHT+IEp5c94V6eqD35x0nSO2wKRP1MNbXvTRnXfeguOXryVg+FDsmDVzBaz9Z5e3HCToWicMtFIDA==
X-Received: by 2002:a17:906:7310:b0:ac7:1350:e878 with SMTP id a640c23a62f3a-ac7d6e05c0bmr1509858666b.46.1744122448151;
        Tue, 08 Apr 2025 07:27:28 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfe9be67sm910393266b.46.2025.04.08.07.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:27:27 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 0/3] netfilter: fastpath fixes
Date: Tue,  8 Apr 2025 16:27:13 +0200
Message-ID: <20250408142716.95855-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several fixes for the existing software forward-fastpath code, also
needed for the software bridge-fastpath.

DEV_PATH_BR_VLAN_UNTAG_HW should not be applied to dsa foreign ports.

Also DEV_PATH_MTK_WDMA needs to be introduced to nft_dev_path_info().

Introduce DEV_PATH_BR_VLAN_KEEP_HW.

Changes in v11, results of testing with bridge_fastpath.sh:
- Dropped "No ingress_vlan forward info for dsa user port" patch.
- Added Introduce DEV_PATH_BR_VLAN_KEEP_HW, which changed from
   applying only in the bridge-fastpath to all fastpaths. Added
   a better explanation to the description.

v10 split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (3):
  netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to
    nft_dev_path_info()
  bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
  bridge: Introduce DEV_PATH_BR_VLAN_KEEP_HW

 include/linux/netdevice.h        |  1 +
 include/net/switchdev.h          |  1 +
 net/bridge/br_device.c           |  1 +
 net/bridge/br_private.h          | 10 ++++++++++
 net/bridge/br_switchdev.c        | 15 +++++++++++++++
 net/bridge/br_vlan.c             | 23 ++++++++++++++++-------
 net/netfilter/nft_flow_offload.c |  8 ++++++++
 net/switchdev/switchdev.c        |  2 +-
 8 files changed, 53 insertions(+), 8 deletions(-)

-- 
2.47.1

