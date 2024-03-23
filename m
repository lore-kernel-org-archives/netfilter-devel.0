Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AD51A38FC
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2024 21:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711227840; cv=none; b=lrSLgFNoJK4sLG5eW/fV521LPY7iDzHFDwkvwGZgzCm7ayf8R4KOlU/LOyg1GQTgGdtYYb9CIl26DgRufF4sYJ8eHIT5cTAG+huR1DncOZ5EkZtAJWcqjh3Gn0mke63ULThrcuRFtXAqdivHkmi++wDm5Vvpqrj/CDzTjYoT7DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711227840; c=relaxed/simple;
	bh=e10ELFZJw5VPFC4KPjlSyT+enyjb2+rXKQGsyg8K31M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQayZcnID/8st+zkz+LrN68Y+041LFyRzOZfmiyG0gk+RelPchA5rPyeSKW7i6fxWOlzMR+b4x3fstiMGHs8BwqbuIGlBVYA5i+lEodo1DxcOZOzYjClfLfl55rHJmubLDOyMUVcHTDFOnskModHw1HOQmRtGdAJhpXHT6ecZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Sat, 23 Mar 2024 22:03:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nftables documentation improvement?
Message-ID: <Zf9DskY3QHAIBGLE@calendula>
References: <Zf6Y2s6eyrhlWLZz@nataraja>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zf6Y2s6eyrhlWLZz@nataraja>

Hi Harald,

On Sat, Mar 23, 2024 at 09:54:50AM +0100, Harald Welte wrote:
> Dear netfilter project,
> 
> In my recent interaction explaining nftables to some other users I am
> under the impression that there is likely some improvement possible to
> the nftables wiki.
> 
> The wiki is full of details about the individual expressions, actions,
> etc. - but I think what's lacking (or I couldn't find it) is some kind
> of conscise overall description of the terminology + the general
> high-level architecture of the ruleset.
> 
> You can find some description in the first two paragraphs of 
> https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management
> but that doesn't define the terms used (action, expression, statement,
> ...)
> 
> You can find an overview of the terms used in
> https://wiki.nftables.org/wiki-nftables/index.php/Quick_reference-nftables_in_10_minutes
> [but then actually with imprecise language like "rule refers to an
> action to be configured within a chain." while a rule actually consists
> of matching expressions and an action"]
> 
> I'd be willing to try to write a proposed improvded text expressing what
> I have in mind.  I'd prefer to do that as some separate wiki page as a
> draft for you guys to review before deciding whether to use it in the
> main wiki pages.  I just didn't want to write it as unformatted
> plain-text here in e-mail and then later have to re-format in wiki
> syntax.

That's fine, I should have written that already myself, your help is
welcome on this.

> So in short: If anybody would be willing to add an account for me, I'd
> give it a shot and you can decide if you think what I'd consider an
> improvement is also one in your point of view.

Just sent you credentials in a private email.

Thanks.
