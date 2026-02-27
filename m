Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88A036D4E2;
	Fri, 27 Feb 2026 08:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772180031; cv=none; b=sIsEzePwoWRd805ppsf9KoxQgF0O1svytMAFbTr5q68zVedUc2v91NhMVz7CBBzIWWMMMfC8HXqH3gZHpLmr9wyWvj4NXaoxH9Ne6ruOrN1+aMlUpaH1QIyIA3V/BwdcZEijGczCFBmbh/msdJ4FK5ouFVb4i/zBDakK8UysvKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772180031; c=relaxed/simple;
	bh=TZeE1/AQsZ/MM1GeMaZlFeaNItZ/Cit9CPL7hTpqKS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WIR4iYaD7QA0DLT270XtnqokYITmOqZ6MiSKe/4B2W1UQqAtw20sgQe/LUXY/+twHwJ7M3JrRzZ5KXaMcKeWaTAEc2QHbbwOyYg0ZFYOTyf7vJvXmQGOfOpV7zAx+7JEyydE5DihtKg5zYrwXkEWLU8bArknWXSZA0P/Emw5Gjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7844660336; Fri, 27 Feb 2026 09:13:46 +0100 (CET)
Date: Fri, 27 Feb 2026 09:13:46 +0100
From: Florian Westphal <fw@strlen.de>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Genes Lists <lists@sapience.com>, linux-kernel@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	regressions@lists.linux.dev,
	"Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables
Message-ID: <aaFSOkhkjowYB2YJ@strlen.de>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>

Thorsten Leemhuis <regressions@leemhuis.info> wrote:
> On 2/27/26 04:46, Genes Lists wrote:
> > I have a problem with nftables not working on 6.19.4 
> 
> Thx for the report. A problem that from a brief look seems to be similar
> ist already discussed and was bisected in this thread:
> 
> https://lore.kernel.org/all/bb9ab61c-3bed-4c3d-baf0-0bce4e142292@moonlit-rail.com/

Thanks for this pointer.

Can someone check if 'git cherry-pick f175b46d9134f708358b5404730c6dfa200fbf3c'
makes things work again post 6.19.4?

Its a missing indirect dependency.
