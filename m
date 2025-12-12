Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C4A2F5A13;
	Fri, 12 Dec 2025 23:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765580842; cv=none; b=OBlW8S9ViujkCYAQGlZw9GfFqYz/oHQZtOSE279N3P+a9p9mOOtIfHjyev737iHntqU0eVCvsfd9uNZGkykvf6Ab8x3J+5ZgBp5NGyT17YMcDSZIwhLqxcMtZ1fVOFBxv/Jf13TtRaLWcsldBxS8ekIC+6WSPtJREriW2b/DR/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765580842; c=relaxed/simple;
	bh=0W8wws/RuGsVz4stYt00FBBbEFbTAe3lPcPMKm0ZbcA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAzm/C9f0TyZ+0dfcIrY0gja5ucNanFcAt+a0rKimOyL3fF66vaOmENDS+3KZgGa6dZ0IusdoWg15AGJhrVXCCjrdi31Ay3sxuzXVrw5LhjnoXF8IALC13HdkDnjYecpnCHH4tXZ2te9iSR4KZW4Aiq1czMSqN1aEcFrcrc7UYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mPUFXOOX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mPUFXOOX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607CFC113D0;
	Fri, 12 Dec 2025 23:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765580842;
	bh=0W8wws/RuGsVz4stYt00FBBbEFbTAe3lPcPMKm0ZbcA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mPUFXOOXfcphcRVsHDJ+21y8y/pf8c3PD0ZTMO20M9lMCCYbkgwB4DLu+LqzL5dbd
	 JjHhbLtF2sp74KYGwYZ+FEL6c1bh2SRl8YlGroJrpluQOc6FnPiCDJF8B8Iin/saa7
	 3RCHxJLFomRpyz9dU4lbRaZhozTF4iDvBqVuJmOtURap6GqWhqqizxIZbt/0w8eq8A
	 4V9+Ewg3uqohAF9AwDFOQ+XD3i3x2y8QQYgEqqLogXwGKrcQPPuNBfKfwen12CxCGh
	 pk15TEF9ec4+HDB/Eht073TmL3Q/HnraBiUCRQOisUMVUxM7n+sxMGZwo4qu1vZDAv
	 d49SgwNSYvy5A==
Date: Sat, 13 Dec 2025 08:07:16 +0900
From: Jakub Kicinski <kuba@kernel.org>
To: syzbot <syzbot+4393c47753b7808dac7d@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
 fw@strlen.de, horms@kernel.org, kadlec@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org,
 phil@nwl.cc, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nf_conntrack_cleanup_net_list
Message-ID: <20251213080716.27a25928@kernel.org>
In-Reply-To: <693b0fa7.050a0220.4004e.040d.GAE@google.com>
References: <693b0fa7.050a0220.4004e.040d.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 10:38:31 -0800 syzbot wrote:
> ------------[ cut here ]------------
> conntrack cleanup blocked for 60s
> WARNING: net/netfilter/nf_conntrack_core.c:2512 at

Yes, I was about to comment on the patch which added the warning..

There is still a leak somewhere. Running ip_defrag.sh and then load /
unload ipvlan repros this (modprobe ipvlan is a quick check if the
cleanup thread is wedged, if it is modprobe will hang, if it isn't
run ip_defrag.sh, again etc).

I looked around last night but couldn't find an skb stuck anywhere.
The nf_conntrack_net->count was == 1
