Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D96F24C090
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2025 13:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744897312; cv=none; b=A750je9hwv7v9zdCCznokJIfOXaKJTQitq0Q2B/Cw2IoT+eehuaL6yGgsZJKaa637eeDPIFIv/yTDwK0UmIC4xNueun86IAZJHy8cIKEfAAO/DQsZF5Hc2hwvlDPftJZsAi8GkYA4anTX30d90h2mbzfyJfydhcre0jdZWagYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744897312; c=relaxed/simple;
	bh=scMz4GSTvKf1uBL2NJbtBJ9N4biMiD5Rm2dn7yBoSdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FOIuxWcw0bKwB00kLbSok5bfGwpDHi5I5MnyGnclkpsK9fIPMTWe8hbIfVwT92WyYsrx1TG/k72oyk7ye9A4d9KC3iAttALtgRGrft4uZ576tBoLDZY4CirvhhRJxS8p+/EnBdAHRgePhEmwW635ItB1K4Azf/DG8Irv/IW08kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u5PUw-00085H-TS; Thu, 17 Apr 2025 15:41:46 +0200
Date: Thu, 17 Apr 2025 15:41:46 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, linux@slavino.sk
Subject: Re: [PATCH nft] Revert "intervals: do not merge intervals with
 different timeout"
Message-ID: <20250417134146.GA17435@breakpoint.cc>
References: <20250417121511.19312-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417121511.19312-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This reverts commit da0bac050c8b2588242727f9915a1ea8bc48ceb2.
> 
> This results in an error when adding an interval that overlaps an
> existing interval in the kernel, this defeats the purpose of the
> auto-merge feature.

Do we need a new nft release?  I'd like to avoid people
relying on the 'just reverted' behaviour.
