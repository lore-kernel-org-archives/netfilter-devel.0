Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2087.outbound.protection.outlook.com [40.107.247.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84441F9EAF;
	Fri, 27 Dec 2024 19:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.247.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326784; cv=fail; b=CfEdyf7mAXMBN7jGpuIACMY3GOvq0qRzgeU7D7VFO4NLGbmDnU0nMuRXVspJXE03TACEhMqtvQKFHbZVwKkADo8Nw5HNdYxhvE+7wWRRKbjQJMwQSucYtCL1ga7Skdr3l0ngFx8BsmMXdkQGpTevhQGrgd32hcExqIXey/pjOfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326784; c=relaxed/simple;
	bh=pbw2OQSAnpi5DuF5pan8o462KTTkkzZeZ5Ycd2Q2SlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h7g5Un1JwgLw3Xi7huFqCBmkPMAYg4hRH+XspjfN5+RN/kb+Xx2SK5T0bVDKbDu8L8YK4JBW+dh99ym0lz3F52sI07Vd3q8BETrOPL5dPm9DQpsYLB1/69uSORmelhyDMcQ4T2gVMFMnEALf/W7FmyZIv5dYnUMt3/iyz+4YCag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=UXZ+y6hx; arc=fail smtp.client-ip=40.107.247.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="UXZ+y6hx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=om0C+EIp8DF8v1Ky6wsfRSP4lE23pWCkJ93x9+7Il6DOzR1SgE1fgiif53rtBwaHdPsGVt95nmPKYnyKgIHsBOh+7mENlCDiA8Oinmr8AGpZFoD6EzUXOHnb8pG5zsNIbgk/6YGyEdBALQBUIY6QyRZ/lB3nEtE9DQ07xlZfsLEcCPTGaXiJl2i/EmZggot0OfYUfAHn8mk81pLuWfOe4Zbs0QiuMkm1gAvo/Efvy7Ya/ZSVuJ22+v35a0dwb3+Zhb/QolAHTjb6F9K5VU6iTTotCNWNZYfCjpvKP0NP+Cxdo+M2w9sLfp4NtGgHsZ9CBiI66OzJXMpChSDqww1osg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQriCZl2bTyHn9004OYreULPeiNFubb7hKAwAYFJBMQ=;
 b=DYctmiFh5Iy7DMTwZEbHyxzJVjmJqUIb5umdbjk2+oYxYPsHXttTHKH1Ak2xa0PpnFar6Rzl2Tn6V6HXFfAYMTF9pVfCgdT+dWE19gfLDln8dfzzUdQmLWt0uB5F8lAwXKPX4kFUZnickaljkR2dFZ3HzG7WZl55+r7tfliyPA+9YBfVLEfWZ7Ob7RFxGG2+LpUd3mZcXnZqgvOOuxPspbBTmAobU1ebdzcvpibcemmtA/+zvhld9LF/lL8P4SFfFcMsc2aOuF/ANL3SoHUTKnwmSZqQtik/fCdwB8k11Y/zDaOmqrCjJHmd9lO8Pp0DgmjDayYYr1xX7zmb0kqjDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQriCZl2bTyHn9004OYreULPeiNFubb7hKAwAYFJBMQ=;
 b=UXZ+y6hxzfuypgTZsRvjEAmDS0v3aGKhkv3t+30qYQTtVSCLNFxoLrx6tRSE0Kn42yLFj/5M5tK0mkhiKks17ia4k2vAZXlenYGx2KTHLvND0TrBnaKMiH+i9R2JUwgAvVS/1qATKGvDNt54RH8tO4U1kktbIz9g42JGYaM4g9wt75KgxZ7joyvw8mWlWpB0ST1xXpFI6dc+9iz/zBsOpT091IFBQy9ElX6Wa77JUxZEtdxhz/rl+CuRg0I42mXbg6Vihsrta2l7DN2KAQ35qhHYBrE9or34giHPKV6MVB6fCcPLPcEUGOPCBZ7PJS/VDVhpir28ep0ZxcvmeyMSbA==
Received: from DUZPR01CA0297.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::8) by AM7PR07MB6214.eurprd07.prod.outlook.com
 (2603:10a6:20b:13a::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 19:12:54 +0000
Received: from DB1PEPF000509FB.eurprd03.prod.outlook.com
 (2603:10a6:10:4b7:cafe::74) by DUZPR01CA0297.outlook.office365.com
 (2603:10a6:10:4b7::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.15 via Frontend Transport; Fri,
 27 Dec 2024 19:12:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 DB1PEPF000509FB.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:53 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2b011940;
	Fri, 27 Dec 2024 19:12:54 GMT
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
Subject: [PATCH v6 net-next 11/14] virtio_net: Accurate ECN flag in virtio_net_hdr
Date: Fri, 27 Dec 2024 20:12:08 +0100
Message-Id: <20241227191211.12485-12-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
References: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB1PEPF000509FB:EE_|AM7PR07MB6214:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 6d691234-adfd-41d5-9891-08dd26aa7700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mwrE89yqZHO+xy3voJ0WpygHyjdF5ot7lBa/H1nSFqw8IMkmz98l1euaNLF8?=
 =?us-ascii?Q?mqQdkPjpsIBOgIj3GnZjKsMAPNvldnNZqvwzTvhW0vll/L+y3hKyLUPAyY0R?=
 =?us-ascii?Q?F9fLXyThs781zqp2vL/LVQwrFmW143I/edwaOn0vJ4eoLOGVNL3RJOdR0FgB?=
 =?us-ascii?Q?1j0n1Pz8aNnTlY+2BS51Tw7G3UZsmccAOBRSOcxaWNEjicbxfEGy7/mqszAO?=
 =?us-ascii?Q?/vYK6VBwbjGtk1ZRqXOJzbBg8v02HbjiuZNMRu8q5psr7JzxY0QqXavTyBq2?=
 =?us-ascii?Q?7cZQXsuTD98SXuDfTnIHrC7krpd1fK+we+4SXRZpKB8pCktemWTz0YlAkAyd?=
 =?us-ascii?Q?HFt+G4ZYBXRahbDQCi9XtdxmfYMiFmXmXznUjjzbS5raD3uIuEbKvV+mVAmV?=
 =?us-ascii?Q?qmU53m0JFamlp2BtqPeaVmqsa1gosONNodBCUG7KCMH7SnHeZtCL3iEvhn/3?=
 =?us-ascii?Q?aKIcfFrb1OtARq45hOo8AIwRwhOQrsX31carCvU3DlM+Yty+1IsQ/JjI5SVI?=
 =?us-ascii?Q?c7AnKgHGM78BKe9aorPQP7Hlw9YrPhGiILZ3OIL+3kptHzEBen52cydku8HF?=
 =?us-ascii?Q?6U8ksTR/73ShtLmE7WjgDUVSSBuQTTkzL/L0c0WIUgMi7NT4TrNp4nq3k5/h?=
 =?us-ascii?Q?tF8aqbjkUV/w0bAAxRw53Es5TlVylGFC1IFqc/kemfV+n83FLyMCPaBWNh/V?=
 =?us-ascii?Q?LrIAiu/aDsYgGIR8Q1qEK3+Oqx6Spqi0mvwdBOU2Dnc9xYyVnA8iEAWOQxrt?=
 =?us-ascii?Q?DmmT792pzAdPmsGFUQaTroRbgbtDpemmq/X1eZRAzxXN9j78lsrdfEjloN8o?=
 =?us-ascii?Q?AzG+gvLVODYsZdUTxAFlm/5gfNmqYerXmcyOIvOa+PhVgBgqiYkLLGXweNA8?=
 =?us-ascii?Q?GkYtSeSI85UwjLnWN9pi3GYRK9At0tjXWbWUfbcENx+xA7VVR4IbzWaemtMM?=
 =?us-ascii?Q?erJ00qkchlJvApb6m9G+VWAohNfrcSCT43Rz7rabdrz/G2R1Um+vrdV8iF79?=
 =?us-ascii?Q?TMELcuQyYv3laBQycdc557EjtiqsUS6ni3sWgRJLk7dYFcy+1v1V/JIl1ys+?=
 =?us-ascii?Q?AsIXyObTPWHLG1XDKW9cSJ4+EGnmEbFz21yM+QaP5MKbbAQX+HiLjBAYDPls?=
 =?us-ascii?Q?KRnP45yUZjar8+FWDwhiSDzwHW/U32Mfej1w4nWQRaQOKu9hs+ymuMM/Vx5C?=
 =?us-ascii?Q?rZvvsFWEscHN07qpRlV32s6Nht1/bhovTPRjI3B5CXkTk7dKmlfkXfSQTMHx?=
 =?us-ascii?Q?O9Eg2170DUN9gwVQwn2RlCG7K6gErwmhQDgWMG88hCja3pSuZ7R6SPOXKGzu?=
 =?us-ascii?Q?9xBq/yXj4WdCejJgwv0Ke4NFUDDLKE8Tzos1U92F6HKVcqYOC+O8xLi+rDGg?=
 =?us-ascii?Q?YivdKbQMz11Wjbt817Ave5WYy5qSwSvW446/HT6UCGXjowIN6mvP0G2XZMWc?=
 =?us-ascii?Q?2zuqUUd2olyk6PK1cvG1UbdGrEa6s23/gVIxeLYaPP6OpeuErwY7vxaBw7Qw?=
 =?us-ascii?Q?GQ1AfGgTarX/0Ms+hcylSxZXuE9uzvKufj0a?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:53.7895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d691234-adfd-41d5-9891-08dd26aa7700
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR07MB6214

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Unlike RFC 3168 ECN, accurate ECN uses the CWR flag as part of the ACE
field to count new packets with CE mark; however, it will be corrupted
by the RFC 3168 ECN-aware TSO. Therefore, fallback shall be applied by
seting NETIF_F_GSO_ACCECN to ensure that the CWR flag should not be
changed within a super-skb.

To apply the aforementieond new AccECN GSO for virtio, new featue bits
for host and guest are added for feature negotiation between driver and
device. And the translation of Accurate ECN GSO flag between
virtio_net_hdr and skb header for NETIF_F_GSO_ACCECN is also added to
avoid CWR flag corruption due to RFC3168 ECN TSO.

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
---
 drivers/net/virtio_net.c        | 14 +++++++++++---
 drivers/vdpa/pds/debugfs.c      |  6 ++++++
 include/linux/virtio_net.h      | 16 ++++++++++------
 include/uapi/linux/virtio_net.h |  5 +++++
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7646ddd9bef7..470c70fa6868 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -58,6 +58,7 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_TSO4,
 	VIRTIO_NET_F_GUEST_TSO6,
 	VIRTIO_NET_F_GUEST_ECN,
+	VIRTIO_NET_F_GUEST_ACCECN,
 	VIRTIO_NET_F_GUEST_UFO,
 	VIRTIO_NET_F_GUEST_CSUM,
 	VIRTIO_NET_F_GUEST_USO4,
@@ -68,6 +69,7 @@ static const unsigned long guest_offloads[] = {
 #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
+				(1ULL << VIRTIO_NET_F_GUEST_ACCECN) | \
 				(1ULL << VIRTIO_NET_F_GUEST_UFO)  | \
 				(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_USO6))
@@ -5886,6 +5888,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	    && (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ACCECN) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) ||
@@ -6549,6 +6552,7 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
 	return virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
+		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ACCECN) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
 		(virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) &&
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6));
@@ -6663,6 +6667,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 			dev->hw_features |= NETIF_F_TSO6;
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
 			dev->hw_features |= NETIF_F_TSO_ECN;
