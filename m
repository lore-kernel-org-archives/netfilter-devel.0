Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E9A32ED2E;
	Wed,  3 Dec 2025 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764787273; cv=none; b=KB6CKBCzcAf9HtfbNSXc1VUum5Y7Q+H0+35n8qi0bVpA1FYu8Ge6FGXJhxEkvLVwwfOjZ2SvdemmBA9NcWNcy0Biwk5G4dbHvNxztqJ62tRTFHu/2etl4K8JpPAJm7DlCqdio075uPnI1TgKKVmEuWh5OVZzFP+8mgHdWbHW/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764787273; c=relaxed/simple;
	bh=YSKHcA8k7u8m31kVobQOfDXw8+ULWRr+dbtk6rOqHAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VrWcn+Uup8L5KtPnVDwc6acLTFbhYwpnHtva5uRfUdf19IdHO5E1o23oVqZVWQUZ9uSt8QibUpq/YZRBrhvxCaU/+rXP8bOp8XIWVN6QJem6RiUrGFUwPCoxhBSm4N1hYJAToOm7g4rHFPxp4go3J8V7fWj9b/wmJujikwifN/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AF3A0605DD; Wed, 03 Dec 2025 19:41:02 +0100 (CET)
Date: Wed, 3 Dec 2025 19:40:58 +0100
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@syzkaller.appspotmail.com
Subject: Re: [PATCH v5] netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
Message-ID: <aTCEOnaJvbc2H_Ei@strlen.de>
References: <20251122003720.16724-1-scott_mitchell@apple.com>
 <CAFn2buA9UxAcfrjKk6ty=suHhC3Nr_uGbrD+jb4ZUG2vhWw4NA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFn2buA9UxAcfrjKk6ty=suHhC3Nr_uGbrD+jb4ZUG2vhWw4NA@mail.gmail.com>

Scott Mitchell <scott.k.mitch1@gmail.com> wrote:
> Hello folks, friendly ping :) Please let me know if any other changes
> are required before merging.

net-next is closed and I don't think that it will re-open before new
year, so this patch (like all others) has to wait.

I could place it in nf-next:testing but it won't speed up the
required pull request.
