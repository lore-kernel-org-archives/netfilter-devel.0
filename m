Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8FE131E49;
	Sat, 15 Mar 2025 20:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068923; cv=none; b=FmgyiUjH+9YWVH7Hy4y7DJLfzWa0TGxK1me4aB9QSQ1fKef35v6GVuYEu2F8GW4m31E18zAqJ6PK/xiJxMHdVjsji5v4MylZgKHXPV0c29E3tnwYEzYy+Y+kCPbbmRVUdiq+Kv4Ck1ADcTnd2z9cYdEwn885CwFKH7hgyRnvgms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068923; c=relaxed/simple;
	bh=Z23rRndO03NcWjeUO2Bb+pclUVmTWvGLV3Gq+hK4HsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tNLoIWvyESgtQtAWWiAL6hJr9GPjuo0Ux5RBZ173wKvId9AWDl+fNlWTiil7Cah0VYWTAdxD8tBvGepfgeOavKkXtyCIClWDQP0nEQoJPmrccK9kkFE3nO21+mrhtG5CL/LSsnJON6ut7YJwN/EWAm0bnDzXP9lfIKjPWORzJFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B5bw3bVu; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B5bw3bVu"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so68903166b.3;
        Sat, 15 Mar 2025 13:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068920; x=1742673720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OWCNG8MCvnV9bUc6X1qyMGw14Enxyxd+fZVYaRBs7C0=;
        b=B5bw3bVuvrsOSEhHoxX6lsB1aPyYkD/6M2oGr2imhZIhOstI7C3zV8z+/prxNB+MdR
         3fobvDC51Hld/5UUVCQzppxKHqFVbe+yfMx0Y2E+HjbkkZJjeT0bjzv8vme4QeutA9JQ
         PLfguOxwUIcA1MvGitKe41ExjRp5K+YhXfK9XcdyzTDofsa1XFPqhuqrbmusVBttUBOW
         6D/0G1JLcuimm+LZgpSrTCT8cDlcU527HA3CuuzOlabDzR/9iozRpJvBnkJPndivV8Z5
         p3SufJuysJc0DaaU60v79G0OHtR8Y6WkfyeKyEx1PDux+f0TLbtgZ5L41GDL5gZxGzb0
         pSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068920; x=1742673720;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OWCNG8MCvnV9bUc6X1qyMGw14Enxyxd+fZVYaRBs7C0=;
        b=DOaXYP9/hvBWT9wQJwa3G1wCzEzz8iCU9MgddrNxPF5pDC+yySI3FWPYaB/xqKF3og
         7NFJG4PRLCuhMLQjiSoDtwoeCllfopBBpAIwcQxzvs/6mvtxE+BtmOJtFCGixtmpsVql
         MEpFrLDYZ0pGv7rJL8P4qlB9iXInSUm4kT35evpRkbUx/4XRuZdviUcwjFRt8ay+Bo1b
         F4Bbn1Oqi47xQFQ0RzhjR8N7WmVOClREBiNKKbHvGASiK0s80pfHxiYijYukVNG3WEZr
         hlhcB4TLRAjtH607taHequ/k/2Uvq87L8HOHEkqs4oSier9GAwV8ka+eEVEiOIidKi+o
         WGHA==
X-Forwarded-Encrypted: i=1; AJvYcCUyGv/4m20mU9BeyWSSfe3rg5ZGT1PxnGnX4wGFg3Y+mALhW7kPnuFr2KI3nyi7C0Kxp8j4jwy3e4aQY0g82w8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpaglO28Ch0bA+L147V3kboSzuRsTwBO0jdwqNmki9NQKPLgKA
	Pfptxm2MXagchDmGF9uP2WoD2TfydvCG6QgcA5VN+2Vb8U7BnmEoyu5+Ww==
X-Gm-Gg: ASbGncu4B9QbYzSJ1WFtxnKTF51k3KMX7aYWCoJvccQmJU7z/CDCEedKuJ4/4LOkICp
	2/1pBT50gCogWYZqyzBkG7r1grO2BIMpMjcFLz8UUOMel42BRNqt3CnbShoSbOA7iiPZWpUSCEk
	7TuES8jccW+R8pxRJNPOhnHh613LyYnzq8mcZ3x7E9iUFRxUhs7P1WAmkyIe5Eja5o4QGgWcvb6
	uI7YDwcpB/6+Ytp9hLs+2pmOfNgcbXgw1S6M6jHV+socHbBem8QdGI55owYT6b/HGsegu+hBld7
	IzVEwxrLBeWyd0li7VG/sdPHpSOCL1MTfLxdtEm0fKtfBA+J/D2nryoeRqbof/e2v3EouT/97iy
	PVQNhi4NnEcJYVA5ne5BvxycZrGn5OmNLRCCBZhIOdKhUF3EXL7DZ3dW+1YmxPLsa7VrkUAMq5g
	==
X-Google-Smtp-Source: AGHT+IF8gayXt91PRDutGk4V82DqfdZfU+ap3enKi/TuuDYAbCXOzpfh+hBjypvjScaqAOLFckwunQ==
X-Received: by 2002:a17:907:928c:b0:ac2:9a71:25ab with SMTP id a640c23a62f3a-ac33025412amr958629566b.16.1742068920017;
        Sat, 15 Mar 2025 13:02:00 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a489c9sm411456766b.152.2025.03.15.13.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:01:59 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v10 nf-next 0/3] netfilter: fastpath fixes
Date: Sat, 15 Mar 2025 21:01:44 +0100
Message-ID: <20250315200147.18016-1-ericwouds@gmail.com>
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

DEV_PATH_BR_VLAN_UNTAG_HW should not be applied to dsa user-ports and
not to dsa foreign ports. Furthermore DEV_PATH_MTK_WDMA needs to be
introduced to nft_dev_path_info().

Split from patch-set: bridge-fastpath and related improvements v9

Eric Woudstra (3):
  netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to
    nft_dev_path_info()
  netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user
    port
  bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign

 include/net/switchdev.h          |  1 +
 net/bridge/br_private.h          | 10 ++++++++++
 net/bridge/br_switchdev.c        | 15 +++++++++++++++
 net/bridge/br_vlan.c             |  7 ++++++-
 net/netfilter/nft_flow_offload.c | 10 ++++++++++
 net/switchdev/switchdev.c        |  2 +-
 6 files changed, 43 insertions(+), 2 deletions(-)

-- 
2.47.1

