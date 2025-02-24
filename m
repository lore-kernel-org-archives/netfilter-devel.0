Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D2F136327
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Feb 2025 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740405416; cv=none; b=XEtnIeu85ABdZFFqJKtTKDN/QUdYd3GdxqSOcszTlnkrOCvfaZ8rxHM3VtnQh4e9izcMXesYulp2hrsd2gsvTQufZ1T9ipqWopkvoPGXABn6LoCV+s5A2QHhHtieOGLlj9tb0whKn2Hi+71pr8Tk4ScoCl2vTvTGY7iofIaarsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740405416; c=relaxed/simple;
	bh=4L8vlctKe/Jm9n1x8lv5nyBpYaS+zZJ4vLa7qpo64x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJlI3yULhE3GyQEyKLnr3r1uQXZRaNlKITaqh+PT5aS5+JX5+EE/UIYrcX4YhZF5B+0iz3UA8IFbIndCQ56+09ggzCl3pOGxoW5PNYHjASyvCpFq51PjXbO3xx+sw/nYTTFyl6EYYKK3GB0ayp7+xT6RffDSiDo6Sm08gPh+v7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tmYws-0002S6-66; Mon, 24 Feb 2025 14:56:42 +0100
Date: Mon, 24 Feb 2025 14:56:42 +0100
From: Florian Westphal <fw@strlen.de>
To: Vimal Agrawal <avimalin@gmail.com>
Cc: Jan Engelhardt <ej@inai.de>, netfilter-devel@vger.kernel.org,
	Dirk VanDerMerwe <Dirk.VanDerMerwe@sophos.com>
Subject: Re: Byte order for conntrack fields over netlink
Message-ID: <20250224135642.GA9387@breakpoint.cc>
References: <CALkUMdRzOt48g3hk3Lhr5RuY_vTi7RGjn8B3FyssHGTkhjagxw@mail.gmail.com>
 <642q17p7-p69n-qn52-4617-6540pso33266@vanv.qr>
 <CALkUMdRa5uRo=j4j=Y=TtJe2OW1OC3sAi8U0kSRx7oZvFoNZxA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALkUMdRa5uRo=j4j=Y=TtJe2OW1OC3sAi8U0kSRx7oZvFoNZxA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Vimal Agrawal <avimalin@gmail.com> wrote:
> if (nla_put_be32(skb, CTA_ID, id))
> ...
> }
> 
> I don't see ntohl being done for this field.

I already told you: its a random value and thus doesn't
have a 'byte order' in the first place.

You can make a patch to do the conversion, but it doesn't
change anything.
