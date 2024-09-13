Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856921D7E39
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2024 10:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726223032; cv=none; b=Xb+1M0qk24Y8xR/wVKRIfmzLpt0coq4AsTrGABmRZVZBY0OJRF7TFmNK8TWsttDGftbVmZbnhnV/jtzvOa1qQ+SXybmrEnfoegEqpVyPxa+dc0+kmo8XByLBV3Zlx+NWPiuHfqekYmBh88BFGT3gFGHlCfVDfsyyWR+jJTYq8ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726223032; c=relaxed/simple;
	bh=xrSt3fjmXYY+5gZYap/h1rdy20WaLOC/TJDCQZKOJww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FlGolmWmBx8vfYWnhZ6Ej1yh6UgyOYi5O+NOJ1vT3kSwy+u7tFPxsSzkZQTMTqTGJnwEQEqRba+6C4A9DzX1PxPTN8nq/S/hqIt65BY5m7Zhp4hwF7ilSralGpEzKVml73CEjG+LJ+SCxuQoz/WGK+VYmAhbqXohOrPQW8vu9AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sp3St-00046T-EB; Fri, 13 Sep 2024 12:23:47 +0200
Date: Fri, 13 Sep 2024 12:23:47 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, antonio.ojea.garcia@gmail.com,
	phil@nwl.cc
Subject: Re: [PATCH nf] netfilter: nft_tproxy: make it terminal
Message-ID: <20240913102347.GA15700@breakpoint.cc>
References: <20240913102023.3948-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240913102023.3948-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> tproxy action must be terminal since the intent of the user to steal the
> traffic and redirect to the port.
> Align this behaviour to iptables to make it easier to migrate by issuing
> NF_ACCEPT for packets that are redirect to userspace process socket.
> Otherwise, NF_DROP packet if socket transparent flag is not set on.

The nonterminal behaviour is intentional. This change will likely
break existing setups.

nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set 1 accept

This is a documented example.
