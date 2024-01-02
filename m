Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676AB156C1
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 17:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="HewRsICH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uw/1Ofw6/IfEbhUf4RmVYM+y7Ek20CdCGiO5C1IR9kM=; b=HewRsICHZWib+C+jsSxAKyPr6x
	JvHnXDY0/WITemfb43V5/9tTfxVRtIYRZsV4jgueWCOofnzdHUIQWkVfxTG86rNWT2TRH/24YW+2M
	VwMXoSmSaBUFlrgNoBrLJM1Pw6l6Mt03A4n7BkTaSz7Fvu/hk56cNdhWINiL8bGTsKg93kwyodhFp
	ug6PLNyZlmg+d3vxgMWmRIgpKCW8NvJWvLDjEmUyrS44/4p8Q25HtqUAVD1dFGsczA05WDrPvMQ7F
	8zea4RDICyTKWNgFSFh+SYk7IFj+7N2qQMiagYJ/HfBlfVgAq7Us138QiYz1rc6z6SeGNAacf+XxQ
	W2tZGEAw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rKiW0-000000004sk-03od;
	Tue, 02 Jan 2024 18:25:20 +0100
Date: Tue, 2 Jan 2024 18:25:19 +0100
From: Phil Sutter <phil@nwl.cc>
To: Han Boetes <hboetes@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: feature request: list elements of table for scripting
Message-ID: <ZZRG_yBt8nf-cqxs@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Han Boetes <hboetes@gmail.com>,
	netfilter-devel@vger.kernel.org
References: <CAOzo9e7yoiiTLvMj0_wFaSvdf0XpsymqUVb8nUMAuj96nPM5ww@mail.gmail.com>
 <ZZNuZBK5AwmGi0Kx@orbyte.nwl.cc>
 <CAOzo9e4o3ac0xTY4U3Yq0cgrwcaK+gYoyA3UH7xZEqQ6Ju7UYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzo9e4o3ac0xTY4U3Yq0cgrwcaK+gYoyA3UH7xZEqQ6Ju7UYg@mail.gmail.com>

On Tue, Jan 02, 2024 at 12:34:11PM +0100, Han Boetes wrote:
> Thanks for your reply.
> 
> How does your reply help me produce a list of IP-addresses? How does
> it expand the CIDR IP ranges (xxx.xxx.103.118/31)? How does it expand
> the dash ranges (xxx.xxx.103.115-xxx.xxx.103.116)?
> 
> I don't see how your reply helps. Please enlighten me.

I wasn't aware your problem was expanding the ranges/prefixes. Given my
sample, you should at least be able to feed individual elements into a
script which does that.

Cheers, Phil
