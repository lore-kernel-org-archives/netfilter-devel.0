Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B9340DB29
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 07:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766449; cv=none; b=sz3DIvAuc5vbNlqm5p+FS3tAHQBFcot+lI71M2Sddbf5X5jpP6r+JTkQ5uD/3lZJKu2m4fqAW0kik5zdDVORS2AkxLZdmLCj3Pcny00dpTnNgiI1F7mTtGjfnqNpxrnkp3QNgTcTLlC3SirBB4VbM0HvskWBONRcDzW4KH2DnVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766449; c=relaxed/simple;
	bh=yagJzAETAF4TC2pRSdlDch5zUPhjR+z4M/nbHRlg9vQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=X+r3ezYMPhNgYt6aF6L7TXDYCACvHl7w3c4Bt3ezq+foG7aSsOXML3lVXj5fdAnclu0AL5u7tZI+rpfQvqdj3efZ9PVCJ2FgTHQ7ELB/fH6XQPuBCyNip7+NlRykNTUWjtJ88JaFy1yeUvkk3i3mSZvWeHRctvAHzM+aT1sI5Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=AsydXSqe; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=JmmuyVMm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AsydXSqe";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="JmmuyVMm"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68777J1j4161113
	for <netfilter-devel@vger.kernel.org>; Mon, 7 Sep 2026 07:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=BCeB2q39kGDNUzJWVGp367
	dKzfsU4Ljb97JBe37jcyk=; b=AsydXSqeRixpMaoIVj1h4B2ZDcov3KreYxAomN
	H9OEO/1qF1X3PW+XaY5E7AFHwwD4ewHsYtbw86JuHENHtjbL//1Vc1H0woS0jZlp
	V0HjM47ULHAuparY43HyQ+TTEEn93PwhE4UuKQmmfeQ9HBysW7m9xveXeslFI/TS
	vR7EmGYLMoknfE6Hy+wDN5D/xZtuMsMrXUKlm16M6wAImwa1y1PDvPHHNlNRsBE7
	pKfju2gSByU51Qw6JykPpKQggcGTE7OVjBGq1aKmFITP1uAO0JclyPGIKgdW8DTY
	pkSJtaJqunyP/aTivGgA2c44LGZ40fP95ARpE/UBWvcG2Npw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghfwjhg3m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 07:34:07 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-930b571432fso509223185a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 00:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788766446; x=1789371246; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BCeB2q39kGDNUzJWVGp367dKzfsU4Ljb97JBe37jcyk=;
        b=JmmuyVMm8ixtR+8BXNqJzWC8L5Hnb/xV7djha72vX0D3b9AFuZQHK8p1+cD1pjepPn
         2E8vhMS/xvV7zpKgiNBZjlnX9xjQMCNj7l+FDAJL2euu2HOOfxIKiKIgI2S/3Fl3P0y+
         uPR3l7w4iPNqlPYyAUdt3mGyGJUFgwJlRbhFjMvOdKDXatzPDPvbFs4dRzOFH1Pa23fN
         /gjAnKApOWlr9xuVHrdRN4+yliWDoPhQ2WJvLvbb6bxpG78CLPDCb5lu+DRIIDWW+MSD
         04gNV9gxvEofT6nEe92PeYxCFR+ig7shPDqq1ETT18Syf9mvTBq0nzHU081oyJYkrlIQ
         CP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766446; x=1789371246;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BCeB2q39kGDNUzJWVGp367dKzfsU4Ljb97JBe37jcyk=;
        b=EO9bTdmisAtee3yyWfp0iRXakY+yS6WL1Utq6tIUurrPaHnE872cVukWuJpMIOLwtM
         /Ua4MBJhbyTQKNOnwqLEH1NwVgRC6d2Qpmyr1d8iDrjXTAMhoJLknIWUmbkAtlkxxzCq
         aK0tgYSNEvG+gf871y+NnvWyH2xXPXtyMuXXdBnpmKLrFQkyqvy+BgCpxEijubrNbp1b
         MBQGGQwMUmxMxnShuIBh+N7T1VpJ58cjwa8W/cQF0truCE9bfO6d9Hjf+/hH/0N34c4N
         QkinWmjG8GLcKpf5Y5TKGdm+X2KjWneSq5n5M2JWwJQpUdreyKTeYSimS3gku7l5/79P
         zdqQ==
X-Gm-Message-State: AFuF++l1pbywcmMhgj+gTtdgcd+FfaGnaOwXSwBhqEShwOKBsqIzyp3Z
	17zN6I67yvQ3n6w1VO9z5M3H+wdJ5TlHLAhef0Mhjq7tDU2MBsTZN1KAJDh38O9AqBXQ2LKifGI
	kTW23KF+hrkXqxNTyyYM7PiFRGdgqIHGFwbn6I+WHAICp98S5LezQU9zn4ydmHJT4AgDQqsM=
X-Gm-Gg: AYBFou0gydaaX82+9YRNHLj9hdjMPz7RIVZK84R/1LcL71K8sK8P4QJ36VWf0YqZg6G
	YZd74VWjk0hOjbKZck5JNqNjJhtDuw3nd/QqDdeCUijQMCPuXOLkG+1PDDQ8gxKM7IZPtA6M5X8
	uU628qPw2NxIRFdgOad2RqSkr1aAjeiQKzb4Jzw11Aodpe57Ug4H1p2Xdc1hbpJnu2wfZB5VgAX
	+QrL1JSRZKXjuJHWmhkIkqqPkd3IwCCTSE9dE2yQFpWQ+B7sy63XrJZ77V/9zdhe+qyJ+qzx3KE
	IPn8hIbXXCsuLhpcJ2dH0NPET3g3a/pkd4fvbCMvfei/dH6Gk42JVEz4Tbn7c5GLxWkaIyN19yf
	ucw226JFznZMnrQ==
