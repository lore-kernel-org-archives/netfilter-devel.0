Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF243314DE;
	Wed,  8 Apr 2026 01:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775610056; cv=none; b=AQhrG2inBjBVYBpdoRpdR8hhEijhlpIed7U8UOqWKsTAS9ZwPDwYPTEVrp7LozDZkqbvrybPaglpFBGSA4yErG7WdeO5KGEMQVozFIYo06BFMty8zu6+4m/wDjy0ZmGki5VfgTGodUmDBBq4cwO85C52DHHWMQvLSGXX71qBDDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775610056; c=relaxed/simple;
	bh=YASJzz2Ts/JJ3gSO0szgf0KjWGJjSJ5Igch4+9QITig=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HIu6LdJls918gnkjKB93HSXOgT93xJ1WYQwHz2amICXfwDqks/CPKxzIS1k5huQjQcl8QIa2aDSaGhCml6pCHZjrDMNINUvwQzT0Cf2cmrkV3QO12zrTtd84GtLW3YS4Zf7WCLP33sflJUJahEdCI5uKdoahC3nARCKdzP6KcBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCTzbAIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCTzbAIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7240DC116C6;
	Wed,  8 Apr 2026 01:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775610054;
	bh=YASJzz2Ts/JJ3gSO0szgf0KjWGJjSJ5Igch4+9QITig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WCTzbAIbXhob6NOVBkHMxKJfzB2gCPeE/iIf5ceHXumenjbcuoJORpCyNaN4lrKne
	 KU644YeWnph2VVUcFKWl5i/o462BRVNR2rTGMgrYSwxa11uF3k+qgPPrzZNsRxCDrV
	 MKXy1YU+JWpBqCF2BbuzSY5drssMd5JjRudTWQe4dIMKCD9QYCq68D6qnoMIlkiswK
	 6bPEnsq06aWKfFSrMloKpApFY9HR9X/CyEzAqceuzOV4Iuie7HELI3KadY2pF+NgNz
	 bs0FsLj228DMM9NlUlG0HYEqPfI1COeY3PsoSYQQlT2z1XBVXQMlN+/XO0n8grb8Ze
	 SatuJMlp9edaw==
Date: Tue, 7 Apr 2026 18:00:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 00/13] netfilter: updates for net-next
Message-ID: <20260407180053.1fb5ffc4@kernel.org>
In-Reply-To: <20260407141540.11549-1-fw@strlen.de>
References: <20260407141540.11549-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 Apr 2026 16:15:27 +0200 Florian Westphal wrote:
> netfilter pull request nf-next-26-04-07

IIUC plan is to send v2, LMK if I misread
