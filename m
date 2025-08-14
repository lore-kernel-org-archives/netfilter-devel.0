Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8432FC889;
	Thu, 14 Aug 2025 12:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755173314; cv=none; b=aZS9xHp1ZVi0jUX67V6uAdYLNQArN3ph6g9E3lfpTxVOr+o7vyqwjk672naPVVl+qim90MXPAcuHYXWkf3az+5kMz0lOCY44aLaUbtficcVa8HtddygTjRMZqlDpLmTiTdlZ5aH/GmCO89uA0nRns+8gIyMzxwv1r4JMiejdRQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755173314; c=relaxed/simple;
	bh=Zp+9iiZ8OmqOd3O74YAeJkbs/IG4zmomu8VO+SxiSZc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=REn+7pK74jhbFZB3DdqwmGCHcdYlYGfkdoFM4CbZXycsr/WUc/FVMsuEIZUPOPbhf8sqsEgiQmVUB62hIulGZpQf2XhjL+JX2TXu0RIXEfj596gUx8mEU6i0jdzyeVj/KZycSXarvc8Tp4rhW3XdYNJmwOZ6xvMmepz922PLb04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c2kR472b2zvX34;
	Thu, 14 Aug 2025 20:03:28 +0800 (CST)
Received: from kwepemk200012.china.huawei.com (unknown [7.202.194.78])
	by mail.maildlp.com (Postfix) with ESMTPS id D76951402DA;
	Thu, 14 Aug 2025 20:08:28 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 kwepemk200012.china.huawei.com (7.202.194.78) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 14 Aug 2025 20:08:27 +0800
From: gaoxingwang <gaoxingwang1@huawei.com>
To: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>, <bridge@lists.linux.dev>,
	<netfilter-devel@vger.kernel.org>, <idosch@nvidia.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>
CC: <yanan@huawei.com>, <xuchunxiao3@huawei.com>, <huyizhen2@huawei.com>
Subject: netfilter: br_netfilter:NS packet was incorrectly matched by the nftables rule 
Date: Thu, 14 Aug 2025 20:07:53 +0800
Message-ID: <20250814120753.1374735-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200012.china.huawei.com (7.202.194.78)

Hello,everyone:
In my test case, the container (with net.bridge.bridge-nf-call-ip6tables=1 set) attempts
to ping the host's IPv6 address through a bridged network. Simultaneously, tcpdump is used to monitor
the bridge, and it is observed that the ping fails.

The direct cause of the ping failure is that the NS packet matches the "ct state invalid drop"
rule in nftables and is therefore discarded.

The commit 751de2012eafa4d46d80 introduced a modification to bridge traffic handling. When the bridge
is in promiscuous mode, it resets the conntrack state of the packets. 
>	if (promisc) {
>		nf_reset_ct(skb);
>		return NF_ACCEPT;
>	}
IPv6 NS packets are untracked by default.When an IPv6 NS packet passes through the bridge and the bridge
is in promiscuous mode, the conntrack state of the packet is reset. If there is a firewall rule
such as "ct state invalid drop," the IPv6 NS packet will be deemed invalid and dropped, leading to
a ping failure issue.

Is this a bug, or is there an issue with my analysis? 
Thanks if anyone can reply!
