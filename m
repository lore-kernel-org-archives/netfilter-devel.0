Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC0B811E4
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707321686; cv=none; b=sOIo9wvhbkswPPjKcQjmAAlNcIvamb2/kUH23h0VlhfAMlguyqQaM/wo14txMDRKPJ6OVN+sUx0l8bkD2AcRBrIVe3Ihfn6VUIip/ZiYpbwdDTd87fivbzJdHqmO2iVOMyVGTEywvQpq1XOmic1Od6COdNwXzzfnaRhieicOAnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707321686; c=relaxed/simple;
	bh=nuTaC8/j14jOGpQE8BU2cn0uEFKH8d9KCcL6AqibxPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVD5cb0p/J10cALrQJeQ7FrcFbmeHaEsPAErSO+L0Wyvf7AP/gzsKwrmffyDTgWaclzjJiAI1GjC7y+5wzgI5KDM1+ehIzJIkZgT1gV+ezlsu386TEExXIYDJ39z3a8fsy8BOnZ7nGCS5c45eVs5TTEQqLda8q9zjI2yEYasnSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rXkMR-0003kL-WC; Wed, 07 Feb 2024 17:01:20 +0100
Date: Wed, 7 Feb 2024 17:01:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Ignacy =?utf-8?B?R2F3xJlkemtp?= <ignacy.gawedzki@green-communications.fr>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack] conntrack: don't print [USERSPACE] information
 in case of XML output
Message-ID: <20240207160119.GC11077@breakpoint.cc>
References: <20240207145013.xzdc6kudqwinzdbt@zenon.in.qult.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240207145013.xzdc6kudqwinzdbt@zenon.in.qult.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr> wrote:
> In case XML output is requested, refrain from appending "[USERSPACE]"
> and details to the output.

Applied, thanks.
