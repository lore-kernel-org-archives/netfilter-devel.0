Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA69741D626
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 23:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791241698; cv=none; b=kfb2tIT3yGlnshSdnDW4+oLb12RCm2y9ZvKYkirjZ4u9n7NFg2gVRmk7C6kNCDyiKFfAYpRT1ldFTYNO06S1fRjKic3PwdofPBvuCWrnGMXg3YwN1Yu9xDCjiKrrtTdVMDuSIdG7CcHX82ShZjay4AGx0Ws9NU3Ede1s3gUGOIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791241698; c=relaxed/simple;
	bh=EFiOMCmz0kquomDbFRaCIqOKHR+0cTGiBsZKDB9gpQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FjeTJrRLviQSmW/FQRh6Q69TBg7+nUNAkJFkJsxsQdtF+kEKehT/b9jkSRUJ3xqJZ2u7/HIdcH61zhuhdKETYGcJJhvjRr05XteIzTeB5sjF8tf/4pEBy4NGtChRT6p+WdLzl8G+rXrf3Yy/s4L1vLJfCJOy0UenNU+tQ/hQZ/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TurXa2zb; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TurXa2zb"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-34c4a0868b6so1721238eec.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 16:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791241695; x=1791846495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xKfOMaGlV1wrIDpVywRMIIFaPysOcSIKEiVc//uuW0g=;
        b=TurXa2zbcMUh3JJhn8RbJntk8sA+0TGOpVzl376z/r0XNGXiG4l4YU8rEMlG1IXneC
         mO5fXmAWnKOXczZpQqrZo51rlzLQyXXcjjLN4Ey4tKgDVd9n5a3FK43CNhkTsUXuFpkN
         6G4v/xqkbxZq+w9jLHvxp35Z3+MmZnGAPiXLlUFU3Fj3YrCiKnMyEV96rVWpmCltTuQS
         w+agJ3CWrMI74QJ1JQcg7amGPDhF8whzMxElne9cWM8aAXyQDc9sJntWCOyslNhAUf+V
         l0jtyQkxKH+SK7wX3uKejlC/L8CSGm5yVRfGOY181w4hRGdCpOjyIIW/KxhusdLFUh43
         dx/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791241695; x=1791846495;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xKfOMaGlV1wrIDpVywRMIIFaPysOcSIKEiVc//uuW0g=;
        b=a6MpS8vY5mtdm7sSdxp3jC5nwphfCN/rJ5m1NDTkGi9uNjRZZjxTMr76lbayJWB1R3
         vcSPkaeWEq6O+xaEAfvdge0Pv8y2GizQ6ABjTcQIduNCHziQzVtqrRaQ+T/cdANwHtN3
         +laxYSdm7uFhXIPwhMBjOF77fuwYfc8OzC7myE8Ze7SGlK0VF7pSVl/aFj9BrGbdbrYn
         z5byOP2qkLZyQUSoallM6x80JrYiXWNRVGYwtmlj8LQ3ohMFhT/qd6QD503Ze2sO+FHx
         48m6XCRF08+OE9CKQtPzxbWGBk3251z54n0obevrpjdX+BsK7PN8mNoplrdjRJKGpvP8
         Xr4g==
X-Forwarded-Encrypted: i=1; AKwUvBxGBvFMk1tlbocEKT1skesNNfMHuHg2wIVYsg1VNf+/vlJckB9B3aVJSjVzFhxqXaKJfbeujmbjUQ5RcodxB0s=@vger.kernel.org
X-Gm-Message-State: AFuF++mrjuZlRdblvKIEVSflcPCk6uVtCO6byoL08G6Xv01evr3vvikV
	KoTw2Dr6rpHdSoURPRvUH8MWcl6BsqiuuQ0vnqINuk9+S0C5W9OeK1yz
X-Gm-Gg: AYBFou07zbjn8YIV3T/xdLFBHrZ7pSCusZWDRD4h4dIEq7Z9piiatbGQrLgPvb9GhBJ
	+4cIlX8WKlAdtDVrnZpfZyP55ZWJDco/CMRDoEBWuiXKQ2CD5p8vty5oKD7DI6C9Zwbi1IR0bZK
	aG1h+PihkU05/fRvnal09z4tDO6et22wpx5vzb40mU9L/WABsbv9Lc0CJCBIA6yHE0bdu8YNZbe
	HfHEDtHkkQSvrQx2CxcE0PJBP6x0hdw4CCZGCUuUYJWNytABHFl5tta+ELHRFlq5nh4KVZwjFBu
	r1syz0uJnjPymybvD7tC/nF1AnrT/T/OLlwXIex9MwNnymb1r59Xq6lhc/tJvdscccKQIEufutX
	sFnlxBfLXU2gdmiLmCF4nKEkEKd6UblXxOhJ3855ZFS/UPN5lmHTEbaDzR0k669LKCpz6Wu1jBZ
	CvyiR825rvf9KdbY00Ng/+/yG1KHrQppAkNQLTM2q7SYTw72BJCV0ZTbBURWvT560=
