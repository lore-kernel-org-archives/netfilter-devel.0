Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2044.outbound.protection.outlook.com [40.107.103.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51A71F9435;
	Fri, 27 Dec 2024 19:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.103.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326778; cv=fail; b=dZxSHbiNLPn90wq/dqrzkc2aV2Zorz97+tLLMZOhEJHA97//E1mAgy0USAIp033CrxTfsRaqofn1XtJDWUn3AQ+RIbps9XfW8KQirnZIFjq0urNdGbiJ4WexMkFZfchUlFOUHcnfiYdx+0hApVovv3x9eyT+yoqGWPXNi3DqNKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326778; c=relaxed/simple;
	bh=vvKl+hRd4P2c+aZzDb6E/7ggWjkmkGN8GiwvcfahwnE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJntuppDOzNqfXHAJwDWXvSG7VvIbhKPzVAOuVGpvCwt2wp6y60kfigpzKI/grZMH5tedgDODnUYy06+gkVkd8YE7f97kFTROWiC3LBz8icRQVL0+nbyVl3PBCVYdkLSWEfIZgv0TRRmgnTqNpP9/IzmgqcoowSpyO2QKMu768s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=jRTEDt+1; arc=fail smtp.client-ip=40.107.103.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="jRTEDt+1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LK1GTpovFIBlR1XvyXruSIZT1X4krwDsXeujeJZbUBGwBISyXfcRV+vp6lr/sMIwTVD7LX2wK+yy0V5Ug47DS5WPBtt6bKluVVIXWcDcq6jGD8RFXM4rXGYNw6J1EiJGPXN1H85KZOSTNVsWYirO96XJ0y2CRkGIC1GvQFiKD4266/PPALSi4J71cdt/eKoEYQDhTfEkTrsW0tZFeIZJZ/iSkxjBHy8X4kYBWhyw7mTTqtVkOecW7F6B+MQeWWbAPemYp0HunXhbV+Lj+ZjfdW9RsGvzYpBwc6VWgfZqwNO/AQ2LhsUIksYl76U34ShOIPYwN4ZHPTtXJYkDxxKvsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9F9YbHQ4+dUQbRnzdxmTs7ibFUXoiEd2WYHYKLzw36Y=;
 b=xPKeMMKL67CV7aYdGFMxnapf6TxwxKzah1Zmsh1D9TE+eP4tTvkg+1qr5G4cPQbyhI3CNNzTkMCJC/LydUoNvNiUJHOK8LLqBZXR35WklGOy38rZa8EjTz78H9Nlz0M8fGNPWhOxcJ/R9qm9G7NuZUauNQrBXRHgPUnzZafWOP7hVzDBLzGKJ7I3/ZqUvoZ8X37h1IZGHpAmVgSfgxqa2brynJjPtdXRCsexBgilWnGm9Jy3QHFQAnKBIY8vJNEo2ZsCYn+GNBH4hrzZgA06YwtUIOeDT+gZWq3sWdHtSghJ5t0yIjs6/jfJEwIA1oqj7pqwB+4RVXngiTk870NR8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9F9YbHQ4+dUQbRnzdxmTs7ibFUXoiEd2WYHYKLzw36Y=;
 b=jRTEDt+1pROuF9L248df65fi6MJAh2CMWcm//YJn4R8kNJju7+nB1H4mi29luUgHmYgX2Z2UBplhCnDoyo0IkLfhI8a3X3epDfZKJBMcdRXWsDplpkwXkHlEO+PtyqrJgm63TUnnf++NQgHvUqU9YGL1L6Oi5vOFShu1K4fPsr7AEfdl7yTtiIPOB+AkZvHRf70nJyjlG6dseq6cr8XdiysNGNnW4y5npjV4/Fv5PJuaoqrr8p+3JAR5fS3GmPCBIW2qTjrLpG6L8XJzmfQ8+d/LakPEK/ZY7qSUnrfDwX0FbHW4IpatGpi1fOgGziXp7sqjR5+6a55EcyujzwDCCg==
Received: from AM5PR0601CA0057.eurprd06.prod.outlook.com (2603:10a6:206::22)
 by AS2PR07MB9183.eurprd07.prod.outlook.com (2603:10a6:20b:5e9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 19:12:47 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:206:0:cafe::10) by AM5PR0601CA0057.outlook.office365.com
 (2603:10a6:206::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.16 via Frontend Transport; Fri,
 27 Dec 2024 19:12:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:47 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2X011940;
	Fri, 27 Dec 2024 19:12:47 GMT
From: chia-yu.chang@nokia-bell-labs.com
To: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com,
        joel.granados@kernel.org, kuba@kernel.org, andrew+netdev@lunn.ch,
        horms@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        shenjian15@huawei.com, salil.mehta@huawei.com, shaojijie@huawei.com,
        saeedm@nvidia.com, tariqt@nvidia.com, mst@redhat.com,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, ij@kernel.org, ncardwell@google.com,
        koen.de_schepper@nokia-bell-labs.com, g.white@cablelabs.com,
        ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com,
        cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com,
        vidhi_goel@apple.com
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH v6 net-next 07/14] tcp: helpers for ECN mode handling
Date: Fri, 27 Dec 2024 20:12:04 +0100
Message-Id: <20241227191211.12485-8-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM3PEPF00009B9D:EE_|AS2PR07MB9183:EE_
X-MS-Office365-Filtering-Correlation-Id: 28af2c69-09ca-403a-474a-08dd26aa7311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEt5T1N1bXJYeHdlSEpSUVZPN3JrU0V4bXYyQStQL0lvQXVxbGdBSmJqemVk?=
 =?utf-8?B?MVNreGMzYjQ0bUU2ZS9XNWFSOStmUG5CRWViQTczWVNHaXFncVFzbGpoVHFh?=
 =?utf-8?B?UzZ6ZnJrcFg3aVpWRnRHaGNtUG9KRWZUSFJQeVphSWMrbFo0UnR1ZVdvTEtL?=
 =?utf-8?B?TWowVTNuODdHcDMvdHZwUmYxbzdNNkcxby9kY2VLYitpWG5sOU5lN2Vscmgx?=
 =?utf-8?B?TjAxVTdoTXVKUlIzcDFqeGRndCtaNHJ2U0VoZG9DZUZaL1F6OFdOUmhyeGxi?=
 =?utf-8?B?dHBEMGlQTlAvMTVKTlF6WkdRYnY3U0N5bi9pck9JblU1TEI4YUdZSWZmSGxV?=
 =?utf-8?B?RVRGMWYxSkNiYWJlWTJ1RmtvMjJxMm42UUNqclhZQ3d0VTh3dHFKejBKaFV3?=
 =?utf-8?B?MXFtbko3VFhQQldZTFI1STJoWnVFK3I0SHFMZ1lGZ3pFMEJ4MG9qRjVsd1Rt?=
 =?utf-8?B?cy8yWmt5emIvTis3allmYlVnYXFlUjZaYk9EemVCa3BsY2tVVExKU2VhQm02?=
 =?utf-8?B?WXVpMnQzMm5Dd29US3FFOEYySFc4c2ZCVmhneGhuZXhDSzZqTXhmTGpENnlN?=
 =?utf-8?B?cEtudlBzb1RncTVBQng2Mml6Y2lEYlBtOXp3eDgzcGE5Z01XeEVOVlUydGZG?=
 =?utf-8?B?WEJ0ZGR4NUdrRURaZlFrQ1FDS1FFSTA4ckpySnQrZlg2QXRDOGxBTFVqYzM3?=
 =?utf-8?B?eEtlOVE4UmtOaExwUmpCYW9jMDR2V1Mvb1RWTDNMTjNJRWNPWW0vcmJyR0xm?=
 =?utf-8?B?eDhMZTR0NGxwTHZySGZnSEJBam1HUzdNOTNmVTcwcHh6N0NLNk1PSzIzOVA1?=
 =?utf-8?B?VFgzTkVPVHRPZzhMWFlveTZ2NzhON1Y1QjBFQUdGVXplUW1CZUtvMDZ6d0xU?=
 =?utf-8?B?c1ZxQkxLbVBlMERoazBLU3ZXUmplOU11SE5yelVJVGg4S2ppY3ByWXE2ekMx?=
 =?utf-8?B?YVgxMUZQQU1CenBZRStaVC8xeEhnMkg4MlJNbzNNVHZmTXFqQXdhYWxheHRP?=
 =?utf-8?B?T2d6SjVqWW1qVXZla3RQQzd1UENndmk2UjhuQUJ0eVltOGNvRWp0RmZTTS9h?=
 =?utf-8?B?Y2Nub2lybUtBUGNDSlFZSXNnUStFTUhmU0NFL3JzZFRudHNSYklTQ2lMVHdG?=
 =?utf-8?B?cXVmU0Zrelp6TmNac3BXZW50Zk4zZnBUbVFxOUJVc0FtV0RvYitIbXZvdzVT?=
 =?utf-8?B?WXQwS2Q0OG9JMWd3Um04MnU2Qmk2RGVqakJibkJMVHhVaVppUGhXNUlpMG9U?=
 =?utf-8?B?T21aajZTQ3dpM3cxVEpFejVMUlc0eENSTUlZejdWdXdDbGNRdGZqdVhUemFy?=
 =?utf-8?B?SkxrZFM1L24vZUptL2V3ZjRxQkxYRWFoS3AyZkQzcnp1dGNucnNBT3BqUk44?=
 =?utf-8?B?SlFSY0dxVW8xRHJybUxvYmZPTVR1NDhTUDVuQzRBZG9xMkJuSDJqOCtFcWVl?=
 =?utf-8?B?ZEc3SWk1dlh0UTlVY2lpK0ZvNHJWS1kwcTNnWE9nTG1RRitVY2plb1g2MSs2?=
 =?utf-8?B?MEVHUUdmZ2NIZDNkMGQwZlVvWnhhUnE0ZEtiZGpLRC9DNGYvNXJHZWhVZFIv?=
 =?utf-8?B?MEtjVUNhWjkyamdzcWlOSUVidUVaZi9PcVlrNStxWjR1U1B2TS9XR29TWjVT?=
 =?utf-8?B?ZW91RWFGMmdzdEtpOEdpV2Zna010ZnZPMlNXZlZOWE5pN3BwMEZqMlh6K1RE?=
 =?utf-8?B?cW8vSTIwKzdXc3hiSXowZ05TZG9SQW40QVBZSFlvZTZ4d0NsTUE3Qmp0d29L?=
 =?utf-8?B?eThCOU00ODVEbGpkL0srV0dGQlVFR2xkcUsrUGpmNFpuVjN1enpKTUE2R1Q1?=
 =?utf-8?B?U0g3aFJwRXM0S2FmSHYwUEt3Uk53UjkvNTlEMlpRdDRRYU1OWTVoMStPek8w?=
 =?utf-8?B?b2d4N1huN2FodVdEQWtjaWJJR1grTkFpVi95eHFVWE5RTXo2Z1pYbVJCSWdD?=
 =?utf-8?B?d2JPZi9oVW9oOEVsMk4vdU84RWhMQnVCSjlIcnAyVUlVdFRRSWcvZGhIdVZm?=
 =?utf-8?B?bG91UzJZMXlRQm1nODVJQ1FnZGNaUDlxT1B5ZUE4NVY0MjN3cVpod1dXUmZR?=
 =?utf-8?Q?+UG35I?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:47.2348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28af2c69-09ca-403a-474a-08dd26aa7311
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR07MB9183

From: Ilpo Järvinen <ij@kernel.org>

Create helpers for TCP ECN modes. No functional changes.

Signed-off-by: Ilpo Järvinen <ij@kernel.org>
Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tcp.h        | 44 ++++++++++++++++++++++++++++++++++++----
 net/ipv4/tcp.c           |  2 +-
 net/ipv4/tcp_dctcp.c     |  2 +-
 net/ipv4/tcp_input.c     | 14 ++++++-------
 net/ipv4/tcp_minisocks.c |  4 +++-
 net/ipv4/tcp_output.c    |  6 +++---
 6 files changed, 55 insertions(+), 17 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index c9bab41685cf..4987cb0c59c4 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -372,10 +372,46 @@ static inline void tcp_dec_quickack_mode(struct sock *sk)
 	}
 }
 