+		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ACCECN))
+			dev->hw_features |= NETIF_F_GSO_ACCECN;
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_USO))
 			dev->hw_features |= NETIF_F_GSO_UDP_L4;
 
@@ -7061,9 +7067,11 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CSUM, VIRTIO_NET_F_GUEST_CSUM, \
 	VIRTIO_NET_F_MAC, \
 	VIRTIO_NET_F_HOST_TSO4, VIRTIO_NET_F_HOST_UFO, VIRTIO_NET_F_HOST_TSO6, \
-	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
-	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_UFO, \
-	VIRTIO_NET_F_HOST_USO, VIRTIO_NET_F_GUEST_USO4, VIRTIO_NET_F_GUEST_USO6, \
+	VIRTIO_NET_F_HOST_ECN, VIRTIO_NET_F_HOST_ACCECN, \
+	VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6, \
+	VIRTIO_NET_F_GUEST_ECN, VIRTIO_NET_F_GUEST_ACCECN, \
+	VIRTIO_NET_F_GUEST_UFO, VIRTIO_NET_F_HOST_USO, \
+	VIRTIO_NET_F_GUEST_USO4, VIRTIO_NET_F_GUEST_USO6, \
 	VIRTIO_NET_F_MRG_RXBUF, VIRTIO_NET_F_STATUS, VIRTIO_NET_F_CTRL_VQ, \
 	VIRTIO_NET_F_CTRL_RX, VIRTIO_NET_F_CTRL_VLAN, \
 	VIRTIO_NET_F_GUEST_ANNOUNCE, VIRTIO_NET_F_MQ, \
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
index c328e694f6e7..90bd95db0245 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -78,6 +78,9 @@ static void print_feature_bits_all(struct seq_file *seq, u64 features)
 		case BIT_ULL(VIRTIO_NET_F_GUEST_ECN):
 			seq_puts(seq, " VIRTIO_NET_F_GUEST_ECN");
 			break;
