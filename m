Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAACBC8DC;
	Mon, 12 May 2025 03:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747019382; cv=none; b=TY98l9L50OkGjHrlc3QxRURs5uUKq4rhbOQ/nu26eBh2mZF/QrVtt41zIouk8yuKnv2clCUi57bFcwaDUfd+eNSvl4S7eBmHF2xcGFF8s4ZbcojVSbt1tCLDtGfH2AWnFsgJEmSVaXVabq+kqABNwUtusepWn2AJwp8B/9BRdaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747019382; c=relaxed/simple;
	bh=1pcwk6KV+B77NKatBp76l4mAmdog8PFZ8aV0zAeB3mE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lOD6ls1dSbFQPrKiK4R55syj4O5MoP+tGHy/iBwn0dHNpq0pP02Lp5NwNfhI8HNzWzzx27cBsFVNlyvJLwDE1bmCtFv0TjEzos5XJhAW12IatHkP3AHAsfZQjCFfrgphkFM+A0pA21x8/69oF5uDzv5M6tDHStXFW0nqCKdyMco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54C2tjg3010202;
	Mon, 12 May 2025 03:09:20 GMT
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46hws89926-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 12 May 2025 03:09:20 +0000 (GMT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 11 May 2025 20:09:18 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 11 May 2025 20:09:15 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5.15.y] netfilter: nf_tables: fix memleak in map from abort path
Date: Mon, 12 May 2025 11:09:14 +0800
Message-ID: <20250512030914.3330393-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: kwxk-6QC03G-YDb6iF6cWIHnjgRpF7mB
X-Proofpoint-GUID: kwxk-6QC03G-YDb6iF6cWIHnjgRpF7mB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDAzMSBTYWx0ZWRfXz9h0c1Jq+9vo YyZezL5RlkZBtOz3d3PBgasPp9x+kEP7ebpQgLlASulgIUn4wOFeS5/74vv5DgbNDZCDbX2Qqre zhp+AZiy1C3NBWURLlmjXVk2XKKg16QKkkZwABe2bLPetDJqdUQoK4MdDaB6KQZZtESA+weAv6f
 sGQN+uRKNS8EfsJlmZtCAR28Qqs8PiCYUWPlVg8YQy75Fws+eKF07Millyq9IUQ/5ejpEcleat2 0ymC11EyNuc1E9oMPcLiOGnsZUf1DHYtOX3Ul+SEBWueKIGNHoZ8/l5ElE5vdRcGJdcmCGjL6Su j9ilbmewXaG55NwDgGZYVM32mkJNnffkUnGujChKAaxo3fmx7cebHaEKJLFL2z0zro4SycmO5Jn
 sjxa8ENjgEozigxjPr4VIEv+UOFTKaKAhA7lotRQODRZAPd4GAv54u3mdeRo3wamJR+BLcG3
X-Authority-Analysis: v=2.4 cv=Q+HS452a c=1 sm=1 tr=0 ts=68216660 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=3HDBlxybAAAA:8 a=t7CeM3EgAAAA:8 a=JvIdB4Z2PfN4shd601kA:9 a=laEoCiVfU_Unz3mSdgXN:22
 a=FdTzh2GWekK77mhwV6Dw:22
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_01,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 phishscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505120031

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 86a1471d7cde792941109b93b558b5dc078b9ee9 ]

The delete set command does not rely on the transaction object for
element removal, therefore, a combination of delete element + delete set
from the abort path could result in restoring twice the refcount of the
mapping.

Check for inactive element in the next generation for the delete element
command in the abort path, skip restoring state if next generation bit
has been already cleared. This is similar to the activate logic using
the set walk iterator.

