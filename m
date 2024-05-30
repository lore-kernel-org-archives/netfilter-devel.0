Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A20515ADBE
	for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2024 09:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717062130; cv=none; b=QGMk9nK++ZG9CF6kimqsOQFO4Guki9W93bXNMEqb2mhFE2bivJw8QGNz7S5qafD/a1Sfc9wHWGLPgdIgOm5znIKSUB7I4EAuJUqWXJm3U8XbEusePmxmWAonfRLCeKcaKMEWuQVvV2bt8faqOq2Ehs+VzDJCaMFnOIxcZzNUQ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717062130; c=relaxed/simple;
	bh=9DvXWuqkb6fy8RDMMgTTHbeF7u86Manur4zirADnJWI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NxcbnRTJ9mHcKlPUUQ//EDGrfOqXWb1pyyw7CaqwrDQlCohTMEXHKAvYU0bU6TkuEnkb5ZkBcR6X7jiksjQkXGthflb3C6WrDtXeOBNwVw1QjUtHkAZp7XCBaMerpY+WTVAPH9kO5HDIIEVv1LhHo8FBLvtO9t4SsJbfPzvwxJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Vqh552LlhzwQRG;
	Thu, 30 May 2024 17:38:17 +0800 (CST)
Received: from kwepemd100011.china.huawei.com (unknown [7.221.188.204])
	by mail.maildlp.com (Postfix) with ESMTPS id 05498180080;
	Thu, 30 May 2024 17:42:06 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 kwepemd100011.china.huawei.com (7.221.188.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 30 May 2024 17:42:05 +0800
Received: from dggpemm500008.china.huawei.com ([7.185.36.136]) by
 dggpemm500008.china.huawei.com ([7.185.36.136]) with mapi id 15.01.2507.035;
 Thu, 30 May 2024 17:42:05 +0800
From: wangyunjian <wangyunjian@huawei.com>
To: Florian Westphal <fw@strlen.de>
CC: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org"
	<kadlec@netfilter.org>, "kuba@kernel.org" <kuba@kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, xudingke <xudingke@huawei.com>
Subject: RE: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Thread-Topic: [PATCH net] netfilter: nf_conncount: fix wrong variable type
Thread-Index: AQHasWoiYMZX4xQfcUOwinIB0t9RfrGtl0IAgAGBBoD//8tgAIAAisOg
Date: Thu, 30 May 2024 09:42:05 +0000
Message-ID: <fc77f3c83cd3470ba1678f48dcbd172c@huawei.com>
References: <1716946829-77508-1-git-send-email-wangyunjian@huawei.com>
 <20240529120238.GA12043@breakpoint.cc>
 <d6a7fe4b75b14cdda1a259c2acb10766@huawei.com>
 <20240530075220.GA19949@breakpoint.cc>
In-Reply-To: <20240530075220.GA19949@breakpoint.cc>
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
> Sent: Thursday, May 30, 2024 3:52 PM
> To: wangyunjian <wangyunjian@huawei.com>
> Cc: Florian Westphal <fw@strlen.de>; netfilter-devel@vger.kernel.org;
> pablo@netfilter.org; kadlec@netfilter.org; kuba@kernel.org;
> davem@davemloft.net; coreteam@netfilter.org; xudingke
> <xudingke@huawei.com>
> Subject: Re: [PATCH net] netfilter: nf_conncount: fix wrong variable type
>=20
> wangyunjian <wangyunjian@huawei.com> wrote:
> > > -----Original Message-----
> > > From: Florian Westphal [mailto:fw@strlen.de]
> > > Sent: Wednesday, May 29, 2024 8:03 PM
> > > To: wangyunjian <wangyunjian@huawei.com>
> > > Cc: netfilter-devel@vger.kernel.org; pablo@netfilter.org;
> kadlec@netfilter.org;
> > > kuba@kernel.org; davem@davemloft.net; coreteam@netfilter.org;
> xudingke
> > > <xudingke@huawei.com>
> > > Subject: Re: [PATCH net] netfilter: nf_conncount: fix wrong variable =
type
> > >
> > > Yunjian Wang <wangyunjian@huawei.com> wrote:
> > > > 'keylen' is supposed to be unsigned int, not u8, so fix it.
> > >
> > > Its limited to 5, so u8 works fine.
> >
> > Currently, it does not affect the functionality. The main issue is that=
 code
> > checks will report a warning: implicit narrowing conversion from type
> > 'unsigned int' to small type 'u8'.
>=20
> Then please quote the exact warning in the commit message and remove the
> u8 temporary variable in favor of data->keylen.

OK, I will update it. This is not a bugfix, only considered for net-next?

Thanks.
