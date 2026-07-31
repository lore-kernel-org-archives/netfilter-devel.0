Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD26840242B;
	Fri, 31 Jul 2026 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509947; cv=none; b=hSRTWWiyXxsrg4BXHe8EqEJOFHickEoXRWVp/vd0VEDK5GcXIoajgzT3uQOGC9zaEr4TpN3X1AoQMpfdWLxFfvm9eRoU4iga4eKRgW2C7Tj1bXH+iuL5TF35xRuTpF5IgPJsB6X5vZj1otY0ERqGthklM2qccezWsLdgHs2tn98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509947; c=relaxed/simple;
	bh=wHUAmpND+DI3KmeIldKd2YsRDR99VNDRNYR7EzHamuY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=QcfWl3VKrIPRtIH6L/NOgIPf7AhdGrCF7+YHDDzkF9pn/2KIZlrE5AUBH+RghlAy544ziJZd3I8N6WCMD9pwHBbe2Hj2Ugnqf9hJiuC0mAKhZ3qUlT3UIBoWIDxQG+DD8oqvY4+J76ufOIU+9KGRjJZngZSSGc6lGWKTmqVuz8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=XA/UA8Zh; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="XA/UA8Zh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:Content-Type:
	Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	Content-Transfer-Encoding:Message-Id:References:To; bh=wHUAmpND+
	DI3KmeIldKd2YsRDR99VNDRNYR7EzHamuY=; b=XA/UA8ZhTbrGoX46bRTCaQnJU
	pK2TZHHenRKblAHBd0sZOPl/yDGvHbR/4uD0e7zPC7vd9X8iuUEI63jx4lo4/Gfl
	dDGXyoXDh45UUE6jSjxoU4O0nB4u1UJYdcLPrYBiPLf3fI6miGG4tg1aUY7Sh5NM
	g+XbwryPmGm84NvMb4=
Received: from smtpclient.apple (unknown [106.111.19.240])
	by web1 (Coremail) with SMTP id yAQGZQB3F8cquGxq8yHfAA--.53903S2;
	Fri, 31 Jul 2026 22:58:51 +0800 (CST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH nf] netfilter: conntrack: sctp: verify vtag before state
 changes
From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
In-Reply-To: <amx58O5Jb6B29XDJ@chamomile>
Date: Fri, 31 Jul 2026 22:58:40 +0800
Cc: netfilter-devel@vger.kernel.org,
 Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 coreteam@netfilter.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org,
 Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
 Ao Wang <wangao@seu.edu.cn>,
 Xuewei Feng <fengxw06@126.com>,
 Qi Li <qli01@tsinghua.edu.cn>,
 Ke Xu <xuke@tsinghua.edu.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D67DAA07-B087-4BE9-8446-A746FC21EF01@mails.tsinghua.edu.cn>
References: <20260728073507.30635-1-zhaoyz24@mails.tsinghua.edu.cn>
 <amkCbQ1UDRKcZBez@chamomile>
 <AD2FFF7F-7EC3-4205-BB44-508B31BC2620@mails.tsinghua.edu.cn>
 <amx58O5Jb6B29XDJ@chamomile>
To: Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3864.600.51.1.1)
X-CM-TRANSID:yAQGZQB3F8cquGxq8yHfAA--.53903S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYJ7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcV
	AFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280
	aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24VAvwV
	AKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6x8ErcxFaVAv8VW8Ww4UJr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrw
	ACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK
	6ry5MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_GrWkJr1UJwCF54CYxVCY1x
	0262kKe7AKxVW8ZVWrXwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUIMKuUUUUU
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAQEFAWprzrTmFQABsN

Hi Pablo,

> On Jul 31, 2026, at 18:33, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>=20
> Yes, repurpose this patch to nf-next without Fixes tag and stable for =
review.
>=20
> Thanks.

Thank you for your suggestion.

We have posted an nf-next patch at =
https://lore.kernel.org/netfilter-devel/20260731145342.56890-1-zhaoyz24@ma=
ils.tsinghua.edu.cn/T/#u
following your suggestion.

Regards,
Yizhou


