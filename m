Received: from mail-pj2-f39.google.com (mail-pj2-f39.google.com [74.125.227.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8BF44C66C
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Oct 2026 08:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.167
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790930673; cv=none; b=M9/ANkeOf09taIR2cEWH3mVj2KKTW4cc1jiNJDIN2lEGQcpNi4Ub1GMEZw9LDg1sWF0IKsjQkfxKbYs1zWjEE88HHOCZS33YpAvlfSgKCoX+IgvgkHp7Uq/oKunWqPiaYtYM3CdhbADcfaEhcKQ2qBe9RoMOtHwMKPP9ybPLDZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790930673; c=relaxed/simple;
	bh=1pibEHoTL/Gr2tdOWpefVzEujKb2sS9JDzClfzKcDFw=;
	h=From:To:Cc:Subject:Date:Message-Id; b=eZgRpBO5GyEDkf7UIwY/qoH3IMck657kzRzPkiQg98lJDCKCLRQsPY9iqVIX+B30LO9L7z8SuXKIxPtBSlo8ud3p1cRh8pz+AVMyTX4aCyXwKhCXwZ8k1TjYB5EGjIeARPwZeoExEnJgn6uq6HK9tF5Nk+oypL0MSeDvDgFzQX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jGAhwZlE; arc=none smtp.client-ip=74.125.227.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGAhwZlE"
Received: by mail-pj2-f39.google.com with SMTP id d9443c01a7336-2e2d42b972bso23565395ad.3
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Oct 2026 01:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790930671; x=1791535471; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JSZRJIcpq240Ysw/4AkbveglKeQbRof//+itFjSwdtY=;
        b=jGAhwZlEJawQXQIe8bFywPLLP23PfZ2BRHpTMoOzjaKCVISnVy0fxyz9n1YUbmaA2y
         4hpYkk16DMl7vWFNkcawkZwqUz1RtPnxmT/wZkGUB2eG7iylzDrPzKnwEX0+cz5S/Yrf
         sM7b0+lmHobYL5fRWpr86tojIJEwTby3waGy1bZhwVTe8KYWeiw79txNa6+Z/xNV+AW2
         N8jpntIEoOJR0K8Xdy457OFZsBdcHXloVJ19K50UrezpqTOlSADI/tEjEKnm7+JNTQDi
         jBLsL836b8eXuzwn973Pt8u6oKRbWPpWm4t+d74yz5Xl4X8EqxfXqKL0cYc8luHGJnY9
         ibkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790930671; x=1791535471;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JSZRJIcpq240Ysw/4AkbveglKeQbRof//+itFjSwdtY=;
        b=Upaly4/CLetZ+WVDvSFIVV+D5IhlhU/YXo41l7WU7ifMQIFD08LZ4kkMuEhfoa7nVQ
         gQ2rm97B6Im+yIf47gOz7tfWdO6Zc6gaJux+wmv0K/Rp6hAALvIGnl6XiKmL+S7u8C6K
         e984kwwhDVP7GCqeWLPO0ZLoLpdokjOsiuPpxuJCiXGxGQ2O3+Inq/qUEpGoVZXFqCDX
         mJjsp0177sJgRP6NsoqpcrRqlcCHyCkmBcFi/gV3bnYI637n3sJ8vIEWjUDIrjWTjJNP
         Ufi3pI184FgJ72hopvr61mGXhzrVuUwhyH6f4Cwc6X+Ezyhgi7FhstQzXwz3yiubjNV2
         fM9A==
X-Gm-Message-State: AFq9FYLYPNl4vKXyFU7s228rCRrGDJikNRniDzFGbTmFtAR1ttuAVYEA
	4U2Ui9mdggI9VbMoMU2gAgcJb8OPWkGFLJl8CHSCAifHUoDJ38ob0vrWkZreEw==
X-Gm-Gg: AYBFou2WkFGbCABhBvkKb4r/kJ37RrWp5fkc1UblzKLqqQ9coLHxHUoDCcXFvBBSgAs
	ZIaWs5OUq7QJl60grDJlrfgcJ4uEy5zvjFGA1ZZcGXMISkWkjd2pGf9u3GSq7YLfZOafQJen1di
	I4kWsPhl6OJS1mq/jcrbVlpbEndzR2aWwE7T1t7ccwt2pvfcbOFwZdFo1wNbyjyugvrXMTt/CxQ
	Lrihet/JAQFbHkyhI1aNQS8TT/BQNCd3VIX27tkSF7PV09Zh5rj3j6KmhwtVwUozQE1+0anoJJk
	ps6eVoDr23xni+K27xyoq69200M75eClxVMTy34idup0KZUIsEGJJA00geAEpfxtn8lM0pBE1LY
	mlVe90+xhS4TGxLVmj+ZptWGUnyWNPq3pAxsoyZlt/qTu/YPx8v7Z/VFKuMwbXBuQZwPBEWlInr
	mHGykVyphZ9BYaA4ShYJ633kUkx+OdizTExyojDappBi0p9rs/KFMAsn436tSoKOPxeWc6ymxj6
	92BxTADAQo=
X-Received: by 2002:a17:902:f690:b0:2df:8f19:5db8 with SMTP id d9443c01a7336-2e49b857e53mr17742415ad.59.1790930671364;
        Fri, 02 Oct 2026 01:44:31 -0700 (PDT)
Received: from tony-vm-18.04 ([112.65.88.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49e1f59efsm5432195ad.6.2026.10.02.01.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2026 01:44:30 -0700 (PDT)
From: Shuangfeng He <huangya90@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Shuangfeng He <huangya90@gmail.com>
Subject: [PATCH nf] netfilter: flowtable: use the vlan id, not the full tci, in the tuple key
Date: Fri,  2 Oct 2026 16:42:53 +0800
Message-Id: <20261002084253.28654-1-huangya90@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

nf_flow_tuple_encap() stores the skb vlan tag in the encap tuple id
using skb_vlan_tag_get(), which returns the unmasked TCI including
the 3 PCP priority bits. The flowtable entry, however, is programmed
by nf_dev_path_info() with vlan_dev_vlan_id(), a plain 12-bit VID.

When a NIC delivers RX vlan offload skbs with a non-zero priority
(an RTL9617C EPON ONU was observed handing over vid 818 skbs with
tci 0x6332, PCP 3), the runtime lookup key never matches the
programmed entry, so every packet misses the flow table and
software flow offload is silently defeated.

Mask both parse sites to the 12-bit VID so the lookup key matches
for any priority. The in-header variant has the same problem for
frames received with PCP != 0 on a non-offload path.

The egress side is unaffected: nf_flow_encap_push() restores tags
from the programmed tuple id, which never carried priority bits.

Measured on an RTL9617C ONU (PPPoE over VLAN 818 WAN, NATed 6-flow
download over a 1G EPON line), before -> after:

  download throughput      377 Mbps -> 936 Mbps
  CPU0 %soft at that rate    91.5%  ->  70.9%

Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Shuangfeng He <huangya90@gmail.com>
---
 net/netfilter/nf_flow_table_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index c8c29a9a1684..2dec15d402ca 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -170,14 +170,14 @@ static void nf_flow_tuple_encap(struct nf_flowtable_ctx *ctx,
 	int i = 0;
 
 	if (skb_vlan_tag_present(skb)) {
-		tuple->encap[i].id = skb_vlan_tag_get(skb);
+		tuple->encap[i].id = skb_vlan_tag_get_id(skb);
 		tuple->encap[i].proto = skb->vlan_proto;
 		i++;
 	}
 	switch (skb->protocol) {
 	case htons(ETH_P_8021Q):
 		veth = (struct vlan_ethhdr *)skb_mac_header(skb);
-		tuple->encap[i].id = ntohs(veth->h_vlan_TCI);
+		tuple->encap[i].id = ntohs(veth->h_vlan_TCI) & VLAN_VID_MASK;
 		tuple->encap[i].proto = skb->protocol;
 		offset += VLAN_HLEN;
 		break;
