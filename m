Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052DEAD2C;
	Fri, 25 Jul 2025 16:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753460534; cv=none; b=RZ6JBSvs6cSbWWH0CCx+EBv1ykdma12DyODbM3NCW5WRq7bjq9UkFO+zrm4ZMinbLjyJLeMAs6Bxl8yCj2RQRHHYz5X6UCQzYXGZuhdUmnGgl5MHdAFi04d3IP5zoetLxgyuyH+Zu/8jZ9EBBH0HH2op8zsFHQAl/dSqx/rdT8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753460534; c=relaxed/simple;
	bh=oDixXTko70cbphK1Bo4NH1oUzIZgfR5Xw/r+uhe+w2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PXVX/smS+IzvjbGsnKeVzKFgj6POmt/PNgReD8V5HC1HD+80DEL/8MGUc9hNgI8FfQIW5731OoG6p+dkIMkJgo1SZygmsQr7/dGOraHYUZPSxCHkndzl9HYomeOiRPMGxyloMMP7TiyUdzHjclVwJvNZ34rEe/mAHP9CwEoL3Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C5873602B2; Fri, 25 Jul 2025 18:22:09 +0200 (CEST)
Date: Fri, 25 Jul 2025 18:22:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: syzbot <syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com>,
	coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nft_socket_init (2)
Message-ID: <aIOugflPgsSYhoIQ@strlen.de>
References: <68837ca6.a00a0220.2f88df.0053.GAE@google.com>
 <aIOnfc06qpphQqZs@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIOnfc06qpphQqZs@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Attached patch should fix this.

Yes, jus removing the WARN is the correct way.
