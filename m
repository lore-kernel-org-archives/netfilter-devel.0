Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E6112E49
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710253984; cv=none; b=YPQfI8np/Ht3JSaRCc40DrQNTcu0BSaGQXedF8IIFaWp33cLyRreX4cLcjzdWQCuROrLNRrEiDxfcKq/RsmAicsJ1EzxTjlvqr701D+de1+JpVLHTnOwyMqdqT1mNrmqPAneUSNevGAiRt9zAzTc0ILOj7XjLWT+R5ypQcMvx2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710253984; c=relaxed/simple;
	bh=jkTf7DWjqhASHhgP9eZIjuC26Qu/rOWOZRniRf4FKaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSwkNMuACJ/y2mPQvbfpK/LsF7sIgb2DU3KbBsUwn2M4Hwhh04eDoPHh3KQDOLQdQCp/IlMH0BheVrZtwg92dHwObRK4ogAMUisWwe3bjU1Z1a5YAGKnUrj35wSvl3GeIMCVCpkYqlOz6h5g/lyutilUQ+Caz6GQMAjGMQArqCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk3Bc-0001PN-Vh; Tue, 12 Mar 2024 15:33:00 +0100
Date: Tue, 12 Mar 2024 15:33:00 +0100
From: Florian Westphal <fw@strlen.de>
To: Quan Tian <tianquan23@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 2/2] netfilter: nf_tables: support updating
 userdata for nft_table
Message-ID: <20240312143300.GF1529@breakpoint.cc>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240311141454.31537-2-tianquan23@gmail.com>
 <20240312122758.GB2899@breakpoint.cc>
 <ZfBO8JSzsdeDpLrR@calendula>
 <20240312130134.GC2899@breakpoint.cc>
 <ZfBmCbGamurxXE5U@ubuntu-1-2>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfBmCbGamurxXE5U@ubuntu-1-2>
User-Agent: Mutt/1.10.1 (2018-07-13)

Quan Tian <tianquan23@gmail.com> wrote:
> In nf_tables_commit():
> The 1st trans swaps old udata with 1st new udata;
> The 2nd trans swaps 1st new udata with 2nd new udata.
> 
> In nft_commit_release():
> The 1st trans frees old udata;
> The 2nd trans frees 1st new udata.
> 
> So multiple udata requests in a batch could work?

Yes, it could work indeed but we got bitten by
subtle bugs with back-to-back updates.

If there is a simple way to detect and reject
this then I believe its better to disallow it.

Unless you come up with a use-case where such back-to-back
udate updates make sense of course.
