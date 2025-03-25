Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC54339A8
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 05:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742882216; cv=none; b=YXnX2qhgYgSe9sn5UzO6tHW1Ueqkkv2t71dkOmJLjFTQdtUbMmQ77XMLmwI8eXxhnp+H0jhm/QevC1gXXh+cR8iSAYY/42deisRLU/7da1bwyLRCpGCwXw+ti4KfM64rammqYlZkIlT5NBFN7AoDraHBNSk2iowcE99YQNh3GcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742882216; c=relaxed/simple;
	bh=6wq6uwOnx+Qhxii0Nk5nRZh8I+tSYolcJfln3/Z9a3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oz7oxqDcT/I+jjuV5Ggip9w1tShRkbRBCVChVlqNf31JYQFwdoW6COAjjt8Xg7rZgAacptBemxaX+sJtOZzj7uVA4jiDMWxxVKB48avYflhAA3RmLlLdLOO/jOcKKX3ONjkUj2AMla55aBBTD447FBxXWvOLGdqpr+YCT9pvcgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1twxHP-0001TZ-1T; Tue, 25 Mar 2025 06:56:51 +0100
Date: Tue, 25 Mar 2025 06:56:51 +0100
From: Florian Westphal <fw@strlen.de>
To: Corubba Smith <corubba@gmx.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2] nfct: fix counter-reset without hashtable
Message-ID: <20250325055651.GA4481@breakpoint.cc>
References: <ef47491d-5535-466a-a77b-37c04a8b5d43@gmx.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef47491d-5535-466a-a77b-37c04a8b5d43@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Corubba Smith <corubba@gmx.de> wrote:
> The dump_reset_handler will try to update the hashtable regardless of
> whether it is used (and thus initialized), which results in a segfault
> if it isn't. Instead just short-circuit the handler, and skip any
> further result processing because it's not used in this case anyway.
> All flow counters in conntrack are reset regardless of the return value
> of the handler/callback.

How can this happen?
constructor_nfct (->start()) will return an error if ct_active table
cannot be allocated/is disabled?