X-Received: by 2002:a05:693c:20d4:10b0:33e:61ab:8309 with SMTP id 5a478bee46e88-351452fb0dcmr1105737eec.23.1791241694720;
        Mon, 05 Oct 2026 16:08:14 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35146a5b004sm1859493eec.18.2026.10.05.16.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 16:08:14 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 nf-next 0/3] ipvs: add per-service secure_tcp
Date: Mon,  5 Oct 2026 20:08:05 -0300
Message-ID: <20261005230808.148478-1-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IPVS currently exposes secure_tcp as a per-netns sysctl. It switches the
TCP state machine to the hardened tcp_states_dos table.

These patches make it per-service: a virtual service can set
IP_VS_SVC_F_SECURE_TCP which is passed into IP_VS_CONN_F_SECURE_TCP at
connection creation. set_tcp_state() then selects tcp_states_dos for those
connections with IP_VS_CONN_F_SECURE_TCP set and keeps pd->tcp_state_table
(the netns default, including the nomem floor) otherwise.

  1. uapi: define the per-service secure_tcp flags and stamp the flag in
     ip_vs_bind_dest() (cache-bypass has no dest)
  2. honor it in the TCP state machine, resolving the stale FIXME, and
     document the new default/opt-in split
  3. kselftest contrasting a secure vs. a plain service

Changes in v2:
- Let IP_VS_SVC_F_SECURE_TCP be 0x0100, leaving 0x0040/0x0080 for the
  scheduler flags. Let IP_VS_CONN_F_SECURE_TCP be (1 << 17) and no longer
  in IP_VS_CONN_F_BACKUP_MASK.
- Set flag in ip_vs_bind_dest() instead of at every ip_vs_conn_new()
  call site.
- selftest: send probes with TTL=1 instead of an nft drop, and fix
  Sashiko comments.

Changes in v3:
- Merge patch 1/4 and 2/4
- Re-send patches (v2 dropped patches 3/4 and 4/4)

Changes in v4:
- selftest: check the return values of setsockopt(IP_HDRINCL), sendto()
  and mnl_socket_bind(), and fail do_add() when IPVS does not reply.
- selftest: fix the remaining Sashiko comments: check inet_pton(),
  initialize fam and the parsed addresses, and verify the flags attribute
  length before copying it.

Changes in v5:
- Document secure_tcp as the netns-wide default and the new per-service
  IP_VS_SVC_F_SECURE_TCP opt-in.
- selftest: reword the changelog to "a bare SYN followed by a bare ACK".
- selftest: skip when the ip_vs or ip_vs_rr module is unavailable.
- selftest: check the probe exit status so that a probe which dies after
  the SYN cannot leave the secure-side SYN_RECV assertion passing.

Changes in v6:
- Rebase onto nf-next.

Adriano Cordova (3):
  ipvs: add flags for per-service secure TCP state table
  ipvs: tcp: enable per-connection secure_tcp in state machine
  selftests: netfilter: ipvs: add per-service secure_tcp test

 Documentation/networking/ipvs-sysctl.rst      |   4 +
 include/uapi/linux/ip_vs.h                    |   2 +
 net/netfilter/ipvs/ip_vs_conn.c               |   4 +
 net/netfilter/ipvs/ip_vs_core.c               |   3 +
 net/netfilter/ipvs/ip_vs_proto_tcp.c          |  16 +-
 .../testing/selftests/net/netfilter/Makefile  |   6 +
 .../selftests/net/netfilter/gen_tcp_probe.c   | 158 ++++++++
 .../net/netfilter/ipvs_secure_tcp.sh          | 169 +++++++++
 .../net/netfilter/ipvs_secure_tcp_mln.c       | 337 ++++++++++++++++++
 9 files changed, 692 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/net/netfilter/gen_tcp_probe.c
 create mode 100755 tools/testing/selftests/net/netfilter/ipvs_secure_tcp.sh
 create mode 100644 tools/testing/selftests/net/netfilter/ipvs_secure_tcp_mln.c


base-commit: 8b4e7209c842d8cb9516f1f5ef0a88aa2d8831a6
-- 
2.51.0

