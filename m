Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F3C318EC4
	for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2026 11:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778068260; cv=none; b=l+kMw8e7ui0AmScNhDipMOUSYbSmbL9Ky/ms/+4V5ajyFVw7JAFsIwnloDFj5Mx7CaVl2YDFNWxyZpsHlx557B3RsdyZ3ZDPrPP9NuDmeqWfpSxugOG7HT4zsAuzQBEqkg4ZzTeqQTV5liWQZyvMySEssTeWs3Wqxs9QZtd9bs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778068260; c=relaxed/simple;
	bh=ZBhRJlRvhHwOxsBveV9/2myckVu9d7QkFIocuHoeGoo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tsRgc63QjxdkhrdmLYxChXHfcZWC7A2qHKBjLEnYd34eLHDToPCqsnpFKfMYQUrenxxxrcfttQA2ddKAyBGW5oVmx//0VRzUBB3cQvSmM/Tk6dYTrLjh2rldCqv1QedA4QO7FXuOIqAVfgkUVbLV0froU3CNqMOUcg4h+xReGBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=40NhFgcY; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="40NhFgcY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vgAB32Cl/HRPnaEedloLwfof9vPAvxAYYFXMsjmfFJY=;
	b=40NhFgcY50mXdYoCGEB75VFk55KSNH0dZocNqBgRLBzqfl/bpva/u2V+akEZxxY4atdGLJ8Mx
	S1hkruGjrhDTpkfoq0VeDnrr7JFxCu4beik8UEL3UEbLlpHMTVc74qFrCjqonGuCLyXgdpOIB0q
	1BO9VGDC3zDk4eLAfmWVpKM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4g9YSh4F3wz1prMX;
	Wed,  6 May 2026 19:44:20 +0800 (CST)
Received: from kwepemj500018.china.huawei.com (unknown [7.202.194.48])
	by mail.maildlp.com (Postfix) with ESMTPS id 8146E4056D;
	Wed,  6 May 2026 19:50:54 +0800 (CST)
Received: from huawei.com (10.50.85.128) by kwepemj500018.china.huawei.com
 (7.202.194.48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 6 May
 2026 19:50:53 +0800
From: Li Xiasong <lixiasong1@huawei.com>
To: <netfilter-devel@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, <coreteam@netfilter.org>, <yuehaibing@huawei.com>,
	<zhangchangzhong@huawei.com>, <weiyongjun1@huawei.com>
Subject: [PATCH nft 0/2] netfilter: fix nf_ct_expect_alloc() reference leaks
Date: Wed, 6 May 2026 20:16:16 +0800
Message-ID: <20260506121618.578443-1-lixiasong1@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj500018.china.huawei.com (7.202.194.48)

this series fixes two nf_ct_expect_alloc() reference leaks in netfilter.

Patch 1 fixes an error path leak in SIP REGISTER handling:
when helper lookup fails after expectation allocation, the function
returns without dropping the local reference.

Patch 2 fixes a leak in nft_ct expectation object evaluation:
the local reference obtained from nf_ct_expect_alloc() is never put
after nf_ct_expect_related(), regardless of success or failure.

Li Xiasong (2):
  netfilter: nf_conntrack_sip: fix missing expect put in REGISTER path
  netfilter: nft_ct: fix missing expect put in obj eval

 net/netfilter/nf_conntrack_sip.c | 4 +++-
 net/netfilter/nft_ct.c           | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.34.1

