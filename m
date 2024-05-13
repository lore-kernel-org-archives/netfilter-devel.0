Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8888002F
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 22:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715638712; cv=none; b=i0qlRLUQsem4EjApvZr8zIW1A2lRSTFezALrgdLA9zJppJTmTpN48CXIuTQF6PDl7G3Ql+7yVC6gqgH3qcL0T/B+2ffAgsahn16xjCszkMsE1oM728Vh3rrXd9CDX/RACylVcFaa5GY7l9nb85vQE3osxRwOnriQNM5Qr7/9ELM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715638712; c=relaxed/simple;
	bh=HvM5Q5u2WAKmAoUeueHKjo1sKDcJfJyYxjGe5VxsbT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGmeNghzak0PYzCsEqVMiR8newJCgYAWG41MdcY5NpwpZwxYtqz8ohHkO7Vm07FHO/r3VBq2pQ4sqYsCu0VrRF66AN39dtRiFoFVeJWeq4kL1jaqczeR/KV0q3C40zNcwNg3wAQXKY1L926h7hfGot1AUU1kTJg+m6A5/3N3DVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s6e04-0004zV-Ff; Tue, 14 May 2024 00:18:28 +0200
Date: Tue, 14 May 2024 00:18:28 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v3 2/2] selftests: net: netfilter: nft_queue.sh: sctp
 checksum
Message-ID: <20240513221828.GB4517@breakpoint.cc>
References: <20240513220033.2874981-1-aojea@google.com>
 <20240513220033.2874981-3-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513220033.2874981-3-aojea@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> Test that nfqueue, when using GSO, process SCTP packets
> correctly.
> 
> Regression test for https://bugzilla.netfilter.org/show_bug.cgi?id=1742
> 

Acked-by: Florian Westphal <fw@strlen.de>