+		case BIT_ULL(VIRTIO_NET_F_GUEST_ACCECN):
+			seq_puts(seq, " VIRTIO_NET_F_GUEST_ACCECN");
+			break;
 		case BIT_ULL(VIRTIO_NET_F_GUEST_UFO):
 			seq_puts(seq, " VIRTIO_NET_F_GUEST_UFO");
 			break;
@@ -90,6 +93,9 @@ static void print_feature_bits_all(struct seq_file *seq, u64 features)
 		case BIT_ULL(VIRTIO_NET_F_HOST_ECN):
 			seq_puts(seq, " VIRTIO_NET_F_HOST_ECN");
 			break;
+		case BIT_ULL(VIRTIO_NET_F_HOST_ACCECN):
+			seq_puts(seq, " VIRTIO_NET_F_HOST_ACCECN");
+			break;
 		case BIT_ULL(VIRTIO_NET_F_HOST_UFO):
 			seq_puts(seq, " VIRTIO_NET_F_HOST_UFO");
 			break;
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 02a9f4dc594d..3b71465f0ddb 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -11,7 +11,7 @@
 
 static inline bool virtio_net_hdr_match_proto(__be16 protocol, __u8 gso_type)
 {
-	switch (gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
+	switch (gso_type & ~VIRTIO_NET_HDR_GSO_ECN_FLAGS) {
 	case VIRTIO_NET_HDR_GSO_TCPV4:
 		return protocol == cpu_to_be16(ETH_P_IP);
 	case VIRTIO_NET_HDR_GSO_TCPV6:
@@ -31,7 +31,7 @@ static inline int virtio_net_hdr_set_proto(struct sk_buff *skb,
 	if (skb->protocol)
 		return 0;
 
-	switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
+	switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN_FLAGS) {
 	case VIRTIO_NET_HDR_GSO_TCPV4:
 	case VIRTIO_NET_HDR_GSO_UDP:
 	case VIRTIO_NET_HDR_GSO_UDP_L4:
@@ -58,7 +58,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 	unsigned int ip_proto;
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
-		switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
+		switch (hdr->gso_type & ~VIRTIO_NET_HDR_GSO_ECN_FLAGS) {
 		case VIRTIO_NET_HDR_GSO_TCPV4:
 			gso_type = SKB_GSO_TCPV4;
 			ip_proto = IPPROTO_TCP;
@@ -84,7 +84,9 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 			return -EINVAL;
 		}
 
-		if (hdr->gso_type & VIRTIO_NET_HDR_GSO_ECN)
+		if (hdr->gso_type & VIRTIO_NET_HDR_GSO_ACCECN)
+			gso_type |= SKB_GSO_TCP_ACCECN;
+		else if (hdr->gso_type & VIRTIO_NET_HDR_GSO_ECN)
 			gso_type |= SKB_GSO_TCP_ECN;
 
 		if (hdr->gso_size == 0)
@@ -158,7 +160,7 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 		unsigned int nh_off = p_off;
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		switch (gso_type & ~SKB_GSO_TCP_ECN) {
+		switch (gso_type & ~(SKB_GSO_TCP_ECN | SKB_GSO_TCP_ACCECN)) {
 		case SKB_GSO_UDP:
 			/* UFO may not include transport header in gso_size. */
 			nh_off -= thlen;
@@ -223,7 +225,9 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
 			hdr->gso_type = VIRTIO_NET_HDR_GSO_UDP_L4;
 		else
 			return -EINVAL;
-		if (sinfo->gso_type & SKB_GSO_TCP_ECN)
+		if (sinfo->gso_type & SKB_GSO_TCP_ACCECN)
+			hdr->gso_type |= VIRTIO_NET_HDR_GSO_ACCECN;
+		else if (sinfo->gso_type & SKB_GSO_TCP_ECN)
 			hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
 	} else
 		hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index ac9174717ef1..65a13b7d4eed 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -56,6 +56,8 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
+#define VIRTIO_NET_F_HOST_ACCECN 25	/* Host can handle GSO of Accurate ECN */
+#define VIRTIO_NET_F_GUEST_ACCECN 26	/* Guest can handle GSO of Accurate ECN */
 #define VIRTIO_NET_F_DEVICE_STATS 50	/* Device can provide device-level statistics. */
 #define VIRTIO_NET_F_VQ_NOTF_COAL 52	/* Device supports virtqueue notification coalescing */
 #define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
@@ -137,7 +139,10 @@ struct virtio_net_hdr_v1 {
 #define VIRTIO_NET_HDR_GSO_UDP		3	/* GSO frame, IPv4 UDP (UFO) */
 #define VIRTIO_NET_HDR_GSO_TCPV6	4	/* GSO frame, IPv6 TCP */
 #define VIRTIO_NET_HDR_GSO_UDP_L4	5	/* GSO frame, IPv4& IPv6 UDP (USO) */
+#define VIRTIO_NET_HDR_GSO_ACCECN	0x40	/* TCP AccECN segmentation */
 #define VIRTIO_NET_HDR_GSO_ECN		0x80	/* TCP has ECN set */
+#define VIRTIO_NET_HDR_GSO_ECN_FLAGS	(VIRTIO_NET_HDR_GSO_ECN | \
+					 VIRTIO_NET_HDR_GSO_ACCECN)
 	__u8 gso_type;
 	__virtio16 hdr_len;	/* Ethernet + IP + tcp/udp hdrs */
 	__virtio16 gso_size;	/* Bytes to append to hdr_len per frame */
-- 
2.34.1

