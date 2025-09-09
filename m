Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA8231CA43;
	Tue,  9 Sep 2025 11:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757416658; cv=none; b=ULBG4HvqXB7M9sqZP2YTCe/7vdkNn+1VK7Lq5TPH3m6i4B6VHy/ItjCXEWwO35ErmIn8UJ6NMwdyHxTXtU0T6SERKTlv2b+u2Qzv2XDpv3yGarBilX1WEiGv63S/9wGlR16LUP1UO01Mo12xS9O9lJSbRJl6+0AiSrpU54SfX90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757416658; c=relaxed/simple;
	bh=jmzc9Po7EJpcdL4XUAqKrsYpOxwUoag6udYQgSqj4GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwJ8hFVWGQTckPCbIel2iw8ydxX6fqdbXlAGUR0eny9QtIbMWat/QwqFM5W4Gpzdpi5NtdzK7oWcNXYlSfGtfbRudpdBVV9P9+Bcn06zNtYy8tjwJS25y4Y90RZ3U+NZ15m6ZIssqPjQ9D27SCuk0MB2u8pC97HUxvElSrE+Yb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8756F60183; Tue,  9 Sep 2025 13:17:33 +0200 (CEST)
Date: Tue, 9 Sep 2025 13:17:33 +0200
From: Florian Westphal <fw@strlen.de>
To: syzbot <syzbot+aa8e2b2bfec0dd8e7e81@syzkaller.appspotmail.com>
Cc: bridge@lists.linux.dev, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, horms@kernel.org, idosch@nvidia.com,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org, razor@blackwall.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bridge?] [netfilter?] WARNING in br_nf_local_in
Message-ID: <aMAMzZ0dIDMjMbv3@strlen.de>
References: <68bfb77b.a00a0220.eb3d.003f.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68bfb77b.a00a0220.eb3d.003f.GAE@google.com>

syzbot <syzbot+aa8e2b2bfec0dd8e7e81@syzkaller.appspotmail.com> wrote:
> ------------[ cut here ]------------
> WARNING: CPU: 3 PID: 8841 at net/bridge/br_netfilter_hooks.c:630 br_nf_local_in+0x714/0x7f0 net/bridge/br_netfilter_hooks.c:630

#syz fix: netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm
