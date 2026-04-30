Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24A834DCC8
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2026 06:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531640; cv=none; b=BYTRPwNzzf6ftAvXJOslpcj1UQeUYzXKv7/zZ2+AOTIzoPw8CkteoFMa+i32BB9BGmcEFkVg+Y40IjsRvrH2QR28AGdICMcPwR1X4auvH9SGkfg4HfJvpCOY/nmgznMiDH2wz2f30rQJ5e8Hav1MqeigyI0/5x8sAMLjJ8IL+1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531640; c=relaxed/simple;
	bh=QcwoPHtI7t/ImqeHyyDwdYDjKSC+FZGOUv8J9kg6kBE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SocV2FrI4thko6m2jdIfMdu0kJrMszT5vJ9lAXzkQVIpxzwfiEszy5DSkq6AQrsffO7Gd2Fc6XywE5wQJTUOyhF1rJep8a+840yOkJWXU/qFhpNadFR8BSyNYuFeZV9w68j2Y175u5fdup2GCgDXvdA2x18AHsCT8GJbiUBP/MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CDCB36028A; Thu, 30 Apr 2026 08:47:10 +0200 (CEST)
Date: Thu, 30 Apr 2026 08:47:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	jeremy@azazel.net, phil@nwl.cc
Subject: Re: [PATCH nf v4] netfilter: nft_bitwise: fix dst corruption in same
 register shifts
Message-ID: <afL66Hdt560a2EgL@strlen.de>
References: <20260427092117.4160-2-fmancera@suse.de>
 <afLye0knzKl5IdrY@chamomile>
 <afL2FYLNtqESyEPh@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afL2FYLNtqESyEPh@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> And probably nft_byteorder needs something similar to check for
> partial overlaps too for sreg and dreg. Also nft_lookup.

nft_lookup might be fine.  Key could be larger than result, and vice
versa.  Userspace could be chaining lookups too.  I think we should not
restrict nft_lookup.