X-Received: by 2002:a05:620a:8393:b0:939:78da:5c2f with SMTP id af79cd13be357-93978da5d6amr1959837685a.43.1788766446254;
        Mon, 07 Sep 2026 00:34:06 -0700 (PDT)
X-Received: by 2002:a05:620a:8393:b0:939:78da:5c2f with SMTP id af79cd13be357-93978da5d6amr1959834485a.43.1788766445826;
        Mon, 07 Sep 2026 00:34:05 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858ab73c2bsm24990405f8f.22.2026.09.07.00.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:34:04 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Subject: [PATCH nf-next v2 0/6] net: netfilter: preliminary support for
 IPv4 over IPv6 and SIT flowtable offload
Date: Mon, 07 Sep 2026 09:33:35 +0200
Message-Id: <20260907-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v2-0-7c6ac1750725@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/52OQQ6CMBBFr0Jm7ZBSBMWV9zAsSp3KJKXFFgFDu
 LsNR3Dzk5+XvP83iBSYItyyDQLNHNm7VOQpA90r9yLkZ+oghaxFIwp0Bo31y6Q6SxgXVFqTRR5
 rHjHyhGMgywM7Fb5Y1WVlFInSlATJmJjh9Vh7QBI5WidoE+g5Tj58jxdzceC/BucCBV4knZuOr
 roszN3HmL8/ymo/DHkKaPd9/wGqP9Ch9gAAAA==
X-Change-ID: 20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-5635fae03f3e
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfX5vWHN7T+22xA
 5dCR3pxwN0N2ZaYUDeZQH9JoylxCwm86f3swOLDMLwVxKa5oxcHLBgv3/hXMSy4lMyt6SFjKrUs
 WAczYWtGR30owB6v8wzHuEig3gIQDpY=
X-Authority-Analysis: v=2.4 cv=NanWEWD4 c=1 sm=1 tr=0 ts=6a9e68ef cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=hjUsVgM4bzNdy_QoUQ0A:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-GUID: dGJnAC-Hz5NGsVtxfABWMKHpGRj8eL7s
X-Proofpoint-ORIG-GUID: dGJnAC-Hz5NGsVtxfABWMKHpGRj8eL7s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA4MCBTYWx0ZWRfXwD/OzDMFtLI0
 QkOx+1s7hxKd8FNMJsuKtKbk2H6KAFvzTpyCc+vXoawpPOjxxqQVwh9H5tcEnE3tbImxji/HQyW
 CzApq9snVN9UWYnsCrzorOI5ODv8TaTzX7oC7m8Bc2O9Au7MCR+9MVWEo4Muv9l8DQqRbuZCPvn
 VdWsu/ZH72G28I3sLSxlRjwi9IGDFnwnc3YuT5Nry+P2Przwu7qlZjU18kmTy2cE6RKl245b9bO
 UNEu8pqGwZlBqwvxNr43ypWMkC/V6r63mUT98iH3y0q79J2oPag2MFs37tHHLzm+n7h4NYN+YwN
 r2kFEMz7UgvGhFID3n6omirsBX/9HLGr0qLKn6NThJb6C4d7xGJMN+I58+fbLBvHhIeW+ISg0xr
 mvpax6DFPA2nV7luXwax6asjd7e2pRzPDf4ywUrPYzfFug0ak3ILPtilPpUeYHzv31j8RpPg/ju
 pWBrTbw7BB9gJEabm8Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_02,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070080

Introduce some preliminary changes needed to support flowtable offload
for IPv4 over IPv6 and SIT traffic.

---
Changes in v2:
- Fix dir configuration in nf_flow_offload_check_mtu() to compute tunnel
  MTU overhead.
- Link to v1: https://lore.kernel.org/r/20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-v1-0-72e49be8c31f@oss.qualcomm.com

---
Lorenzo Bianconi (6):
      net: netfilter: nf_flow_table: recognize IPv4/IPv6 in tunnel proto matching
      net: netfilter: nf_flow_table: set inner protocol when popping tunnel header
      net: netfilter: nf_flow_table: populate tunnel tuple regardless of inner protocol
      net: netfilter: add encap_proto to flow_offload_tunnel
      net: netfilter: nf_flow_table: refactor MTU check for tunnel offload
      net: netfilter: nf_flow_table: unify tunnel push for IPv4 and IPv6

 include/linux/netdevice.h             |   1 +
 include/net/netfilter/nf_flow_table.h |   1 +
 net/ipv4/ipip.c                       |   1 +
 net/ipv6/ip6_tunnel.c                 |   1 +
 net/netfilter/nf_flow_table_ip.c      | 201 ++++++++++++++++++++++------------
 net/netfilter/nf_flow_table_path.c    |   2 +
 6 files changed, 135 insertions(+), 72 deletions(-)
---
base-commit: 6ebcf5074cff0402730c6981d2397139fee6322d
change-id: 20260901-nf-flowtable-sw-accel-ip6ip-sit-preliminary-5635fae03f3e

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

