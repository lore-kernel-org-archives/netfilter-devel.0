Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E85A30F527;
	Thu, 28 Aug 2025 12:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756383358; cv=none; b=itPrQ98yXxi3krymqpqbIA6nIu5yuLHFGhhq79ERnJVrEMYLNzRi7p/V/nozNCWUO3nljADMH7M5aq66tSRAKOud18FDEI8accuS3Z3Y0vTByMTlF3zNtmkLiP+J2NlA3LPjqRS14vCnae8+ApP6VewRle90LFKIYBXpEerON+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756383358; c=relaxed/simple;
	bh=Ui9DJi2qLpZzhifbDFhq8XTnW5CLrUk4Ncat0wJVw00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHqwbnau6Z4RV/FU0a4LvE05oP7lIxGbUFvI5Nd6rWdfsW7uOtNnVnFFVe4g60O1jtJRbsd7x/krBFjcahd3bXzi16UPhYJLc2MssfH8ngBFOBvC7iXSBebzvGppDOuytPl12ORe7jVWwnBYzdiOskR6Sr2qjXzA46gt02+zYgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8A36460298; Thu, 28 Aug 2025 14:15:53 +0200 (CEST)
Date: Thu, 28 Aug 2025 14:15:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fabian =?iso-8859-1?Q?Bl=E4se?= <fabian@blaese.de>,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v3] icmp: fix icmp_ndo_send address translation for reply
 direction
Message-ID: <aLBIeS4_x7dbrL-j@strlen.de>
References: <20250825203826.3231093-1-fabian@blaese.de>
 <20250828091435.161962-1-fabian@blaese.de>
 <aLBE2Ee7pUBzUupH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLBE2Ee7pUBzUupH@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Aug 28, 2025 at 11:14:35AM +0200, Fabian Bläse wrote:
> > The icmp_ndo_send function was originally introduced to ensure proper
> > rate limiting when icmp_send is called by a network device driver,
> > where the packet's source address may have already been transformed
> > by SNAT.
> > 
> > However, the original implementation only considers the
> > IP_CT_DIR_ORIGINAL direction for SNAT and always replaced the packet's
> > source address with that of the original-direction tuple. This causes
> > two problems:
> > 
> > 1. For SNAT:
> >    Reply-direction packets were incorrectly translated using the source
> >    address of the CT original direction, even though no translation is
> >    required.
> > 
> > 2. For DNAT:
> >    Reply-direction packets were not handled at all. In DNAT, the original
> >    direction's destination is translated. Therefore, in the reply
> >    direction the source address must be set to the reply-direction
> >    source, so rate limiting works as intended.
> > 
> > Fix this by using the connection direction to select the correct tuple
> > for source address translation, and adjust the pre-checks to handle
> > reply-direction packets in case of DNAT.
> > 
> > Additionally, wrap the `ct->status` access in READ_ONCE(). This avoids
> > possible KCSAN reports about concurrent updates to `ct->status`.
> 
> I think such concurrent update cannot not happen, NAT bits are only
> set for the first packet of a connection, which sets up the nat
> configuration, so READ_ONCE() can go away.

Yes, the NAT bits stay in place but not other flags in ->status, e.g.
DYING, ASSURED, etc.

So I believe its needed, concurrent update of ->status is possible and
KCSAN would warn.  Other spots either use READ_ONCE or use test_bit().
