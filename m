Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4028435471B
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 10:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761821046; cv=none; b=ExqGOiCe3Usx2m9UvJX2bjb3p8jySjBoHh6oFRa1MqetqK/FADhDlZtahpazF1LuOt1KPlZLFcp7wVWpIKuFsRTuS64X86oaFC9b2fIgsN2ABIKVmSbm1egWU0e78sZkLTT59qJwveZZ0BCaJJZoZ1QdjOWfMM3X/5NYkypq1vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761821046; c=relaxed/simple;
	bh=4MEsk3GzZ+643hitNmnXPDDkCssT6AKKv9F78udbkMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPeIDeZaAI4XdqLxgFSKkN+VNsP64pzCAJVDBZyfycatHFYHiHXELTYoGBkEF9lz+WaASw9YiblFj11CZnrvGkou/nJ8GwmLUmJ6p5MKNrREwAEfqvs3xWmXM2m1ltTg7FuPNiUlMpM5L29xgviKUuaMBTuPwixxe8GBwRePXZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6A3C86020C; Thu, 30 Oct 2025 11:44:00 +0100 (CET)
Date: Thu, 30 Oct 2025 11:44:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_json: support handle for rule positioning
 in JSON add rule
Message-ID: <aQNBcGLaZTV8iRB1@strlen.de>
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-2-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029224530.1962783-2-knecht.alexandre@gmail.com>

Alexandre Knecht <knecht.alexandre@gmail.com> wrote:
> This patch fixes JSON-based rule positioning when using "add rule" with
> a handle parameter. Previously, the handle was deleted before being used
> for positioning, causing rules to always be appended at the end of the
> chain instead of being placed after the specified rule handle.

LGTM, thanks for providing a new test for this.

Phil?  Any objections/comments?
If not I'll apply this.
