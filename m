Received: from a3.inai.de (a3.inai.de [88.198.85.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51713D961
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2024 11:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.85.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710933823; cv=none; b=ddq3qlVrt8WJv9FeF2fWeNea+oFKOJSz4augTk+ii9yJg7l/mqmlLJwIrlhYh8Se+p8VqYTKeTu8KLMOp4w6SQHKRCD6vpfXpK1+vnjjw78aBv7z8RDpw3Zlbpsg8x8NNxYBqmvAOMYP6fFB/cc8+31+DDlObor6zo3nHVZJ/Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710933823; c=relaxed/simple;
	bh=ZEIahFg+2jE0lKV/xEGMgnR4lK3VTFDyGFVQu/i1wfU=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=CP01lBUn7d6GMQmERFx4FvTLtv1R7dtdZA1LUoTfeYyhlnkcg9tP/cD7PCy1KR93He2ZB70WyeEl6tcoHd0e8U2FVoG6a+pXiIaFpons3DIX1Tjfd/tIt++2wk43gFaXBM+YY09TGvPgqXL3ZEr/XKBeKspX3ASOw96Zp+zeie0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=88.198.85.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 5F0785872CA87; Wed, 20 Mar 2024 12:13:21 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 5DD3160C27867;
	Wed, 20 Mar 2024 12:13:21 +0100 (CET)
Date: Wed, 20 Mar 2024 12:13:21 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: "Sagatov, Evgeniy" <esagatov@amt.ru>
cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: xtables-addons RAWDNAT bug
In-Reply-To: <cbed66aa10f243278a8449c59f27eb44@amt.ru>
Message-ID: <s0s6960s-4192-9741-5qqs-3r9q5o325971@vanv.qr>
References: <cbed66aa10f243278a8449c59f27eb44@amt.ru>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Wednesday 2024-03-20 12:00, Sagatov, Evgeniy wrote:
> 
>I found a bug and want to add it to bugzilla, but I don't have an account.
>I requested the creation of an account via bugzilla-account@netfilter.org, but did not receive a response.
> 
>After commit "libxtables: Unexport init_extensions*() declarations"
>(ef108943f69a6e20533d58823740d3f0534ea8ec) in iptables, the module
>RAWDNAT from the xtables-addons stopped working propertly.
> 
>command line:
>iptables -t raw -A PREROUTING-TUNNELING-UDP -p udp -s 0.0.0.0/0 -d 10.0.0.1/1234 --dport 4567:4567 -j RAWDNAT --to-destination 192.168.1.2:4567
> 
>stdout:
>iptables v1.8.8 (legacy): unknown option "--to-destination"
>Try `iptables -h' or 'iptables --help' for more information.

Contemporary versions of xtables-addons do not have a RAWDNAT target
(since about 10½ years), therefore WONTFIX.
