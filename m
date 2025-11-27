Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DED223336
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Nov 2025 20:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764274093; cv=none; b=eR296Pb3tQntlC/5pXfLY92gH5nZPQsgaDVvtvwhwOo5LeDv0VTGOiyLR8GvdBqkunZmnV2D5hhEJrMxRSKh8ftImjikig4K/Gw2spb+osY9McOGfA5CsmqlSEyYwIiMtZTO/Di+Xm6dLPGwWBXJFek6KAwpOK13HQa4J3qefcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764274093; c=relaxed/simple;
	bh=fhUes4a791ggfEKsusoqJKwaYZeP239xbP9X4HK1brA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQkiANWmBwWluQ5isMGja4GAGXdmlRShrQ4e7R4FzBSAl2c/Kai8Rch3QqzrDwaQDl5GUHKPwJ/8atdzXYyyBxwRY4kvcnrdacinNIWzKhjP9KW9xjN5CH5BChdZr4SADitlGvXzwKwczqPliUink8UicHy3+JA0ovxWrTGNAaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VCxLeAVz; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VCxLeAVz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2/uWU5WqYzqyxZQVkocnTGu6LmLl+9fn4Na1BkLo7Hg=; b=VCxLeAVz1wbjhdOsaHzjWhTVpi
	JJaymXHW4mN/X5HRf8MNOgLDD5pueupUuMAXMPHEsNdWqvv438JPEG9qaLaZwrfXZ5FKGNrD+YjlH
	6/zbpmBi6uuUiO5+V0Cj8cEhjLpNA+MhYMX6VxTjVvzjOWndH6GIHaWfUrqGKevziMv1LLxr6mT1q
	6NCe7GDPOw+/8Z2CcFrKfWaOm1ESi68YWiNJJKrSfNdAiJXlETwwx6Hqvb6W58/k/CSRX70/6yzSx
	nifjbsz/GuE6QP+w+UlKjPuBpMUOrOt3ofbvIl11Ih4X8875o20XvCQXPjMjRXZuEpO+Qz5ghidj2
	JyRg//LA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vOiHa-000000003cM-0Cwz;
	Thu, 27 Nov 2025 21:08:02 +0100
Date: Thu, 27 Nov 2025 21:08:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: gorbanev.es@gmail.com
Subject: Re: [iptables PATCH] nft: Support replacing a rule added in the same
 batch
Message-ID: <aSivoUvoIz7EqpsB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, gorbanev.es@gmail.com
References: <20251120142814.8599-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120142814.8599-1-phil@nwl.cc>

On Thu, Nov 20, 2025 at 03:28:14PM +0100, Phil Sutter wrote:
> As reported in nfbz#1820, trying to add a rule and replacing it in the
> same batch would crash iptables due to a stale rule pointer left in an
> obj_update.
> 
> Doing this is perfectly fine in legacy iptables, so implement the
> missing feature instead of merely preventing the crash.
> 
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1820
> Fixes: b199aca80da57 ("nft: Fix leak when replacing a rule")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
