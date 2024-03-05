Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2818114A81
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Mar 2024 17:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709658580; cv=none; b=bqk2UhxrIPEnzSzTpnI8LgX5XwXVuSBeWewRSz/Wt3l30LFp6mh1Nt21Dc1SoLE173CMeGSdMLHM0CcOqK/Ct7/VWs3jfvy59zR5WKksa7SctOpzBvkoQqtSQqE07R8yXJC94ejIoo3y3DykQF+gatKcFhCPicgsSEK14s72aOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709658580; c=relaxed/simple;
	bh=TRqMR65IaAYKt09zREB/MAozzcVahK5V0GiALU/bZfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=in6GAUWV0LAKbwjNlBUQkcxUqe1C7HWIP2/B+w5iReyjEgH4PUZ5WdLup8H6mUKtcr0eWVcgyCAkZPAmx/I4EL5ROnerN4HA984io1luoJk4sOX360pxUOcfPpRv1MeUC5HdKOOGVb/jNro2IpTmZcZ90Xsfi0Oecs5dJOVf4RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=JVzLMBd2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="JVzLMBd2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=m3pKqsRCc7XEYV4fp1vO9Etn29L3jgtrd5GYy0pLK78=; b=JVzLMBd2rdQI1mIO0zVo4vc3CM
	stOIK/Bn4Az6mqGrHGtoKlp8IeX1TGk5KYvktiDMIzXh+H2tiK+O/EFhcrePbbsMa+oOeN0+KJKtL
	NyA6D8bZEGbc0rYPSCgh+gzDhyjlfE7SilMBxcu2OoPEG7qhGAY4smPu2Jusoo7LQPoHq4iJ6k9oF
	C4cQFv83G5ehptdsmC66N3xlMx2mYud46MyJKA3aql0PxbbPeN5f0cq42UzK2qcUA2DguHIykbZVV
	5zVFxCe2c1wm/B0oiy3Cm9PmBRxJLgAaEgJh2T8tsA4i/ROynS5uk2m4AdWS6CsR6Wlgs4cmXfguN
	6Q7EATIA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rhYID-000000008OH-10sU;
	Tue, 05 Mar 2024 18:09:29 +0100
Date: Tue, 5 Mar 2024 18:09:29 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: matoro_bugzilla_netfilter@matoro.tk
Subject: Re: [iptables PATCH] xtables-translate: Leverage stored protocol
 names
Message-ID: <ZedRyflTu5bNgS48@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	matoro_bugzilla_netfilter@matoro.tk
References: <20240229170815.28205-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229170815.28205-1-phil@nwl.cc>

On Thu, Feb 29, 2024 at 06:08:15PM +0100, Phil Sutter wrote:
> Align output of ip(6)tables-translate for --protocol arguments with that
> of ip(6)tables -L/-S by calling proto_to_name() from xshared.c. The
> latter will consult xtables_chain_protos list first to make sure (the
> right) names are used for "common" protocol values and otherwise falls
> back to getprotobynumber() which it replaces here.
> 
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1738
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
