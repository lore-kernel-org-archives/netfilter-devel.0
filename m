Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A418209F49
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Apr 2025 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744825486; cv=none; b=sYiWsR6vChT2UmPMi5QdQnNW5mX/qed6twJMot66btuYfmdiBz6ZyNQ0KJMHL5RvpqQi3iZEH5h7LmO9e7uhGncqoUMGK0CMHoUrI/de9W2qULxj/wYgUdIu3vT6sG1W5DZ69wIXJH7ATzVg9iMjpG3P5LftCVVIPAuEd4DDSBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744825486; c=relaxed/simple;
	bh=ppFd7/UwD9qMn5fh3KI8opnVW3EmGCntHDvmxWRAejw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKrsNKwobS87wMhPDnIF9ODQEsjlfGi5Z7z7S5GXGrJ0Dc8VSv2CTKLp+JNQWTd5OQWbejzYgEVd0VRXZjkbXQje1JShtIKaktyx5sti97N3yuoaVfimZixb30URICpBcRPYb1O4IY10aQrB33ImxvTnMDa2TpqxBMFpLuHhMTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u56oL-0005V9-LV; Wed, 16 Apr 2025 19:44:33 +0200
Date: Wed, 16 Apr 2025 19:44:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Yi Chen <yiche@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] tests: shell: Update packetpath/flowtables
Message-ID: <20250416174433.GA20730@breakpoint.cc>
References: <20250416155320.16390-1-yiche@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416155320.16390-1-yiche@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Yi Chen <yiche@redhat.com> wrote:
> 1. The socat receiver should not use the pipfile as output where the sender
>    reads data from, this could create an infinite data loop.
> 2. Sending a packet right after establishing the connection helped uncover
>    a new bug.

This refers to
'[nf] netfilter: conntrack: fix erronous removal of offload bit'
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20250415135355.11427-1-fw@strlen.de/

The updated test passes with that patch applied and fails without it:

PASS: Traffic seen in 5s (nf_flowtable_tcp_timeout), should stay in OFFLOAD
PASS: send a packet
FAIL: Traffic seen in 5s (nf_flowtable_tcp_timeout), should stay in OFFLOAD
ipv6     10 tcp      6 86392 ESTABLISHED src=2001:0db8:ffff:0021:0000:0000:0000:0002 dst=2001:0db8:ffff:0022:0000:0000:0000:0001 sport=59488 dport=10001 src=2001:0db8:ffff:0022:0000:0000:0000:0001 dst=2001:0db8:ffff:0021:0000:0000:0000:0002 sport=10001 dport=59488 [ASSURED] mark=0 zone=0 use=3

Update LGTM, I'll apply it after the fix is in nf.git.
