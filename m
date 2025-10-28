Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2872434B408
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 20:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761684875; cv=none; b=ZB2NGTwI2VR5TQBTC0uA377OURZ8WVdQiNhDfAbrMyn3Nwse/eBgGR/xRSCcINrZS60tn8n+LVeRfKsqPxETg/ISStC6gNQKGZodmaqXk0rxK6juuP+DAqa2WRFzhdXwJqk4qb4EglgVLUFIRZslsmuEGapXmXVHMBtgKCz0E1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761684875; c=relaxed/simple;
	bh=xfqKTs1v2lwMKAJVwr5JugpWNUZU5K5Vdgww49gkTEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9Mu2mRb1A2lEnx56nh5DjqCxK1YQulm0USfnS6M7Dfzwdme1gAfJIolazITh4V8xF6/EJROwfiUnzDKaZo0GP/LvFx1mFgaWzKqZ1LaKWkzO5Xz02aBvpdplmCEtir5RM4YjfZWMBZv/AhMc/NRMEzNCGx/yaBqx4W1ZNuocUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CACDF61AF5; Tue, 28 Oct 2025 21:54:29 +0100 (CET)
Date: Tue, 28 Oct 2025 21:54:29 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of
 a connection
Message-ID: <aQEthU7pgdNm9a18@strlen.de>
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula>
 <aQD4J7pI-Fz1V3eC@strlen.de>
 <aQD5PUkG7M_sqUAv@calendula>
 <aQD810keSBweNG66@strlen.de>
 <fdaccdd2-fce5-4224-9636-bf3366de2761@suse.de>
 <aQEMbKZUBms2bfuI@strlen.de>
 <f012e7c0-4c29-42b0-90e6-9e82ef5bc6d8@suse.de>
 <aQEVF4mZ23ewPmUN@strlen.de>
 <9d1bb390-0f79-405e-8f28-6c7143a2e6b5@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <9d1bb390-0f79-405e-8f28-6c7143a2e6b5@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> The use-case I have on mind (which is similar to what user described,=20
> but he uses a counter which I guess is just for debugging):
>=20
> ip saddr 192.168.1.100 tcp dport 22 ct counter over 4 mark set 0x1
>=20
> later, the mark can be used for tc or policy-based routing - e.g=20
> limiting bandwidth if the ip address has too many connections open.
>=20
> To me this seems a valid use case..

It is.  Please add a comment as to why the extra gc is needed.

Its not needed for the 'limit this address/network to only have
x concurrent connections'.

But it is for 'softlimit-like' things as you explained above
(which I failed to consider).  Thanks Fernando.
