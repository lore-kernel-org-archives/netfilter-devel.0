Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907123D7D77;
	Thu, 10 Sep 2026 10:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.238.174.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036020; cv=none; b=Xp8hcubr9YZZxYvWJt4GA6wHGjfhG0r6wj6c2aB7NBvyipibWOUAvSXt5x64jcXkh4+Tz48BnPQ6fXaZkaqbWIiCXjWih6pgHSFZQ4DUXo+8lo07Cj9PcClq93bEgl13GCWh66Srqqh2SUtQL+O1nnK0E0ClKA0ED8TmR0JVeW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036020; c=relaxed/simple;
	bh=0ki/Ofm2OD98z/cU/4GRPhQ1prC3hfHnpUBA6qZ1uBI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KSgftklAEcgZKV6buPaUwAP7Uyy01A7sbZ+wQ3XoHKAyvNQktXYT/JYJsuLng3iUnTxNjuwGu60gKcVofpHL1RcfA6J1jwUav8/f0TjJvh2ZvEbLMOgI5uBQFFhdcouWiQSRWIOs4ygt6ozPCsefAKt/ChWGLy2IgmFqWui/ooE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg; spf=pass smtp.mailfrom=ssi.bg; dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b=fI+zDVTt; arc=none smtp.client-ip=193.238.174.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ssi.bg header.i=@ssi.bg header.b="fI+zDVTt"
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 4CF792273A;
	Thu, 10 Sep 2026 13:26:52 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=7Y7yWvvmtN+U2CIKqDqMBcMFm0dZDh1w5k3KPsblfd8=; b=fI+zDVTtAUw5
	uev/8p8EOpgaP9QTLD1UxoxA1sGMnfZAYt8eZ1+/8huYpZ9tttG3j6LfeYL+IeEB
	nOoowExCT3tNS30KEQ8AfHwB77jvQ09EjHWv61Zoaap5oTnobgvkdPo9nhbbH5Az
	GDTBvk+/664j6nRVDRVPD2j0dEm6rr0XnRXhId6I/iv9ols712/7fVdZ7cSJrfLM
	txUdcvjV2pkRtIDXYsOUFLWUFeJ7n8ecNgiePo2Ys5AJ4OonbfpD6+adQWlS3OFf
	wHqdAW76z4i1GJYJkYmcd1us08+E8tUOph4jxUIi8o7pZUjq+oa/uBBH5zEfaKcW
	E0i4V4vl7PcsOfeXCaAMs0oFj7hkPSiI11qF22gxrbW2LubwmfzdhdT/u8W5mkqE
	5ozEyzwYJB34vSzpsE/2SDLdiP/dW56NQBPsUGkNt5SPwEXhEuTpJgJ/RG5Nd9Ib
	kBbAXnu8neBML6bB406zN/PoHVJApkHx8q1Jrl4eaeffU8Fh7CTY0nQfhO6ZSXiK
	KLp06fyTzJITZ+vKxAKgpLid4C7i6ERp94xjS9RyvY+sDNesGz7aMhGy+vEH+KQ2
	KpATugQhUSnlg8i2EHAqiJRonQ/04TLEkMpG0assXiRm8Qob8KX3DXeo1TainmnR
	NGw/lvUjocDKByebT1O/nqWQciPUMkc=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Thu, 10 Sep 2026 13:26:52 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id 97A0A60A0D;
	Thu, 10 Sep 2026 13:26:53 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 68AAQq0j038589;
	Thu, 10 Sep 2026 13:26:52 +0300
Date: Thu, 10 Sep 2026 13:26:52 +0300 (EEST)
From: Julian Anastasov <ja@ssi.bg>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        edumazet@google.com, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 06/12] ipvs: bound LBLCR and LBLC cache growth
In-Reply-To: <aqHwEDfPTQBcLH2m@chamomile>
Message-ID: <a4c5060d-f9a0-058c-5858-ce990ca78a6e@ssi.bg>
References: <20260903004149.1037028-7-pablo@netfilter.org> <20260904020140.3549818-1-kuba@kernel.org> <0afb3b53-f4b5-7cb8-0f06-7582a50ef83b@ssi.bg> <2051dadb-fa1a-02bd-42fb-57719e6acb7c@ssi.bg> <aqHwEDfPTQBcLH2m@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hi Pablo,

On Thu, 10 Sep 2026, Pablo Neira Ayuso wrote:

> On Wed, Sep 09, 2026 at 03:24:48PM +0300, Julian Anastasov wrote:
> > 
> > 	I expected this patch to be applied before posting
> > a separate fix for the missing atomic_dec(&tbl->entries).
> > Another option is to post the atomic_dec fix on top of the
> > current patch or better before it, so that both can be applied together.
> > If needed, I can repost them together in a new patchset, so that
> > they can be reviewed together properly.
> 
> Apologies for the inconvenience, I decided to keep back the three
> patches that LLMs are barfing when I saw the "Changed Requested" label
> in patchwork. Too bad.
> 
> Please, go ahead post them together, including a cover letter
> explaining the logic, when bugs are multidimensional, LLMs become a
> bit strict because they want you to fix all at once, that's hard.

	Just posted the new patch and the old patch in a
new patchset:

https://lore.kernel.org/netfilter-devel/20260910100832.36004-1-ja@ssi.bg/T/#t

	The Sashiko review looks ok for now:

https://sashiko.dev/#/patchset/20260910100832.36004-1-ja%40ssi.bg

Regards

--
Julian Anastasov <ja@ssi.bg>

