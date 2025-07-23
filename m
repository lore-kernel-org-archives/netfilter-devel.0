Received: from sg-1-34.ptr.blmpb.com (sg-1-34.ptr.blmpb.com [118.26.132.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B2926E158
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 06:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753253044; cv=none; b=F95V3WYCIbNdpis80TeEyNxysabjYINUkL1HMW6Rn6+fYao+cOqGjbxT64XbKHC0ssf5ttNelFVycihn5UHafIiFN71nr/cnmwaqVGPpvdaWy/veISg9/Wj8lRgtoz4RfZizg2aKARwWJrDQJSXYC3Wcgz97ov0H7SsiD5iovqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753253044; c=relaxed/simple;
	bh=LJ2lQwU8X8H/QKiwz6yUSfxX4NYqibZ3YZ1Uy2oITiU=;
	h=Subject:Mime-Version:Date:Message-Id:From:To:Content-Type; b=sY41aChcUc7hbMrwHVlBDZxrzefvsQqF/mOCbDxUhMGOUzW7xcNCdZSIUughWtRlRwdWdFHM0nBPAAf9HYn0ySrRsoa/iex1XoGkur+iw+Puk4PuVRiuJ7T1e+UCBYVCm9263G3oq/BZA4zE9FsezCxq0ysE/lU5+8OTIk66XX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zslab.cn; spf=pass smtp.mailfrom=zslab.cn; dkim=pass (2048-bit key) header.d=zslab.cn header.i=@zslab.cn header.b=j0tqEHr0; arc=none smtp.client-ip=118.26.132.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zslab.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zslab.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zslab.cn header.i=@zslab.cn header.b="j0tqEHr0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2503270945; d=zslab.cn; t=1753253024; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Xn74i0Kv3pKizZeE30vonKzcSyEbH1Ys9lNQXoS4524=;
 b=j0tqEHr0Ru0ZUcnzve6h91T62WDpLe4/XxEsdgT12UN1p+07FIiimHICf62L+ngiZElpjJ
 bfbjSX2zdkD7RLDLh7UE5+UbeUrE//I8r7lVx1tc3L9YejWqIenqKI05ejaXbmE7CaYpts
 DIEEEbxVoknmighkHp7ddRwN7POyiBEc0/wRfEsxlF/7v4vNzkTNK9iWRgEggpb7DjstZA
 QOg4chxNLlgi/8zlvYDXaXv6shKTajLU+eccUmVWNHZG8/oafNTikdw1kqWSvQFZ3nxV1d
 5yDHS21W1U2d0IOQKQ55HRJvu1XWJeJo24sS/51BYcMegJySunMwh9F7BCmoGg==
Subject: Subject: [nftables] Bug: dup rule fails to modify MAC address on netdev/ingress hook
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26880849f+2f7940+vger.kernel.org+zs@zslab.cn>
Date: Wed, 23 Jul 2025 14:43:40 +0800
Message-Id: <2025072314434064423510@zslab.cn>
X-Has-Attach: no
From: "zs@zslab.cn" <zs@zslab.cn>
X-Guid: 96A081B9-6152-4CBE-85C8-F958F96391C5
X-Mailer: Foxmail 7.2.25.398[cn]
X-Original-From: "zs@zslab.cn" <zs@zslab.cn>
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Received: from KLMIT ([58.205.191.254]) by smtp.feishu.cn with ESMTPS; Wed, 23 Jul 2025 14:43:42 +0800
X-Priority: 3

Hello netfilter/nftables developers,

I've encountered a potential bug in nftables behavior when using the `dup` statement in the netdev/ingress hook to modify the destination MAC address. The issue only occurs when a single rule is defined, but works correctly when two identical rules are added.

### Environment:
- OS: openEuler 24.03 LTS-SP2
- Kernel: 6.6.0-98.0.0.103.oe2403sp2.x86_64
- nftables versions tested: v1.0.8 and v1.1.3
- Interfaces: gretap10 (ingress hook), output to eth2

### Steps to Reproduce:
nft add table netdev mirror_nogre
nft add chain netdev mirror_nogre ingress \
    '{ type filter hook ingress device "gretap10" priority 0; }'
nft insert rule netdev mirror_nogre ingress position 0 \
    dup to eth2 ether daddr set BC:24:11:C0:CE:EB

Observe with:
tcpdump -ni eth2 -e

### Observed Behavior:
- With one rule: MAC address is not modified (remains original)
- With two identical rules: MAC is correctly set to `bc:24:11:c0:ce:eb`

### Expected Behavior:
A single `dup` rule should duplicate and modify the MAC address.

### Ruleset Example (working case with 2 rules):
table netdev mirror_nogre {
chain ingress {
type filter hook ingress device "gretap10" priority filter;
policy accept;
dup to "eth2" ether daddr set bc:24:11:c0:ce:eb
dup to "eth2" ether daddr set bc:24:11:c0:ce:eb
}
}

### Suspected Cause:
There may be a bug in how `dup` and action statements (like `ether daddr set`) are handled in netdev/ingress hook when only one rule exists.

Best regards,
Zhang Sheng
Email: zs@zslab.cn






--------------



zs@zslab.cn
