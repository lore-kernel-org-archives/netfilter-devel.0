Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A78DA3BB138;
	Wed,  8 Jul 2026 05:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783488665; cv=none; b=ZrqRLynNmsc06UQZBWPv7P5/WqhlCTZ1A0lAABOoSkhAMRQGhrYmtYPs81NEM5vDDBv2XPkCzPLdRcAejVJNctyP/yrrXGPoIEv6NkfSQcsld2t1OjhBjL7kWijLdPiG23FmVqxRzqFZ+QVmD7PO/Fn8kE7dt5IYWbWQgByxBA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783488665; c=relaxed/simple;
	bh=GUjit2YTzZhJozwftDn8U/tKWzvCKxfMqtwIw36YdDE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=J3hAxU05N2sjEEv7Z2tU1deA9pJtr/+2gyxuo8I00sXd7tRQv8LOt10xxvEv/8N3yB3qJYingaO5mpc4O1Ih/SL2hCkBF/KMMm5PlGNxlbTh434qkw5Jh1BPS5bk77PT+KOrhs4IrFxuYKzICT4UQLnG00jaq23sbXQ0xyNxOgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=JKFLS0Fv; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="JKFLS0Fv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:Content-Type:
	Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	Content-Transfer-Encoding:Message-Id:References:To; bh=zS/AaYZRL
	DGNhDHjzwOvNEYFJ4rEMVLDHc6bZcDTxTA=; b=JKFLS0FvyGh1EZ+C7JhjhuVgN
	T/4NXo62934pRkCPPjVp8Rm8JFVFjyGi4Q96DaQj7jT7oVSK2uMRQzdjpUP+LvHT
	wBj2aSkpFEOOR9GbCHBDgAzlAhFyOf+wW4Bz91H29ewtnzhYb9T68wI85kDTvH/i
	lZerMk/7AAPELFfbvI=
Received: from smtpclient.apple (unknown [211.102.241.101])
	by web4 (Coremail) with SMTP id ywQGZQB3i6CB4E1qZLnSAg--.41268S2;
	Wed, 08 Jul 2026 13:30:41 +0800 (CST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.8\))
Subject: Re: [PATCH nf] netfilter: nf_conncount: fix zone comparison in tuple
 dedup
From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
In-Reply-To: <ak0UDVc4gZbfzrtM@strlen.de>
Date: Wed, 8 Jul 2026 13:30:31 +0800
Cc: netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 coreteam@netfilter.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
 Ao Wang <wangao@seu.edu.cn>,
 Xuewei Feng <fengxw06@126.com>,
 Qi Li <qli01@tsinghua.edu.cn>,
 Ke Xu <xuke@tsinghua.edu.cn>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E7AB1D22-A7EF-4401-A2E7-08C97D9868E6@mails.tsinghua.edu.cn>
References: <20260706114820.74006-1-zhaoyz24@mails.tsinghua.edu.cn>
 <ak0UDVc4gZbfzrtM@strlen.de>
To: Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3826.700.81.1.8)
X-CM-TRANSID:ywQGZQB3i6CB4E1qZLnSAg--.41268S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw4xXrWUCF4rWry3Ww45Wrg_yoW8AryDpw
	4Fg3ySyF4kJrnIyF97ZrnrA3W8trsrtF1fJr1UA3y7C3Z0vF93t3yxG3W3CayDuFyDJF1S
	qFy5XF95u3Z09rJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wrylc2xSY4AK67
	AK6r4rMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRRnNVPUU
	UUU==
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAgECAWpNfR6UyQABsY

Hi Florian,

> On Jul 7, 2026, at 22:58, Florian Westphal <fw@strlen.de> wrote:
>=20
> Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn> wrote:
>> The "already exists" dedup logic in __nf_conncount_add() decides
>> whether a connection has already been counted and can be skipped =
instead
>> of incrementing the connlimit count.  It compares the conntrack zone =
of a
>> list entry with the zone of the connection being added using
>> nf_ct_zone_id() and nf_ct_zone_equal(), passing conn->zone.dir or
>> zone->dir as the direction argument.
>=20
> Right, thats bogus.
>=20
>> @@ -211,8 +220,10 @@ static int __nf_conncount_add(struct net *net,
>> /* Not found, but might be about to be confirmed */
>> if (PTR_ERR(found) =3D=3D -EAGAIN) {
>> if (nf_ct_tuple_equal(&conn->tuple, &tuple) &&
>> -    nf_ct_zone_id(&conn->zone, conn->zone.dir) =3D=3D
>> -    nf_ct_zone_id(zone, zone->dir))
>> +    nf_ct_zone_id(&conn->zone,
>> +  nf_conncount_zone_dir(&conn->zone)) =3D=3D
>> +    nf_ct_zone_id(zone,
>> +  nf_conncount_zone_dir(zone)))
>=20
> Should this be a simpler:
>=20
>                                if (nf_ct_tuple_equal(&conn->tuple, =
&tuple) &&
> -                                   nf_ct_zone_id(&conn->zone, =
conn->zone.dir) =3D=3D
> -                                   nf_ct_zone_id(zone, zone->dir))
> +                                   nf_ct_zone_equal(&conn->zone, =
&zone), IP_CT_DIR_ORIGINAL)
>=20
> ?
>=20
> The tuple is always the 'original' direction, so it would follow that
> we should not care about reply zone dir.
>=20
> Also see:
> =
https://sashiko.dev/#/patchset/20260706114820.74006-1-zhaoyz24%40mails.tsi=
nghua.edu.cn

Thank you for pointing out this.

We have published a v2 patch following your suggestions:

=
https://lore.kernel.org/netfilter-devel/20260708052730.18354-1-zhaoyz24@ma=
ils.tsinghua.edu.cn/


Thanks,
Yizhou=

