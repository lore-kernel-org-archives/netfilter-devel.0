Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795690712;
	b=fuLZJM9fxCErzAljbWd3vyPh8or7MkYsLzOTtE9/y1XOLEhmaLQGtUb0yTHO5Z+6Zgc+
	 5G7LO45YdxXuLZwkiQfICoGZm+724ptqiTjQdyt8wVGTGcCp0619ljCRMOQimx/Fi00rD
	 CxOSE20csFMmWZQkdcRdmR84T0G6OmKokS+WEZeESZNXgWNLlMUnrmkibw4RlcbKX+QU7
	 0LAdyy1QB8hrW4md3zS4pcOS5OfqKwPRoMVoI22M0dV0oTA9K9HlUiHY3R9rJvD6tTVjy
	 vyWv1AoiOrwqxFqv+Ur61g3XWOHDlLbcmMn1kb69MRtzCwK/0jY49w94N6wa6ZHRy8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795690712;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=6aG5VZ7vOPF9I1ILqXyzYVBAODGxU8uWTLi153MBXBw=;
	b=tPql139bzLVNCFKTq3T29iBWRwzH3q54G02QRPfGhVcwQMwIAVridGqw6e2U1/f67wmm
	 F7iAMUeULJxicd8NklmOPnov61JQcOOUKuY3U14swaFHwEIWgYCE0i4KSq3gY++pQeUOU
	 Md9xYq4EPUlrs4//hbS35kixoKANKUCb+GcjhEdpFpU9ZgCYlBidJ7Jr8FRnxEMxOvc1N
	 RcDX218R38XyVXfcDkyNCusJa/VxsTTtFSO4eubH7GwBUJbM7Vf0Ve5ldG6u3Btaexw4H
	 S4rzZChfpHrxEOXu84YXlXzwn1Q5UKuXCoygj51avTgoPpbSDheruQQJgNHJdYOQK/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E0B606A31E;
	Thu, 26 Nov 2026 10:58:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21E0B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A0D7B6024F; Thu, 26 Nov 2026 11:58:28 +0100 (CET)
Date: Thu, 26 Nov 2026 11:58:22 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	edumazet@kernel.org, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next,v2 00/15] Netfilter updates for net-next
Message-ID: <awgQzu0CiaMHAzzw@strlen.de>
References: <20261123135726.3940688-1-pablo@netfilter.org>
 <8e69f35e-73fb-4558-910b-45f5e723c64a@redhat.com>
 <awWSHujeBmMMOonS@chamomile>
 <f0a3c071-0142-4c62-b74b-ffff8121c8d9@redhat.com>
 <awgOALX8V2RXY-uH@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awgOALX8V2RXY-uH@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> My plan is to keep the ipset rhashtable in place, I think some of the
> relevant comments in the reports can be addressed by follow up
> patches.

They fail the new test case I posted a few hours ago
(passes with net:main / old code).

Its yet another corner case not written down anywhere
or tested so far.

I can post a delta later as followup if you prefer.