-#define	TCP_ECN_OK		1
-#define	TCP_ECN_QUEUE_CWR	2
-#define	TCP_ECN_DEMAND_CWR	4
-#define	TCP_ECN_SEEN		8
+#define	TCP_ECN_MODE_RFC3168	BIT(0)
+#define	TCP_ECN_QUEUE_CWR	BIT(1)
+#define	TCP_ECN_DEMAND_CWR	BIT(2)
+#define	TCP_ECN_SEEN		BIT(3)
+#define	TCP_ECN_MODE_ACCECN	BIT(4)
+
+#define	TCP_ECN_DISABLED	0
+#define	TCP_ECN_MODE_PENDING	(TCP_ECN_MODE_RFC3168 | TCP_ECN_MODE_ACCECN)
+#define	TCP_ECN_MODE_ANY	(TCP_ECN_MODE_RFC3168 | TCP_ECN_MODE_ACCECN)
+
+static inline bool tcp_ecn_mode_any(const struct tcp_sock *tp)
+{
+	return tp->ecn_flags & TCP_ECN_MODE_ANY;
+}
+
+static inline bool tcp_ecn_mode_rfc3168(const struct tcp_sock *tp)
+{
+	return (tp->ecn_flags & TCP_ECN_MODE_ANY) == TCP_ECN_MODE_RFC3168;
+}
+
+static inline bool tcp_ecn_mode_accecn(const struct tcp_sock *tp)
+{
+	return (tp->ecn_flags & TCP_ECN_MODE_ANY) == TCP_ECN_MODE_ACCECN;
+}
+
+static inline bool tcp_ecn_disabled(const struct tcp_sock *tp)
+{
+	return !tcp_ecn_mode_any(tp);
+}
+
+static inline bool tcp_ecn_mode_pending(const struct tcp_sock *tp)
+{
+	return (tp->ecn_flags & TCP_ECN_MODE_PENDING) == TCP_ECN_MODE_PENDING;
+}
+
+static inline void tcp_ecn_mode_set(struct tcp_sock *tp, u8 mode)
+{
+	tp->ecn_flags &= ~TCP_ECN_MODE_ANY;
+	tp->ecn_flags |= mode;
+}
 
 enum tcp_tw_status {
 	TCP_TW_SUCCESS = 0,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 0d704bda6c41..e30204394175 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4107,7 +4107,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 		info->tcpi_rcv_wscale = tp->rx_opt.rcv_wscale;
 	}
 
