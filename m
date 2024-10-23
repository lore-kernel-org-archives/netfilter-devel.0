Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FA325761;
	Wed, 23 Oct 2024 01:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729646930; cv=none; b=K2+2yf9IexVSNo/jOSRoHwCCjcv6/SkxSru1hJTt6nQgxhnxpIjcii3KnQBqfeQku3h9TVh65Cqq65HtpX8lj9Apq0Sqzs5BABYYQdR5AmcjKZ/acOYjCfvTRfFXGhmnpgW8aKBXKTRiFbLhFIWveeiuyiCyvtcPP5gbFCoSR30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729646930; c=relaxed/simple;
	bh=d3jGBGEh/9F0VnRHDTLvZTfB5LzLrNGeYHvvS1xOx7E=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bECVNmlCWYE9iuNxvrE47rsEyEkdLZSJCfTToHosrgOUs+5JJaIKo0V/S+RVfepS3e8HbGakDWTc1VjES19Se2fWisCQgfw/NrtGby18mRrvUUd1Oge/RM0ZErwCxzREGC76T5rjDmYhy0oQVUgAA9Gu0Nt+TogI8Kbp0u/J4N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XYBHG44SFz1j9xJ;
	Wed, 23 Oct 2024 09:27:22 +0800 (CST)
Received: from dggpemf200002.china.huawei.com (unknown [7.185.36.244])
	by mail.maildlp.com (Postfix) with ESMTPS id 136F7140392;
	Wed, 23 Oct 2024 09:28:45 +0800 (CST)
Received: from kwepemd100023.china.huawei.com (7.221.188.33) by
 dggpemf200002.china.huawei.com (7.185.36.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 23 Oct 2024 09:28:44 +0800
Received: from kwepemd100023.china.huawei.com ([7.221.188.33]) by
 kwepemd100023.china.huawei.com ([7.221.188.33]) with mapi id 15.02.1544.011;
 Wed, 23 Oct 2024 09:28:44 +0800
From: "dongchenchen (A)" <dongchenchen2@huawei.com>
To: Florian Westphal <fw@strlen.de>
CC: "pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org"
	<kadlec@netfilter.org>, "davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>, "kuba@kernel.org"
	<kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"kuniyu@amazon.com" <kuniyu@amazon.com>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, yuehaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH net] net: netfilter: Fix use-after-free in get_info()
Thread-Topic: [PATCH net] net: netfilter: Fix use-after-free in get_info()
Thread-Index: Adsk6sZPMNMF5ZGb10qFpGepfJJ/Fg==
Date: Wed, 23 Oct 2024 01:28:44 +0000
Message-ID: <8ca3f6271b0a4956b699e1444f7a06ad@huawei.com>
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

> Dong Chenchen <dongchenchen2@huawei.com> wrote:
> >  net/netfilter/x_tables.c | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c index
> > da5d929c7c85..359c880ecb07 100644
> > --- a/net/netfilter/x_tables.c
> > +++ b/net/netfilter/x_tables.c
> > @@ -1239,6 +1239,7 @@ struct xt_table *xt_find_table_lock(struct net *n=
et,
> u_int8_t af,
> >  	struct module *owner =3D NULL;
> >  	struct xt_template *tmpl;
> >  	struct xt_table *t;
> > +	int err =3D -ENOENT;
> >
> >  	mutex_lock(&xt[af].mutex);
> >  	list_for_each_entry(t, &xt_net->tables[af], list) @@ -1247,8 +1248,6
> > @@ struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
> >
> >  	/* Table doesn't exist in this netns, check larval list */
> >  	list_for_each_entry(tmpl, &xt_templates[af], list) {
> > -		int err;
> > -
> >  		if (strcmp(tmpl->name, name))
> >  			continue;
> >  		if (!try_module_get(tmpl->me))
> > @@ -1267,6 +1266,9 @@ struct xt_table *xt_find_table_lock(struct net *n=
et,
> u_int8_t af,
> >  		break;
> >  	}
> >
> > +	if (err < 0)
> > +		goto out;
> > +
> >  	/* and once again: */
> >  	list_for_each_entry(t, &xt_net->tables[af], list)
> >  		if (strcmp(t->name, name) =3D=3D 0)
>=20
> Proabably also:
>=20
> -  		if (strcmp(t->name, name) =3D=3D 0)
> +               if (strcmp(t->name, name) =3D=3D 0 && owner =3D=3D t->me)
>=20
Thank you very much for your suggestions!
V2 will be sent.
