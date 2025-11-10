Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F3530BF77
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 12:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762778165; cv=none; b=nkW/4G6zVv3gfpln9nnFcFVZRSTEjOIP8YzvRon1DY+j0SI0LqnuQwHBdEMSPrGk/Pq9qynlYvpo8vlwGrmljmBKZjm5jbJWvbs53GT22js82En0w2jOSEY5k7A4Qefobf9icZZSTh64ueiqZryZvbFgNrcOcOEAE0tPEoOnnUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762778165; c=relaxed/simple;
	bh=/0Y7shLHieCGFeKsgaYN0DjH0Rv7iU1iqsogl1Xwg24=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h4nVjIg4Nc6DDK3CsiUatN0LWeq2eAphdyiAsV2+/iQVW4xeMg6q2ZW8yvGEfX4o1aS3ojDE+TrWxJEPXaEWSypmc66S2JsylTdwxjCmsWFbmDYZLbO1fTIf/DQSoy23TpeVKouHwC7Q4TS03UQjhyQCZzb6Z7f0Nh5MequOT9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MPXu7LXp; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MPXu7LXp"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 22B1360253
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 13:35:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1762778158;
	bh=m/5BnKuRm+IUEqPaYmF3ql/JeSm3KSRzGt6Zii5HhyY=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=MPXu7LXphAW9VbcYcPgHrPjhCFCWpfZ62UfL2vPlNxkdDAc3tnctluo0I2l98TqZK
	 ziSxtCEUoBTaPs5r30NPHg8qcGr2ygCbQfEhsFR8vj9U5Juato+VS6YXxp0qeIYKMj
	 EU2C0KXSvxVnNA/GKC6sGuYoaUPAobIQwbHldOOMjzC/VgS6zCWQ3bF6hnHQSsv5S5
	 IPFfr+oBrEIpc3DngeHe0DPRzY3Zf42lEp4YFqnIIVTyZK2WX5e+TRr2VZiAlJytFe
	 sNk/LgxH0wAUoBMF7H2PTRcXs1DZfVZXecixuStm2C5S4BHkLPM17v6k8tzllA+L5X
	 0C3n98QkBW9ZA==
Date: Mon, 10 Nov 2025 13:35:55 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools 1/2] conntrackd: restrict multicast
 reception
Message-ID: <aRHcK0reHpFVExYi@calendula>
References: <20251110103531.2158-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251110103531.2158-1-pablo@netfilter.org>

On Mon, Nov 10, 2025 at 11:35:30AM +0100, Pablo Neira Ayuso wrote:
> - For IPv4, bind multicast socket to the address specified by
>   IPv4_interface to restrict the interface.
> 
> - For IPv6, bind the multicast socket to the IPv6 multicast address.
>   Although interface_index6 already restricts the interface, binding to
>   inaddr_any still allows for IPv4 sync messages to be received.
> 
> Without this patch, multicast sync messages can be received from any
> address if your firewall policy does not restrict the interface used for
> sending and receiving them.

This patch breaks communication between nodes, scratch that.
