Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com [209.85.219.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6924E13957E
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Oct 2025 02:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977703; cv=none; b=DoUBsnD7NZnt6ukx1O/Mlx8lAGlvMWhViOgz7Qo0L93yJhg/S6PQ9dZi+XZOBWvRm7MWGLoRRVx9a8s4XSW2iM8nMaJo40w4k33YQYePAl5JQSjUqoH3CTO4S2LZodDsIa4zN2G/gg7adZs4YbRyKmTePZblBqeP4Zo9300DXfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977703; c=relaxed/simple;
	bh=n/QAEX+RVcojS4iyZ3Gx1rPZh2zj/LAFMnxqRZRd0C0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KbEl4x/dN9k/qoqp4hYAl24PmDH1zmd+/hvMGaIHuLO22hjBYZcu3TDZ8+a2+/C/ioDXxRL+MZhqROlHIOlb8FQsbxulXtiUbdKoiJAeweJW0sgMPDnqKmfqw74IHvyBRhWnVtrY+8VQv8fDnVekAa427M6i2SzpzpF/KO1QHOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=juliahub.com; spf=pass smtp.mailfrom=juliahub.com; dkim=pass (2048-bit key) header.d=juliahub.com header.i=@juliahub.com header.b=WLmERSdO; arc=none smtp.client-ip=209.85.219.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=juliahub.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=juliahub.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=juliahub.com header.i=@juliahub.com header.b="WLmERSdO"
Received: by mail-qv1-f68.google.com with SMTP id 6a1803df08f44-7e3148a8928so4776186d6.2
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2025 19:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=juliahub.com; s=google; t=1759977698; x=1760582498; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N7tR+toSHwUt07QOSIZ2FP6lybixD2Bpofk3CuOTiMU=;
        b=WLmERSdO3WCNE+9fuMszwST0hIZAowm+Om6KiW1pA3c0Qop9gtzU+a2CfrhXt/ueiJ
         Bj0VXVH3g2d2y8f4rLOIfkc6egxDmZY1xx8IA42iPoie4l32PPK4ee3EY51ziZ7Ha+vF
         qFhK+L7yHBMdKpYIhsz5tkPC8mJPpJpTflfhOQ06mJrM187a9T63Xnul8aJOC3GeQnI5
         7wAPwbQGqve4ZkQObohagUp3riK9oHp+6PUCSLHoRC/NWn2CMimghAff2Xcl2ol1sDfL
         wbzHRA3nsAYRk7vlDhPKvKgqQSxEVFKYo9ITyt9DQEZzGT0OSHDfXoUMnOjn2aO0cQVd
         mz4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759977698; x=1760582498;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N7tR+toSHwUt07QOSIZ2FP6lybixD2Bpofk3CuOTiMU=;
        b=XI8qe8fp8YlJV6ehGiym9nFk/unLBEe2nvAM+dC5w5nKDUWAVMNfSgQpTL2PcGSgkY
         +iUFaJ87/swmN2cRQ/P2MnNfNXClxS0pvLi5VDuWS+/eguRyobMOUacx9TgFbJO5egg/
         sjLSNOtdR/PUdeGz8+ckKLkk1nBRe0NXv8CIIVQyrYSovvC1xXOmqLYPaoRQPT6EKDQb
         RxY785jiacWan/Bh3CoC3SRMZQykcP8mFpzKONu235hHBcNW8QpU0FZxSeUv+XV9Zlx6
         ua7T+pp4kME7xWu2kOFZ1YbS55+Bb4Y81PrtIPzY3T88T0xeQR34FNY2PxnFkfeIj1ww
         8vpA==
X-Forwarded-Encrypted: i=1; AJvYcCVURMIQ/c4uTmpzC6IIxXKoJfBKo9x6B9rN+347uocqP5yqhUFe9NpeiP+Yn2dD+EovS9R4AOLN9pG7OyQGrPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyzibkf69Om9wmXlmkczKKBhaDhCs/2lc8ydcZy9LnxQkbIRYgU
	e7AcSzqOZ7Orh5jir9DSYKo0vFLhj8I8q8xpdck90keS4Uhep5heTttTerY8up9kWlpm3S/I2zv
	1rFwl7RWMxjiA
X-Gm-Gg: ASbGnctkSxAIgZF2FJMlIHEPQQDB+O+cfZi9vEMJAlQZ4a8F6wXwKUUkiBppsyVjj+c
	z+hY1P0bSS1smxjeKHqwYpqzchreUcRaiCFfw89RCY9uCWBZbpW0Yzu55O7p7INyCPQVUZtJHap
	qEjge7dZLBJXPjScq4GFgwUlb2MclVRpWNkAIkT7U8M9nzud8IcM8Zzx2x2D3FCUwQYkuIiyoHl
	gkwTr1qYXLd5HwA3gWdK/zy3WhT7qPfVArIuerkg55xEs7j8BCYfGlTf3YnrGOwF3Pj1As3waDU
	QZs0JD9UIlqqlPH9osYTCMZIUP31qWiFY9UlThl6/Ouf1ULikGEIJeCEcbt9f+mWmbCMqo7kB6C
	7GVjuIUosKmuLsJhT6VHpzPhKDwkAjkU3vHmKEFtPhoA=
X-Google-Smtp-Source: AGHT+IEs4Sm6eWIqMpeBCMVI4gXok5K/FmTM62JfeYxsanShYV0LfzIssaZQ4feRDTmrotty5hPV0g==
X-Received: by 2002:ad4:5f45:0:b0:82d:f77f:28c3 with SMTP id 6a1803df08f44-87b21092a00mr89624106d6.30.1759977697950;
        Wed, 08 Oct 2025 19:41:37 -0700 (PDT)
Received: from juliahub.com ([66.31.114.203])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bdf5383fsm174055736d6.56.2025.10.08.19.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 19:41:36 -0700 (PDT)
Date: Wed, 8 Oct 2025 22:41:35 -0400
From: Keno Fischer <keno@juliahub.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Phil Sutter <phil@nwl.cc>
Subject: [PATCH] netfilter: Consistently use NFPROTO_, not AF_
Message-ID: <aOcfvmjCTVkUxMYX@juliacomputing.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The uapi headers document `nfgen_family` as `AF_*`. However,
this hasn't been technically true since 7e9c6eeb, which switched
the interpretation of this field to `NFPROTO_*`.
This is value-compatible on AF_INET (though note that this is
NFPROTO_IPV4, *not* NFPROTO_INET), AF_INET6, AF_IPV6 and AF_DECnet,
and AF_BRIDGE, but has since grown additional values.
Now, because of the value compatibility between AF_ and
NFPROTO_, it doesn't matter too much, but to the extent that
the uapi headers constitute interface documentation, it can be
misleading. For example, some userspace tooling, such as wireshark
will print AF_UNIX for netlink packets that have an NFPROTO_INET
family set. I will submit a patch for this downstream, but I wanted
to cleanup the kernel side also. To that end, change the comment in
the UAPI header and audit uses of AF_* in the netfilter code and
switch them to NFPROTO_ unless calling non-netfilter APIs.

Signed-off-by: Keno Fischer <keno@juliahub.com>
---
 include/uapi/linux/netfilter/nfnetlink.h      |  2 +-
 net/netfilter/nf_conntrack_amanda.c           |  4 ++--
 net/netfilter/nf_conntrack_bpf.c              |  4 ++--
 net/netfilter/nf_conntrack_expect.c           |  2 +-
 net/netfilter/nf_conntrack_ftp.c              |  4 ++--
 net/netfilter/nf_conntrack_h323_main.c        | 22 +++++++++----------
 net/netfilter/nf_conntrack_irc.c              |  2 +-
 net/netfilter/nf_conntrack_netlink.c          |  8 +++----
 net/netfilter/nf_conntrack_pptp.c             |  2 +-
 net/netfilter/nf_conntrack_proto.c            |  4 ++--
 net/netfilter/nf_conntrack_proto_icmp.c       |  4 ++--
 net/netfilter/nf_conntrack_sane.c             |  4 ++--
 net/netfilter/nf_conntrack_sip.c              | 16 +++++++-------
 net/netfilter/nf_conntrack_standalone.c       |  4 ++--
 net/netfilter/nf_conntrack_tftp.c             |  4 ++--
 net/netfilter/nf_flow_table_bpf.c             |  4 ++--
 net/netfilter/nf_flow_table_inet.c            |  6 ++---
 net/netfilter/nf_flow_table_ip.c              |  4 ++--
 net/netfilter/nf_flow_table_offload.c         |  4 ++--
 net/netfilter/nf_log_syslog.c                 | 10 ++++-----
 net/netfilter/nf_queue.c                      |  8 +++----
 net/netfilter/nf_tables_api.c                 |  6 ++---
 net/netfilter/nfnetlink_acct.c                |  2 +-
 net/netfilter/nfnetlink_cthelper.c            |  2 +-
 net/netfilter/nfnetlink_cttimeout.c           |  4 ++--
 net/netfilter/nfnetlink_log.c                 | 10 ++++-----
 net/netfilter/nfnetlink_queue.c               |  4 ++--
 net/netfilter/nft_chain_nat.c                 |  6 ++---
 net/netfilter/nft_compat.c                    | 12 +++++-----
 net/netfilter/nft_nat.c                       |  4 ++--
 net/netfilter/utils.c                         | 12 +++++-----
 net/netfilter/xt_HMARK.c                      |  4 ++--
 net/netfilter/xt_cluster.c                    |  4 ++--
 .../net/netfilter/conntrack_dump_flush.c      |  8 +++----
 .../selftests/net/netfilter/nf_queue.c        |  6 ++---
 35 files changed, 103 insertions(+), 103 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink.h b/include/uapi/linux/netfilter/nfnetlink.h
index 6cd58cd2a6f0..9d7fe3daf327 100644
--- a/include/uapi/linux/netfilter/nfnetlink.h
+++ b/include/uapi/linux/netfilter/nfnetlink.h
@@ -32,7 +32,7 @@ enum nfnetlink_groups {
 /* General form of address family dependent message.
  */
 struct nfgenmsg {
-	__u8  nfgen_family;		/* AF_xxx */
+	__u8  nfgen_family;		/* NFPROTO_xxx */
 	__u8  version;		/* nfnetlink version */
 	__be16    res_id;		/* resource id */
 };
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7be4c35e4795..4f81ec207641 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -180,7 +180,7 @@ static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 		.name			= HELPER_NAME,
 		.me			= THIS_MODULE,
 		.help			= amanda_help,
-		.tuple.src.l3num	= AF_INET,
+		.tuple.src.l3num	= NFPROTO_IPV4,
 		.tuple.src.u.udp.port	= cpu_to_be16(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.expect_policy		= &amanda_exp_policy,
@@ -190,7 +190,7 @@ static struct nf_conntrack_helper amanda_helper[2] __read_mostly = {
 		.name			= "amanda",
 		.me			= THIS_MODULE,
 		.help			= amanda_help,
-		.tuple.src.l3num	= AF_INET6,
+		.tuple.src.l3num	= NFPROTO_IPV6,
 		.tuple.src.u.udp.port	= cpu_to_be16(10080),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.expect_policy		= &amanda_exp_policy,
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 4a136fc3a9c0..fff573d94491 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -82,14 +82,14 @@ static int bpf_nf_ct_tuple_parse(struct bpf_sock_tuple *bpf_tuple,
 
 	switch (tuple_len) {
 	case sizeof(bpf_tuple->ipv4):
-		tuple->src.l3num = AF_INET;
+		tuple->src.l3num = NFPROTO_IPV4;
 		src->ip = bpf_tuple->ipv4.saddr;
 		sport->tcp.port = bpf_tuple->ipv4.sport;
 		dst->ip = bpf_tuple->ipv4.daddr;
 		dport->tcp.port = bpf_tuple->ipv4.dport;
 		break;
 	case sizeof(bpf_tuple->ipv6):
-		tuple->src.l3num = AF_INET6;
+		tuple->src.l3num = NFPROTO_IPV6;
 		memcpy(src->ip6, bpf_tuple->ipv6.saddr, sizeof(bpf_tuple->ipv6.saddr));
 		sport->tcp.port = bpf_tuple->ipv6.sport;
 		memcpy(dst->ip6, bpf_tuple->ipv6.daddr, sizeof(bpf_tuple->ipv6.daddr));
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index cfc2daa3fc7f..b1c3487899f0 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -317,7 +317,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *exp, unsigned int class,
 {
 	int len;
 
-	if (family == AF_INET)
+	if (family == NFPROTO_IPV4)
 		len = 4;
 	else
 		len = 16;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 617f744a2e3a..fe359b4cd690 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -581,11 +581,11 @@ static int __init nf_conntrack_ftp_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 FTP connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&ftp[2 * i], AF_INET, IPPROTO_TCP,
+		nf_ct_helper_init(&ftp[2 * i], NFPROTO_IPV4, IPPROTO_TCP,
 				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
 				  &ftp_exp_policy, 0, help,
 				  nf_ct_ftp_from_nlattr, THIS_MODULE);
-		nf_ct_helper_init(&ftp[2 * i + 1], AF_INET6, IPPROTO_TCP,
+		nf_ct_helper_init(&ftp[2 * i + 1], NFPROTO_IPV6, IPPROTO_TCP,
 				  HELPER_NAME, FTP_PORT, ports[i], ports[i],
 				  &ftp_exp_policy, 0, help,
 				  nf_ct_ftp_from_nlattr, THIS_MODULE);
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 14f73872f647..0096c2c591f1 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -180,13 +180,13 @@ static int get_h245_addr(struct nf_conn *ct, const unsigned char *data,
 
 	switch (taddr->unicastAddress.choice) {
 	case eUnicastAddress_iPAddress:
-		if (nf_ct_l3num(ct) != AF_INET)
+		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			return 0;
 		p = data + taddr->unicastAddress.iPAddress.network;
 		len = 4;
 		break;
 	case eUnicastAddress_iP6Address:
-		if (nf_ct_l3num(ct) != AF_INET6)
+		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
 			return 0;
 		p = data + taddr->unicastAddress.iP6Address.network;
 		len = 16;
@@ -579,7 +579,7 @@ static const struct nf_conntrack_expect_policy h245_exp_policy = {
 static struct nf_conntrack_helper nf_conntrack_helper_h245 __read_mostly = {
 	.name			= "H.245",
 	.me			= THIS_MODULE,
-	.tuple.src.l3num	= AF_UNSPEC,
+	.tuple.src.l3num	= NFPROTO_UNSPEC,
 	.tuple.dst.protonum	= IPPROTO_UDP,
 	.help			= h245_help,
 	.expect_policy		= &h245_exp_policy,
@@ -594,13 +594,13 @@ int get_h225_addr(struct nf_conn *ct, unsigned char *data,
 
 	switch (taddr->choice) {
 	case eTransportAddress_ipAddress:
-		if (nf_ct_l3num(ct) != AF_INET)
+		if (nf_ct_l3num(ct) != NFPROTO_IPV4)
 			return 0;
 		p = data + taddr->ipAddress.ip;
 		len = 4;
 		break;
 	case eTransportAddress_ip6Address:
-		if (nf_ct_l3num(ct) != AF_INET6)
+		if (nf_ct_l3num(ct) != NFPROTO_IPV6)
 			return 0;
 		p = data + taddr->ip6Address.ip;
 		len = 16;
@@ -678,7 +678,7 @@ static int callforward_do_filter(struct net *net,
 	int ret = 0;
 
 	switch (family) {
-	case AF_INET: {
+	case NFPROTO_IPV4: {
 		struct flowi4 fl1, fl2;
 		struct rtable *rt1, *rt2;
 
@@ -702,7 +702,7 @@ static int callforward_do_filter(struct net *net,
 		break;
 	}
 #if IS_ENABLED(CONFIG_IPV6)
-	case AF_INET6: {
+	case NFPROTO_IPV6: {
 		struct rt6_info *rt1, *rt2;
 		struct flowi6 fl1, fl2;
 
@@ -1143,7 +1143,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 	{
 		.name			= "Q.931",
 		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET,
+		.tuple.src.l3num	= NFPROTO_IPV4,
 		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,
 		.help			= q931_help,
@@ -1152,7 +1152,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 	{
 		.name			= "Q.931",
 		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET6,
+		.tuple.src.l3num	= NFPROTO_IPV6,
 		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,
 		.help			= q931_help,
@@ -1714,7 +1714,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_ras[] __read_mostly = {
 	{
 		.name			= "RAS",
 		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET,
+		.tuple.src.l3num	= NFPROTO_IPV4,
 		.tuple.src.u.udp.port	= cpu_to_be16(RAS_PORT),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.help			= ras_help,
@@ -1723,7 +1723,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_ras[] __read_mostly = {
 	{
 		.name			= "RAS",
 		.me			= THIS_MODULE,
-		.tuple.src.l3num	= AF_INET6,
+		.tuple.src.l3num	= NFPROTO_IPV6,
 		.tuple.src.u.udp.port	= cpu_to_be16(RAS_PORT),
 		.tuple.dst.protonum	= IPPROTO_UDP,
 		.help			= ras_help,
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 5703846bea3b..bfdd1572054a 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -289,7 +289,7 @@ static int __init nf_conntrack_irc_init(void)
 		ports[ports_c++] = IRC_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&irc[i], AF_INET, IPPROTO_TCP, HELPER_NAME,
+		nf_ct_helper_init(&irc[i], NFPROTO_IPV4, IPPROTO_TCP, HELPER_NAME,
 				  IRC_PORT, ports[i], i, &irc_exp_policy,
 				  0, help, NULL, THIS_MODULE);
 	}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3a04665adf99..1c683074b7e9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1638,7 +1638,7 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
 					    family, &zone);
 	else {
-		u8 u3 = info->nfmsg->version || cda[CTA_FILTER] ? family : AF_UNSPEC;
+		u8 u3 = info->nfmsg->version || cda[CTA_FILTER] ? family : NFPROTO_UNSPEC;
 
 		return ctnetlink_flush_conntrack(info->net, cda,
 						 NETLINK_CB(skb).portid,
@@ -2501,7 +2501,7 @@ ctnetlink_ct_stat_cpu_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK,
 			      IPCTNL_MSG_CT_GET_STATS_CPU);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, htons(cpu));
 	if (!nlh)
 		goto nlmsg_failure;
@@ -2581,7 +2581,7 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	struct nlmsghdr *nlh;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_GET_STATS);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, 0);
 	if (!nlh)
 		goto nlmsg_failure;
@@ -3694,7 +3694,7 @@ ctnetlink_exp_stat_fill_info(struct sk_buff *skb, u32 portid, u32 seq, int cpu,
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK,
 			      IPCTNL_MSG_EXP_GET_STATS_CPU);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, htons(cpu));
 	if (!nlh)
 		goto nlmsg_failure;
diff --git a/net/netfilter/nf_conntrack_pptp.c b/net/netfilter/nf_conntrack_pptp.c
index 4c679638df06..eda7dec4cfa5 100644
--- a/net/netfilter/nf_conntrack_pptp.c
+++ b/net/netfilter/nf_conntrack_pptp.c
@@ -589,7 +589,7 @@ static const struct nf_conntrack_expect_policy pptp_exp_policy = {
 static struct nf_conntrack_helper pptp __read_mostly = {
 	.name			= "pptp",
 	.me			= THIS_MODULE,
-	.tuple.src.l3num	= AF_INET,
+	.tuple.src.l3num	= NFPROTO_IPV4,
 	.tuple.src.u.tcp.port	= cpu_to_be16(PPTP_CONTROL_PORT),
 	.tuple.dst.protonum	= IPPROTO_TCP,
 	.help			= conntrack_pptp_help,
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index bc1d96686b9c..a0fa581db3e8 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -690,7 +690,7 @@ module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 		  &nf_conntrack_htable_size, 0600);
 
 MODULE_ALIAS("ip_conntrack");
-MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET));
-MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
+MODULE_ALIAS("nf_conntrack-" __stringify(NFPROTO_IPV4));
+MODULE_ALIAS("nf_conntrack-" __stringify(NFPROTO_IPV6));
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("IPv4 and IPv6 connection tracking");
diff --git a/net/netfilter/nf_conntrack_proto_icmp.c b/net/netfilter/nf_conntrack_proto_icmp.c
index b38b7164acd5..5ed4d8d7b6ed 100644
--- a/net/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/netfilter/nf_conntrack_proto_icmp.c
@@ -169,12 +169,12 @@ int nf_conntrack_inet_error(struct nf_conn *tmpl, struct sk_buff *skb,
 	dir = NF_CT_DIRECTION(h);
 	ct_daddr = &ct->tuplehash[dir].tuple.dst.u3;
 	if (!nf_inet_addr_cmp(outer_daddr, ct_daddr)) {
-		if (state->pf == AF_INET) {
+		if (state->pf == NFPROTO_IPV4) {
 			nf_l4proto_log_invalid(skb, state,
 					       l4proto,
 					       "outer daddr %pI4 != inner %pI4",
 					       &outer_daddr->ip, &ct_daddr->ip);
-		} else if (state->pf == AF_INET6) {
+		} else if (state->pf == NFPROTO_IPV6) {
 			nf_l4proto_log_invalid(skb, state,
 					       l4proto,
 					       "outer daddr %pI6 != inner %pI6",
diff --git a/net/netfilter/nf_conntrack_sane.c b/net/netfilter/nf_conntrack_sane.c
index 13dc421fc4f5..a5394c668b93 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -190,11 +190,11 @@ static int __init nf_conntrack_sane_init(void)
 	/* FIXME should be configurable whether IPv4 and IPv6 connections
 		 are tracked or not - YK */
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sane[2 * i], AF_INET, IPPROTO_TCP,
+		nf_ct_helper_init(&sane[2 * i], NFPROTO_IPV4, IPPROTO_TCP,
 				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
 				  &sane_exp_policy, 0, help, NULL,
 				  THIS_MODULE);
-		nf_ct_helper_init(&sane[2 * i + 1], AF_INET6, IPPROTO_TCP,
+		nf_ct_helper_init(&sane[2 * i + 1], NFPROTO_IPV6, IPPROTO_TCP,
 				  HELPER_NAME, SANE_PORT, ports[i], ports[i],
 				  &sane_exp_policy, 0, help, NULL,
 				  THIS_MODULE);
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index ca748f8dbff1..39c5abccd0e0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -152,12 +152,12 @@ static int sip_parse_addr(const struct nf_conn *ct, const char *cp,
 
 	memset(addr, 0, sizeof(*addr));
 	switch (nf_ct_l3num(ct)) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		ret = in4_pton(cp, limit - cp, (u8 *)&addr->ip, -1, &end);
 		if (ret == 0)
 			return 0;
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		if (cp < limit && *cp == '[')
 			cp++;
 		else if (delim)
@@ -652,10 +652,10 @@ static int sdp_parse_addr(const struct nf_conn *ct, const char *cp,
 
 	memset(addr, 0, sizeof(*addr));
 	switch (nf_ct_l3num(ct)) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		ret = in4_pton(cp, limit - cp, (u8 *)&addr->ip, -1, &end);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		ret = in6_pton(cp, limit - cp, (u8 *)&addr->ip6, -1, &end);
 		break;
 	default:
@@ -1677,19 +1677,19 @@ static int __init nf_conntrack_sip_init(void)
 		ports[ports_c++] = SIP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&sip[4 * i], AF_INET, IPPROTO_UDP,
+		nf_ct_helper_init(&sip[4 * i], NFPROTO_IPV4, IPPROTO_UDP,
 				  HELPER_NAME, SIP_PORT, ports[i], i,
 				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 1], AF_INET, IPPROTO_TCP,
+		nf_ct_helper_init(&sip[4 * i + 1], NFPROTO_IPV4, IPPROTO_TCP,
 				  HELPER_NAME, SIP_PORT, ports[i], i,
 				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 2], AF_INET6, IPPROTO_UDP,
+		nf_ct_helper_init(&sip[4 * i + 2], NFPROTO_IPV6, IPPROTO_UDP,
 				  HELPER_NAME, SIP_PORT, ports[i], i,
 				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_udp,
 				  NULL, THIS_MODULE);
-		nf_ct_helper_init(&sip[4 * i + 3], AF_INET6, IPPROTO_TCP,
+		nf_ct_helper_init(&sip[4 * i + 3], NFPROTO_IPV6, IPPROTO_TCP,
 				  HELPER_NAME, SIP_PORT, ports[i], i,
 				  sip_exp_policy, SIP_EXPECT_MAX, sip_help_tcp,
 				  NULL, THIS_MODULE);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 708b79380f04..90407e9e02cd 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -262,8 +262,8 @@ ct_show_delta_time(struct seq_file *s, const struct nf_conn *ct)
 static const char* l3proto_name(u16 proto)
 {
 	switch (proto) {
-	case AF_INET: return "ipv4";
-	case AF_INET6: return "ipv6";
+	case NFPROTO_IPV4: return "ipv4";
+	case NFPROTO_IPV6: return "ipv6";
 	}
 
 	return "unknown";
diff --git a/net/netfilter/nf_conntrack_tftp.c b/net/netfilter/nf_conntrack_tftp.c
index 80ee53f29f68..e60f296e7b49 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -119,11 +119,11 @@ static int __init nf_conntrack_tftp_init(void)
 		ports[ports_c++] = TFTP_PORT;
 
 	for (i = 0; i < ports_c; i++) {
-		nf_ct_helper_init(&tftp[2 * i], AF_INET, IPPROTO_UDP,
+		nf_ct_helper_init(&tftp[2 * i], NFPROTO_IPV4, IPPROTO_UDP,
 				  HELPER_NAME, TFTP_PORT, ports[i], i,
 				  &tftp_exp_policy, 0, tftp_help, NULL,
 				  THIS_MODULE);
-		nf_ct_helper_init(&tftp[2 * i + 1], AF_INET6, IPPROTO_UDP,
+		nf_ct_helper_init(&tftp[2 * i + 1], NFPROTO_IPV6, IPPROTO_UDP,
 				  HELPER_NAME, TFTP_PORT, ports[i], i,
 				  &tftp_exp_policy, 0, tftp_help, NULL,
 				  THIS_MODULE);
diff --git a/net/netfilter/nf_flow_table_bpf.c b/net/netfilter/nf_flow_table_bpf.c
index 4a5f5195f2d2..97b6f62cccb4 100644
--- a/net/netfilter/nf_flow_table_bpf.c
+++ b/net/netfilter/nf_flow_table_bpf.c
@@ -76,12 +76,12 @@ bpf_xdp_flow_lookup(struct xdp_md *ctx, struct bpf_fib_lookup *fib_tuple,
 	}
 
 	switch (fib_tuple->family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		tuple.src_v4.s_addr = fib_tuple->ipv4_src;
 		tuple.dst_v4.s_addr = fib_tuple->ipv4_dst;
 		proto = htons(ETH_P_IP);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		tuple.src_v6 = *(struct in6_addr *)&fib_tuple->ipv6_src;
 		tuple.dst_v6 = *(struct in6_addr *)&fib_tuple->ipv6_dst;
 		proto = htons(ETH_P_IPV6);
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index b0f199171932..21462399a2dd 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -116,7 +116,7 @@ module_exit(nf_flow_inet_module_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
-MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
-MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
+MODULE_ALIAS_NF_FLOWTABLE(NFPROTO_IPV4);
+MODULE_ALIAS_NF_FLOWTABLE(NFPROTO_IPV6);
+MODULE_ALIAS_NF_FLOWTABLE(NFPROTO_INET);
 MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 8cd4cf7ae211..ad47fe0d1e0f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -238,7 +238,7 @@ static int nf_flow_tuple_ip(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
 
 	tuple->src_v4.s_addr	= iph->saddr;
 	tuple->dst_v4.s_addr	= iph->daddr;
-	tuple->l3proto		= AF_INET;
+	tuple->l3proto		= NFPROTO_IPV4;
 	tuple->l4proto		= ipproto;
 	tuple->iifidx		= ctx->in->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
@@ -638,7 +638,7 @@ static int nf_flow_tuple_ipv6(struct nf_flowtable_ctx *ctx, struct sk_buff *skb,
 
 	tuple->src_v6		= ip6h->saddr;
 	tuple->dst_v6		= ip6h->daddr;
-	tuple->l3proto		= AF_INET6;
+	tuple->l3proto		= NFPROTO_IPV6;
 	tuple->l4proto		= nexthdr;
 	tuple->iifidx		= ctx->in->ifindex;
 	nf_flow_tuple_encap(skb, tuple);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e06bc36f49fe..569979c49e24 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -143,7 +143,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	}
 
 	switch (tuple->l3proto) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
 		key->basic.n_proto = htons(ETH_P_IP);
 		key->ipv4.src = tuple->src_v4.s_addr;
@@ -151,7 +151,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		key->ipv4.dst = tuple->dst_v4.s_addr;
 		mask->ipv4.dst = 0xffffffff;
 		break;
-       case AF_INET6:
+	case NFPROTO_IPV6:
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
 		key->basic.n_proto = htons(ETH_P_IPV6);
 		key->ipv6.src = tuple->src_v6;
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 86d5fc5d28e3..b2463e5013b6 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1078,8 +1078,8 @@ MODULE_ALIAS("nf_log_bridge");
 MODULE_ALIAS("nf_log_ipv4");
 MODULE_ALIAS("nf_log_ipv6");
 MODULE_ALIAS("nf_log_netdev");
-MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 0);
-MODULE_ALIAS_NF_LOGGER(AF_INET, 0);
-MODULE_ALIAS_NF_LOGGER(3, 0);
-MODULE_ALIAS_NF_LOGGER(5, 0); /* NFPROTO_NETDEV */
-MODULE_ALIAS_NF_LOGGER(AF_INET6, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_BRIDGE, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV4, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_ARP, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_NETDEV, 0);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV6, 0);
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 7f12e56e6e52..a0cba57458e1 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -167,10 +167,10 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		return -ESRCH;
 
 	switch (state->pf) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		route_key_size = sizeof(struct ip_rt_info);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		route_key_size = sizeof(struct ip6_rt_info);
 		break;
 	default:
@@ -214,10 +214,10 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 	}
 
 	switch (entry->state.pf) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		nf_ip_saveroute(skb, entry);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		nf_ip6_saveroute(skb, entry);
 		break;
 	}
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index eed434e0a970..b31c8f996956 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1729,7 +1729,7 @@ static int nft_flush(struct nft_ctx *ctx, int family)
 	int err = 0;
 
 	list_for_each_entry_safe(table, nt, &nft_net->tables, list) {
-		if (family != AF_UNSPEC && table->family != family)
+		if (family != NFPROTO_UNSPEC && table->family != family)
 			continue;
 
 		ctx->family = table->family;
@@ -1766,7 +1766,7 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_ctx ctx;
 
 	nft_ctx_init(&ctx, net, skb, info->nlh, 0, NULL, NULL, nla);
-	if (family == AF_UNSPEC ||
+	if (family == NFPROTO_UNSPEC ||
 	    (!nla[NFTA_TABLE_NAME] && !nla[NFTA_TABLE_HANDLE]))
 		return nft_flush(&ctx, family);
 
@@ -9693,7 +9693,7 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	char buf[TASK_COMM_LEN];
 	int event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, NFT_MSG_NEWGEN);
 
-	nlh = nfnl_msg_put(skb, portid, seq, event, 0, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, 0, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, nft_base_seq_be16(net));
 	if (!nlh)
 		goto nla_put_failure;
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index 505f46a32173..b4bd10d2df76 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -148,7 +148,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	u32 old_flags;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_ACCT, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, 0);
 	if (!nlh)
 		goto nlmsg_failure;
diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index 97248963a7d3..4f51d6932109 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -536,7 +536,7 @@ nfnl_cthelper_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	int status;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTHELPER, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, 0);
 	if (!nlh)
 		goto nlmsg_failure;
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 38d75484e531..b649c7383ef4 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -191,7 +191,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	int ret;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK_TIMEOUT, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, 0);
 	if (!nlh)
 		goto nlmsg_failure;
@@ -401,7 +401,7 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
 	int ret;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK_TIMEOUT, event);
-	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
+	nlh = nfnl_msg_put(skb, portid, seq, event, flags, NFPROTO_UNSPEC,
 			   NFNETLINK_V0, 0);
 	if (!nlh)
 		goto nlmsg_failure;
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index bfcb9cd335bf..4b9d0336f308 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1207,11 +1207,11 @@ MODULE_DESCRIPTION("netfilter userspace logging");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ULOG);
-MODULE_ALIAS_NF_LOGGER(AF_INET, 1);
-MODULE_ALIAS_NF_LOGGER(AF_INET6, 1);
-MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 1);
-MODULE_ALIAS_NF_LOGGER(3, 1); /* NFPROTO_ARP */
-MODULE_ALIAS_NF_LOGGER(5, 1); /* NFPROTO_NETDEV */
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV4, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_IPV6, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_BRIDGE, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_ARP, 1);
+MODULE_ALIAS_NF_LOGGER(NFPROTO_NETDEV, 1);
 
 module_init(nfnetlink_log_init);
 module_exit(nfnetlink_log_fini);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8b7b39d8a109..6561a7304cd6 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -296,10 +296,10 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 	int ret = 0;
 
 	switch (entry->state.pf) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		ret = nf_ip_reroute(skb, entry);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		v6ops = rcu_dereference(nf_ipv6_ops);
 		if (v6ops)
 			ret = v6ops->reroute(skb, entry);
diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
index 40e230d8b712..4d1f2d3abdb1 100644
--- a/net/netfilter/nft_chain_nat.c
+++ b/net/netfilter/nft_chain_nat.c
@@ -139,11 +139,11 @@ module_exit(nft_chain_nat_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("nftables network address translation support");
 #ifdef CONFIG_NF_TABLES_IPV4
-MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
+MODULE_ALIAS_NFT_CHAIN(NFPROTO_IPV4, "nat");
 #endif
 #ifdef CONFIG_NF_TABLES_IPV6
-MODULE_ALIAS_NFT_CHAIN(AF_INET6, "nat");
+MODULE_ALIAS_NFT_CHAIN(NFPROTO_IPV6, "nat");
 #endif
 #ifdef CONFIG_NF_TABLES_INET
-MODULE_ALIAS_NFT_CHAIN(1, "nat");	/* NFPROTO_INET */
+MODULE_ALIAS_NFT_CHAIN(NFPROTO_INET, "nat");
 #endif
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 72711d62fddf..41be9a207707 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -148,11 +148,11 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 	par->net	= ctx->net;
 	par->table	= ctx->table->name;
 	switch (ctx->family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		entry->e4.ip.proto = proto;
 		entry->e4.ip.invflags = inv ? IPT_INV_PROTO : 0;
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		if (proto)
 			entry->e6.ipv6.flags |= IP6T_F_PROTO;
 
@@ -448,11 +448,11 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 	par->net	= ctx->net;
 	par->table	= ctx->table->name;
 	switch (ctx->family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		entry->e4.ip.proto = proto;
 		entry->e4.ip.invflags = inv ? IPT_INV_PROTO : 0;
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		if (proto)
 			entry->e6.ipv6.flags |= IP6T_F_PROTO;
 
@@ -696,10 +696,10 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 	target = ntohl(nla_get_be32(tb[NFTA_COMPAT_TYPE]));
 
 	switch(family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		fmt = "ipt_%s";
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		fmt = "ip6t_%s";
 		break;
 	case NFPROTO_BRIDGE:
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 6e21f72c5b57..5fba3a4f8b62 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -35,13 +35,13 @@ static void nft_nat_setup_addr(struct nf_nat_range2 *range,
 			       const struct nft_nat *priv)
 {
 	switch (priv->family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		range->min_addr.ip = (__force __be32)
 				regs->data[priv->sreg_addr_min];
 		range->max_addr.ip = (__force __be32)
 				regs->data[priv->sreg_addr_max];
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		memcpy(range->min_addr.ip6, &regs->data[priv->sreg_addr_min],
 		       sizeof(range->min_addr.ip6));
 		memcpy(range->max_addr.ip6, &regs->data[priv->sreg_addr_max],
diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
index 008419db815a..758e5c761c27 100644
--- a/net/netfilter/utils.c
+++ b/net/netfilter/utils.c
@@ -127,10 +127,10 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
 	__sum16 csum = 0;
 
 	switch (family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		csum = nf_ip_checksum(skb, hook, dataoff, protocol);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		csum = nf_ip6_checksum(skb, hook, dataoff, protocol);
 		break;
 	}
@@ -146,11 +146,11 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
 	__sum16 csum = 0;
 
 	switch (family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		csum = nf_ip_checksum_partial(skb, hook, dataoff, len,
 					      protocol);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		csum = nf_ip6_checksum_partial(skb, hook, dataoff, len,
 					       protocol);
 		break;
@@ -167,10 +167,10 @@ int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 	int ret = 0;
 
 	switch (family) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		ret = nf_ip_route(net, dst, fl, strict);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		ret = nf_ip6_route(net, dst, fl, strict);
 		break;
 	}
diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index 8928ec56c388..347b8a710a9e 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -49,9 +49,9 @@ static inline __be32
 hmark_addr_mask(int l3num, const __be32 *addr32, const __be32 *mask)
 {
 	switch (l3num) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		return *addr32 & *mask;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		return hmark_addr6_mask(addr32, mask);
 	}
 	return 0;
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index 908fd5f2c3c8..267e567263e2 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -42,10 +42,10 @@ xt_cluster_hash(const struct nf_conn *ct,
 	u_int32_t hash = 0;
 
 	switch(nf_ct_l3num(ct)) {
-	case AF_INET:
+	case NFPROTO_IPV4:
 		hash = xt_cluster_hash_ipv4(nf_ct_orig_ipv4_src(ct), info);
 		break;
-	case AF_INET6:
+	case NFPROTO_IPV6:
 		hash = xt_cluster_hash_ipv6(nf_ct_orig_ipv6_src(ct), info);
 		break;
 	default:
diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index 5f827e10717d..23cf72f26802 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -157,7 +157,7 @@ static int conntrack_data_generate_v4(struct mnl_socket *sock, uint32_t src_ip,
 	nlh->nlmsg_seq = time(NULL);
 
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = AF_INET;
+	nfh->nfgen_family = NFPROTO_IPV4;
 	nfh->version = NFNETLINK_V0;
 	nfh->res_id = 0;
 
@@ -191,7 +191,7 @@ static int conntrack_data_generate_v6(struct mnl_socket *sock,
 	nlh->nlmsg_seq = time(NULL);
 
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = AF_INET6;
+	nfh->nfgen_family = NFPROTO_IPV6;
 	nfh->version = NFNETLINK_V0;
 	nfh->res_id = 0;
 
@@ -233,7 +233,7 @@ static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
 	nlh->nlmsg_seq = time(NULL);
 
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = AF_UNSPEC;
+	nfh->nfgen_family = NFPROTO_UNSPEC;
 	nfh->version = NFNETLINK_V0;
 	nfh->res_id = 0;
 
@@ -280,7 +280,7 @@ static int conntrack_flush_zone(struct mnl_socket *sock, uint16_t zone)
 	nlh->nlmsg_seq = time(NULL);
 
 	nfh = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
-	nfh->nfgen_family = AF_UNSPEC;
+	nfh->nfgen_family = NFPROTO_UNSPEC;
 	nfh->version = NFNETLINK_V0;
 	nfh->res_id = 0;
 
diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index 9e56b9d47037..a8f6f1045d57 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -132,7 +132,7 @@ nfq_build_cfg_request(char *buf, uint8_t command, int queue_num)
 
 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
 
-	nfg->nfgen_family = AF_UNSPEC;
+	nfg->nfgen_family = NFPROTO_UNSPEC;
 	nfg->version = NFNETLINK_V0;
 	nfg->res_id = htons(queue_num);
 
@@ -155,7 +155,7 @@ nfq_build_cfg_params(char *buf, uint8_t mode, int range, int queue_num)
 	nlh->nlmsg_flags = NLM_F_REQUEST;
 
 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_UNSPEC;
+	nfg->nfgen_family = NFPROTO_UNSPEC;
 	nfg->version = NFNETLINK_V0;
 	nfg->res_id = htons(queue_num);
 
@@ -178,7 +178,7 @@ nfq_build_verdict(char *buf, int id, int queue_num, uint32_t verd)
 	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_VERDICT;
 	nlh->nlmsg_flags = NLM_F_REQUEST;
 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
-	nfg->nfgen_family = AF_UNSPEC;
+	nfg->nfgen_family = NFPROTO_UNSPEC;
 	nfg->version = NFNETLINK_V0;
 	nfg->res_id = htons(queue_num);
 
-- 
2.43.0

