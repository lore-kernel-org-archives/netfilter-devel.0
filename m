Received: from mail.w13.tutanota.de (mail.w13.tutanota.de [185.205.69.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C678B1EA73
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 14:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.205.69.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728483000; cv=none; b=iZidd9ulk7DnvW0XP4PRX3f4IFJRDujjyQHZAm9GjINiQxhiebxnk81ZcYWPhFSI53JErebbtmiN+5Fnn91qM1lnxbegrXx6feJA6gwrg7IFXktFVeNJKy2xlU2o/SP2BbAN9TS9a44710jK8IyzvgRnIL2JhoYNP0x/179o5LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728483000; c=relaxed/simple;
	bh=PuDWCrXfOzQ9HlJzjyMVk31zGFoYIopPGc0uhxi6LVk=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=HV0luJFiXQQ20AlBcjMvVWh6nsD7LeVG+SScuHHUdnYCcgG0yqNGLu/Koo1UGJRJJCMgDW/ih6kx0eVfrySN/H87VJcAW2fZv0tthfn5Mz2f0Oy6En4aTDU5cMtE+RgmIGSatk+pKQK6ftkhwpLJfhD/QkC7pe7dDlOD+QRDvts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com; spf=pass smtp.mailfrom=tutanota.com; dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b=m8o6y/KZ; arc=none smtp.client-ip=185.205.69.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tutanota.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tutanota.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tutanota.com header.i=@tutanota.com header.b="m8o6y/KZ"
Received: from tutadb.w10.tutanota.de (w10.api.tuta.com [IPv6:fd:ac::d:10])
	by mail.w13.tutanota.de (Postfix) with ESMTP id DAC092AF380A;
	Wed,  9 Oct 2024 16:09:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1728482990;
	s=s1; d=tutanota.com;
	h=From:From:To:To:Subject:Subject:Content-Description:Content-ID:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Cc:Cc:Date:Date:In-Reply-To:In-Reply-To:MIME-Version:MIME-Version:Message-ID:Message-ID:Reply-To:References:References:Sender;
	bh=PuDWCrXfOzQ9HlJzjyMVk31zGFoYIopPGc0uhxi6LVk=;
	b=m8o6y/KZEDJ/8QWG295S06Tvwxg+S7TC9+QzWiMa1bsEnKOPT07PVI9YjMvh37A/
	CbfMiyNRNTEJT/B6Zh0x0ytelmoC1W9Cim3G5UH6n3B6mTnWpr5N+RcmCY6lvQPBSHR
	T4fBJqmeUc0rgf7Bwt6pp+ZBYpR6VJi5LgP4yPqdVomsoFYGa1kzZtV6bTJIxHK0fRC
	KOlQnmeupefNDg637so664rNRORiTXgDZt5819xf9SBG1aLFKUKfQzaJZVmPGPl6D9I
	ML4isj49WNOiZ+KcVHWvYN30CJQ4T1X++qN7zWLX3voMnh9PRB+veI3D+5dS5j799BC
	DXtJsLg/GA==
Date: Wed, 9 Oct 2024 16:09:50 +0200 (CEST)
From: Nicola Serafini <n.serafini@tutanota.com>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Message-ID: <O8lSdoG--B-9@tutanota.com>
In-Reply-To: <ZwZkQ0vngLf_ZaiZ@orbyte.nwl.cc>
References: <O8kMltx--B-9@tutanota.com> <ZwZkQ0vngLf_ZaiZ@orbyte.nwl.cc>
Subject: Re: Argument -S (--list-rules) in ebtables
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello Phil, many thanks for your answer.

I believe I will switch to ebtables-save.


Thanks!

--
Nicola



9 oct 2024, 13:08 por phil@nwl.cc:

> Hi Nicola,
>
> On Wed, Oct 09, 2024 at 10:22:16AM +0200, Nicola Serafini wrote:
>
>> Hi list, I noticed that ebtables command line utility has not a "-S (--l=
ist-rules)" argument which is widely=C2=A0adopted by the other command line=
 tools (arptables, iptables).
>>
>> I think it can be useful for many reasons, so I'm here to ask whether it=
 was deliberately omitted or not and why.
>>
>
> Ebtables' UI is different in so many aspects, I find it rather
> interesting that there are shared options with iptables. ;)
>
> In iptables.git, ebtables-nft already has support for -S option
> (although undocumented), so next release will enable this feature for
> you (unless you stick to ebtables-legacy).
>
> Cheers, Phil
>