[ 6170.286929] ------------[ cut here ]------------
[ 6170.286939] WARNING: CPU: 6 PID: 790302 at net/netfilter/nf_tables_api.c:2086 nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.287071] Modules linked in: [...]
[ 6170.287633] CPU: 6 PID: 790302 Comm: kworker/6:2 Not tainted 6.9.0-rc3+ #365
[ 6170.287768] RIP: 0010:nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.287886] Code: df 48 8d 7d 58 e8 69 2e 3b df 48 8b 7d 58 e8 80 1b 37 df 48 8d 7d 68 e8 57 2e 3b df 48 8b 7d 68 e8 6e 1b 37 df 48 89 ef eb c4 <0f> 0b 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 0f
[ 6170.287895] RSP: 0018:ffff888134b8fd08 EFLAGS: 00010202
[ 6170.287904] RAX: 0000000000000001 RBX: ffff888125bffb28 RCX: dffffc0000000000
[ 6170.287912] RDX: 0000000000000003 RSI: ffffffffa20298ab RDI: ffff88811ebe4750
[ 6170.287919] RBP: ffff88811ebe4700 R08: ffff88838e812650 R09: fffffbfff0623a55
[ 6170.287926] R10: ffffffff8311d2af R11: 0000000000000001 R12: ffff888125bffb10
[ 6170.287933] R13: ffff888125bffb10 R14: dead000000000122 R15: dead000000000100
[ 6170.287940] FS:  0000000000000000(0000) GS:ffff888390b00000(0000) knlGS:0000000000000000
[ 6170.287948] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6170.287955] CR2: 00007fd31fc00710 CR3: 0000000133f60004 CR4: 00000000001706f0
[ 6170.287962] Call Trace:
[ 6170.287967]  <TASK>
[ 6170.287973]  ? __warn+0x9f/0x1a0
[ 6170.287986]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.288092]  ? report_bug+0x1b1/0x1e0
[ 6170.287986]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.288092]  ? report_bug+0x1b1/0x1e0
[ 6170.288104]  ? handle_bug+0x3c/0x70
[ 6170.288112]  ? exc_invalid_op+0x17/0x40
[ 6170.288120]  ? asm_exc_invalid_op+0x1a/0x20
[ 6170.288132]  ? nf_tables_chain_destroy+0x2b/0x220 [nf_tables]
[ 6170.288243]  ? nf_tables_chain_destroy+0x1f7/0x220 [nf_tables]
[ 6170.288366]  ? nf_tables_chain_destroy+0x2b/0x220 [nf_tables]
[ 6170.288483]  nf_tables_trans_destroy_work+0x588/0x590 [nf_tables]

Fixes: 591054469b3e ("netfilter: nf_tables: revisit chain/object refcounting from elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[fixed conflicts due to missing commits
 0e1ea651c9717ddcd8e0648d8468477a31867b0a ("netfilter: nf_tables: shrink
 memory consumption of set elements") and
 9dad402b89e81a0516bad5e0ac009b7a0a80898f ("netfilter: nf_tables: expose
 opaque set element as struct nft_elem_priv") so we pass the correct types
 and values to nft_setelem_active_next() + nft_set_elem_ext()]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 07fdd5f18f3c..211d67dc8e28 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6650,6 +6650,16 @@ void nft_data_hold(const struct nft_data *data, enum nft_data_types type)
 	}
 }
 
+static int nft_setelem_active_next(const struct net *net,
+				   const struct nft_set *set,
+				   struct nft_set_elem *elem)
+{
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+	u8 genmask = nft_genmask_next(net);
+
+	return nft_set_elem_active(ext, genmask);
+}
+
 static void nft_setelem_data_activate(const struct net *net,
 				      const struct nft_set *set,
 				      struct nft_set_elem *elem)
@@ -9881,8 +9891,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			nft_setelem_data_activate(net, te->set, &te->elem);
-			nft_setelem_activate(net, te->set, &te->elem);
+			if (!nft_setelem_active_next(net, te->set, &te->elem)) {
+				nft_setelem_data_activate(net, te->set, &te->elem);
+				nft_setelem_activate(net, te->set, &te->elem);
+			}
 			if (!nft_setelem_is_catchall(te->set, &te->elem))
 				te->set->ndeact--;
 
-- 
2.34.1

