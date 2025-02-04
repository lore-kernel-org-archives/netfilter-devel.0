Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DE7219A8F;
	Tue,  4 Feb 2025 19:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698672; cv=none; b=Do8iy0yjulfrIZQdDebAcrkM8seh+RdhT/V8o/VgrpXfBcG5yBMGiAjDbBU4b7cqTJ6lRiXoY3beV8qBEo4GtgctWlR5waDnTtKODqwJ/jMFmyJEhT2OMob9hBXXTeYhGMQl1Cl4mmXFH6LTotBc6G3bAcl2H9QPATxBSQqiT70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698672; c=relaxed/simple;
	bh=IIkygejv8o1VEEOv0U4aJpEYwdsKoRowOAaClBAnKbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LlhVYBoV43TYs55h6i704PhUIVDn7b7BwWHzPVuhShb6viM3d66kOwHQPkADSLPtZVW6sWyZNq7S4ynF0fSilDmt6djkRldYy6lY/7Chd5EGcufNmwTzNi5xWk/1iItDgewzGtp3MqQmfnNDNZV93KE57ivIvivspUZZvpuP6fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCibuPLY; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCibuPLY"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso279878a12.0;
        Tue, 04 Feb 2025 11:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698669; x=1739303469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lm/8cNmFPwaAsP/EOFcLh7PHJxrshjVHa1Fi7jhwkbE=;
        b=DCibuPLYhE189WzXeVIjH2kbQPTFs/bMkJRxtABQsxcrrjLELC1+qzCma1xHu/kW0v
         FLR4ODXzG9dESyCW7ZBrz2XLcv/0tj0vTBp6rl4sS9bLAEWqV2B2Vh5kFNJi77OgtQC4
         gWX9gPn/oZ050K0DzFm6AXB0oaP+US/ZmFzkMO3GodDqHVk+tReufTsWoxUXFEi+tTQl
         ef5OHIC3+NlcGWKELnX8FS19nd8/zSWrxkzVAZ/APN77wwRK5HDwaL4KzJLMC+Zj413x
         nrhbdz8gBl1PwBzd5/abXlOK9iefvxFlqeJLDSiBq9c/LlfdlYZYoQji3PKB03LlNT06
         HSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698669; x=1739303469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lm/8cNmFPwaAsP/EOFcLh7PHJxrshjVHa1Fi7jhwkbE=;
        b=HLeaapKfyN4Bc9qxHJ/lV0AfrwbVZ7XFNekgeR1AHkichW6EacbUjONSMfC1HB2Iqv
         0a5+aESBJzW6aSXgvHmz320yRlyA5l/vhVJhGhsfUMbsL7EBSg8Xkk+RoAF+HTMdMklH
         N568VIMEF7kMWbfp2R6/8zjt/5dtLmWWZmt82biULmZEpOKI+PM3drWf64TnsD2zNKTG
         Z6RsfLuJcP+oYkS7ijg5KVxjVFN1nGkLjfqb6W3A32bEsB++SkWjj4T7aeIuGEuqsrfA
         9vA1fVtsGvWwxDCpNOPAbt+vFkmBKClKlsY/0W3uQmuWTt7XgwkX+tn4BbLfB/rbuEcr
         UsfA==
X-Forwarded-Encrypted: i=1; AJvYcCXU+oI0AaVH7+57mH9j7CFP+fnsoDt2f0SPeNZuPS69RVeUjWFbRITJNRUlBhU9/Z//lDkHyYtG@vger.kernel.org, AJvYcCXb2mNEhLCx7SZO8vKk8deS1Mlf41oItvkRqUytsCZNX2Oy5gIH5jn+xEIireBU/s9pPrujhiKL6oq8FhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOrJPHXnW1B3LbRnDMZVLWRc9wPhPdnaufJFe4vQg+hwJQbw7N
	mRebZmP+ZpbFb3ssFI04QQl7KYIFYzuqAVAV2l1pTifL2UPJlzj7
X-Gm-Gg: ASbGncuGhG5ijs82K0LT81nRl6ViSTrzIdUYibabRGSynsZR6CUZ3iHPFohx791GCbH
	/mHVc23pzbx9VsHlM/YslXSXZjAvP2G+R9n/4zndFCyorA3kgqmWxGjcJQM/WmydVPHKQxOG2H7
	dF6YDYeXC1FH9+1tQENHQAggDqrsGm2zIry/fC/0udS/HYS9KO9QVqdpwELQXZuGoPK1L+suPCE
	8RaQIbE4G5jDXskshhwiWc+THXvOoEkf8hGSe1cNGrPY1+JfxeF9rF3tU1TXCQYpDnDjLhNW72T
	Q32K92l/STuWANIJg7CAvuQJrGV+2hc2oFIcmi2aI/E5WmlcMTSvfC1Au3JsiQWQUMspinNT3q7
	sLcykBdet/qSQdJxWG7D70R5kOwoQ7AWJ
X-Google-Smtp-Source: AGHT+IGtJLT1Gfat47VQW9jxAieSXNW5v+/XNxFf+87Kq2AKKUyg+QjIZxFw4TmACP3MZXethPM2wg==
X-Received: by 2002:a17:907:7b8c:b0:ab6:cdc2:3417 with SMTP id a640c23a62f3a-ab748435262mr486068466b.15.1738698669216;
        Tue, 04 Feb 2025 11:51:09 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc724d9de2sm10074894a12.81.2025.02.04.11.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:51:08 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [RFC PATCH v1 net-next 0/3] flow offload teardown when layer 2 roaming
Date: Tue,  4 Feb 2025 20:50:27 +0100
Message-ID: <20250204195030.46765-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
used to create the tuple. In case of roaming at layer 2 level, for example
802.11r, the destination device is changed in the fdb. The destination
device of a direct transmitting tuple is no longer valid and traffic is
send to the wrong destination. Also the hardware offloaded fastpath is not
valid anymore.

This flowentry needs to be torn down asap. Also make sure that the flow
entry is not being used, when marked for teardown.

This patch-set depends on patch-set: "PATCH v5 bridge-fastpath and related
improvements" only for applying the patch correctly, but it is not a
functional requirement.

Eric Woudstra (3):
  netfilter: flow: Add bridge_vid member
  netfilter: nf_flow_table_core: teardown direct xmit when destination
    changed
  netfilter: nf_flow_table_ip: don't follow fastpath when marked
    teardown

 include/net/netfilter/nf_flow_table.h |  2 +
 net/netfilter/nf_flow_table_core.c    | 66 +++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      |  6 +++
 net/netfilter/nft_flow_offload.c      |  4 ++
 4 files changed, 78 insertions(+)

-- 
2.47.1

