Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A557E2F5E
	for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2024 03:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717038162; cv=none; b=njZIu3KOrwrZX4h8SMU1pSh3w9unuVTHYLhx977OXjkBajrWMaluMUM+pr4dnYTkO2x2DW1T/rT3Ktcuiz56SnnmibaVOzrbXYnGRMflv30AsBxYymJYYv86gbJmx6280QWbKoI/JXEqM7wCqF9J3ogaCDmHd0rPfQ33IA9BJ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717038162; c=relaxed/simple;
	bh=IbAp2DjDAPK+mBGz8DdyS3u5isIOhO1OxqQZk4N3RW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Elc5pFzASbO91+5Dzcfk5fAawR5QqjsJAf34Kfe4nDyNgi6qr5ps5NCjtSDpXnwAzGKrIYeulk7ZyxxI92uIL+stfQ6Xq4cGVy8ixi7GHhI73R4ubPW/Rz7tb3z8PTqr0k/aPdQcy1n6qKvrkNR/tCK2gN+MDTfn7H5EOGoxRp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VqWD04fcxzwQfZ;
	Thu, 30 May 2024 10:58:40 +0800 (CST)
Received: from kwepemd100012.china.huawei.com (unknown [7.221.188.214])
	by mail.maildlp.com (Postfix) with ESMTPS id EE1D814037E;
	Thu, 30 May 2024 11:02:28 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemd100012.china.huawei.com (7.221.188.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 30 May 2024 11:02:28 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Thu, 30 May 2024 11:02:28 +0800
From: wangyunjian <wangyunjian@huawei.com>
To: Florian Westphal <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org"
	<kadlec@netfilter.org>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, xudingke <xudingke@huawei.com>
Subject: RE: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Thread-Topic: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Thread-Index: AQHasWoiYMZX4xQfcUOwinIB0t9RfrGtl0IAgAGBBoA=
Date: Thu, 30 May 2024 03:02:28 +0000
Message-ID: <d6a7fe4b75b14cdda1a259c2acb10766@huawei.com>
References: <1716946829-77508-1-git-send-email-wangyunjian@huawei.com>
 <20240529120238.GA12043@breakpoint.cc>
In-Reply-To: <20240529120238.GA12043@breakpoint.cc>
Accept-Language: zh-CN, en-US
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

> -----Original Message-----
> From: Florian Westphal [mailto:fw@strlen.de]
> Sent: Wednesday, May 29, 2024 8:03 PM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: netfilter-devel@vger.kernel.org; pablo@netfilter.org; kadlec@netfilte=
r.org;
> kuba@kernel.org; davem@davemloft.net; coreteam@netfilter.org; xudingke
> <xudingke@huawei.com>
> Subject: Re: [PATCH net] netfilter: nf_conncount: fix wrong variable type
>=20
> Yunjian Wang <wangyunjian@huawei.com> wrote:
> > 'keylen' is supposed to be unsigned int, not u8, so fix it.
>=20
> Its limited to 5, so u8 works fine.

Currently, it does not affect the functionality. The main issue is that cod=
e
checks will report a warning: implicit narrowing conversion from type
'unsigned int' to small type 'u8'.
