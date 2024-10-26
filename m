Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D2213B294
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2024 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729935360; cv=none; b=OArF6SVFKoRjtMCbel+EeadNMW9LKVZZ8CM4bLctjpwx3rDHAydWfptF495nTw6wFYlsPaJPHxOwTnfvS6zWE1xISK1rTM/UiuRKsaT5BNlDYMJP1uvpPE/ZBSRj6cBlfx4Zw3lY5ySvLKJlL769xjGyz6GlyJEdKYC617YXmhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729935360; c=relaxed/simple;
	bh=qxxkg0CosTgG0WgJdZVSX/q4AYOde1B0Ff6OU0bEieI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFf+zYZHWiCck5QWyKBp4jwa4JQDbmjGKitYMG0SOhjFL9rPNIip3YUnABYoodKbNiwbPq4sOibqFK48IWxRYC/gFj2//VgPPCmyEVkdVF77vs1N1C25IbOPhOkLligsj9PEiR/fwQTkcXOM6eNyPvIjiMFrVcZBs8MB+v7TdBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t4dD2-0007Wl-90; Sat, 26 Oct 2024 11:35:48 +0200
Date: Sat, 26 Oct 2024 11:35:48 +0200
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 1/7] netfilter: nf_tables: avoid false-positive
 lockdep splat on rule deletion
Message-ID: <20241026093548.GA28662@breakpoint.cc>
References: <20241025133230.22491-1-fw@strlen.de>
 <20241025133230.22491-2-fw@strlen.de>
 <3f40f462-2b54-4eeb-9fbb-1f76ab43f440@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f40f462-2b54-4eeb-9fbb-1f76ab43f440@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Matthieu Baerts <matttbe@kernel.org> wrote:
> > This is enough to resolve rule delete, but there are several other
> > missing annotations, added in followup-patches.
> 
> Thank you for the patch! (and sorry for having somehow pushed you to
> open the pandora box for the other cases :) )

Right, I still saw more splats when running nftables tests, but those
were in other places of network stack (outside netfilter land).

I will have a look next week.
