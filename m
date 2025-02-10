Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285B223323;
	Mon, 10 Feb 2025 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739192785; cv=none; b=jUncAnYhna57J9R/2gjo1WAoWqlINIcAXwwZbh+ELisaYtLxWCIDO0Sem8m4Y5/xU3oJzJbgwdRtIC3bxDzBZmmmODvHBIk++FmAm3O/2Rj9R46iCKkwOSWEiD8Yb9a32YqNmdLMIEmE3CbceQjAzyHalXpqbN+8V2TroWv4Dsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739192785; c=relaxed/simple;
	bh=lGlDCciVjiUxQPcUI4Jw2a370ATxZ9mi47m7J1PwXT8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=m8DFCBSEP1A4fwgcn7A8hX+cno85ArYB4Pm8XKpmU0ZZnPGHEuJyndKvnfUKGWp1qPq+58r/ueEz4q7EOSwVczmRfAj+0a2QyxmaLVo0boGDzokUYiheZD512qGQVm/HY0mJeQ/leQ1WH4uoSfHAFmywJgUtQMsgTs3MlAQ/xf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Ys4Vd4dGZz1ltc3;
	Mon, 10 Feb 2025 21:02:33 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id D111518001B;
	Mon, 10 Feb 2025 21:06:12 +0800 (CST)
Received: from kwepemn500013.china.huawei.com (7.202.194.154) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Feb 2025 21:06:12 +0800
Received: from kwepemo500008.china.huawei.com (7.202.195.163) by
 kwepemn500013.china.huawei.com (7.202.194.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 10 Feb 2025 21:06:12 +0800
Received: from kwepemo500008.china.huawei.com ([7.202.195.163]) by
 kwepemo500008.china.huawei.com ([7.202.195.163]) with mapi id 15.02.1544.011;
 Mon, 10 Feb 2025 21:06:12 +0800
From: mengkanglai <mengkanglai2@huawei.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@netfilter.org>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Yanan (Euler)" <yanan@huawei.com>, "Fengtao (fengtao, Euler)"
	<fengtao40@huawei.com>, "gaoxingwang (A)" <gaoxingwang1@huawei.com>
Subject: ftp ipvs connect failed in ipv6
Thread-Topic: ftp ipvs connect failed in ipv6
Thread-Index: Adt7u90tPuI4P4Z+R9u0e87z5R2gbQ==
Date: Mon, 10 Feb 2025 13:06:11 +0000
Message-ID: <e1527ca5f8f84be09022859f5e33b584@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello:
I found a problem with ftp ipvs.
I create 3 virtual machine in one host. One is the FTP client, the other is=
 the ipvs transition host, and the other is the FTP server.
The ftp connection is successful in ipv4 address,but failed in ipv6 address=
.
The failure is tcp6 checksum error in tcp_dnat_handler(tcp_dnat_handler-> t=
cp_csum_check->csum_ipv6_magic),
I trace back where skb->csum is assigned and found skb->csum is assigned in=
 nf_ip6_checksum in case CHECKSUM_NONE(ipv6_conntrack_in=3D> nf_conntrack_i=
n =3D> nf_conntrack_tcp_packet =3D> nf_ip6_checksum).
I don't know much about ipv6 checksums,why ipv6 nf_conntrack assign skb->cs=
um but check error in ipvs tcp_dnat_handler?
Best wishes!