-	if (tp->ecn_flags & TCP_ECN_OK)
+	if (tcp_ecn_mode_any(tp))
 		info->tcpi_options |= TCPI_OPT_ECN;
 	if (tp->ecn_flags & TCP_ECN_SEEN)
 		info->tcpi_options |= TCPI_OPT_ECN_SEEN;
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 8a45a4aea933..03abe0848420 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -90,7 +90,7 @@ __bpf_kfunc static void dctcp_init(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	if ((tp->ecn_flags & TCP_ECN_OK) ||
+	if (tcp_ecn_mode_any(tp) ||
 	    (sk->sk_state == TCP_LISTEN ||
 	     sk->sk_state == TCP_CLOSE)) {
 		struct dctcp *ca = inet_csk_ca(sk);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4751f55a79ad..0804f146d6dc 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -334,7 +334,7 @@ static bool tcp_in_quickack_mode(struct sock *sk)
 
 static void tcp_ecn_queue_cwr(struct tcp_sock *tp)
 {
-	if (tp->ecn_flags & TCP_ECN_OK)
+	if (tcp_ecn_mode_rfc3168(tp))
 		tp->ecn_flags |= TCP_ECN_QUEUE_CWR;
 }
 
@@ -361,7 +361,7 @@ static void tcp_data_ecn_check(struct sock *sk, const struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (!(tcp_sk(sk)->ecn_flags & TCP_ECN_OK))
+	if (tcp_ecn_disabled(tp))
 		return;
 
 	switch (TCP_SKB_CB(skb)->ip_dsfield & INET_ECN_MASK) {
@@ -394,19 +394,19 @@ static void tcp_data_ecn_check(struct sock *sk, const struct sk_buff *skb)
 
 static void tcp_ecn_rcv_synack(struct tcp_sock *tp, const struct tcphdr *th)
 {
-	if ((tp->ecn_flags & TCP_ECN_OK) && (!th->ece || th->cwr))
-		tp->ecn_flags &= ~TCP_ECN_OK;
+	if (tcp_ecn_mode_rfc3168(tp) && (!th->ece || th->cwr))
+		tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
 }
 
 static void tcp_ecn_rcv_syn(struct tcp_sock *tp, const struct tcphdr *th)
 {
-	if ((tp->ecn_flags & TCP_ECN_OK) && (!th->ece || !th->cwr))
-		tp->ecn_flags &= ~TCP_ECN_OK;
+	if (tcp_ecn_mode_rfc3168(tp) && (!th->ece || !th->cwr))
+		tcp_ecn_mode_set(tp, TCP_ECN_DISABLED);
 }
 
 static bool tcp_ecn_rcv_ecn_echo(const struct tcp_sock *tp, const struct tcphdr *th)
 {
-	if (th->ece && !th->syn && (tp->ecn_flags & TCP_ECN_OK))
+	if (th->ece && !th->syn && tcp_ecn_mode_rfc3168(tp))
 		return true;
 	return false;
 }
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index b089b08e9617..64d242571449 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -462,7 +462,9 @@ EXPORT_SYMBOL(tcp_openreq_init_rwin);
 static void tcp_ecn_openreq_child(struct tcp_sock *tp,
 				  const struct request_sock *req)
 {
-	tp->ecn_flags = inet_rsk(req)->ecn_ok ? TCP_ECN_OK : 0;
+	tcp_ecn_mode_set(tp, inet_rsk(req)->ecn_ok ?
+			     TCP_ECN_MODE_RFC3168 :
+			     TCP_ECN_DISABLED);
 }
 
 void tcp_ca_openreq_child(struct sock *sk, const struct dst_entry *dst)
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fde40ffc32ff..c2763c3361ad 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -322,7 +322,7 @@ static void tcp_ecn_send_synack(struct sock *sk, struct sk_buff *skb)
 	const struct tcp_sock *tp = tcp_sk(sk);
 
 	TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_CWR;
-	if (!(tp->ecn_flags & TCP_ECN_OK))
+	if (tcp_ecn_disabled(tp))
 		TCP_SKB_CB(skb)->tcp_flags &= ~TCPHDR_ECE;
 	else if (tcp_ca_needs_ecn(sk) ||
 		 tcp_bpf_ca_needs_ecn(sk))
@@ -351,7 +351,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 			INET_ECN_xmit(sk);
 
 		TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_ECE | TCPHDR_CWR;
-		tp->ecn_flags = TCP_ECN_OK;
+		tcp_ecn_mode_set(tp, TCP_ECN_MODE_RFC3168);
 	}
 }
 
@@ -379,7 +379,7 @@ static void tcp_ecn_send(struct sock *sk, struct sk_buff *skb,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (tp->ecn_flags & TCP_ECN_OK) {
+	if (tcp_ecn_mode_rfc3168(tp)) {
 		/* Not-retransmitted data segment: set ECT and inject CWR. */
 		if (skb->len != tcp_header_len &&
 		    !before(TCP_SKB_CB(skb)->seq, tp->snd_nxt)) {
-- 
2.34.1

