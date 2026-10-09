Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31A549D59E;
	Fri,  9 Oct 2026 12:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791549873; cv=none; b=ryf6v4ukXnLFsz0LF/NfTOZ2e6ylesFElhqddi3hK21ZTup/bUuY+H8zFgVgTjNeOSanVAjE+6I3ZBpFAGMaQtePMem3/17FYyA82A3jbBOqirVuxzkxWeXZrwZ9cHchSdStVVpEoTBGhY5N0xIpYULZgnqP5ScNrWwkM/hAisE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791549873; c=relaxed/simple;
	bh=T80pmibn7aSi6N9hDzJvCBDoLXDCN4HDH9fhrQVJ60g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BEbkbD7ZO3uN6T0nql4FTKpNWBtO25uenCIBCBqNXPLQJw3pBRVUq03F9M7CDL/klb0Ce2HOOyfepGlRHnWD/7VuxzW2TeLsSmS09WaoWshC5qLCeLcNOgm9pyozsgjAeyrUzFjN1HHEFSuNrffCFGlRTswQvPebBJRrrtNa8gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NX40sEng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NX40sEng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4EA1F000FF;
	Fri,  9 Oct 2026 12:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791549868;
	bh=ZCAoLYZlSrLohEk+mBrzJi43HvKosm2TxiN/tMhp9/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NX40sEnguamCzpu3X7PnkhNnpj+Y4FNsstFVWzaYUB2Ems3EmL4Sn7IrmblE1TWFJ
	 Z0S+SVhmmYiz2SEEZulks9Bz3iEymeNJvcDLT+/2nU6jiwnDqxfFhokzzVvActpCrQ
	 XNImeUSTYkk62rsbobCzceNGU7XOvnjm06EJnMNJcDJhlzXvux16kXRp7Q8Izzsepe
	 LDYyNtpkhXV751+NXTaAMkt7a3ZpmmA08S40PX2Mu6y+Vbh6FX3VZWKt6yhN4uqgac
	 M4q2h3BtggsJ8fx/WTotk7cDib00MU3HS68DSFsJmFA3ZqIb3annZMXN8AeQwJFgJF
	 ajKrv3GKUUi/g==
From: netdev-bot+sinfo@kernel.org
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_h323: fix NULL pointer deref in
 decode_seqof()
Date: Fri, 09 Oct 2026 12:44:27 +0000
Message-ID: <179154986722.2527009.9795093960607230185@kernel.org>
In-Reply-To: <20261009124116.3950469-1-bsdhenrymartin@gmail.com>
References: <20261009124116.3950469-1-bsdhenrymartin@gmail.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
