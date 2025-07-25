Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EEF2BB17;
	Fri, 25 Jul 2025 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458568; cv=none; b=c3+BS2ETnDf5fJjFQ7bzvxnz0ksqIBIACaCyXJsA+Y12SaO3zHoXtMM0Gwlt4KvjUzhEO1xCREVltveqP8WsetAmcUOgsGxeoE0vzj3Th0tw8D17DAvC75Hd7lRduD0N3YaJMgaMTvz63H8Qnac+eYZdK57le7opKs4/C6rEaRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458568; c=relaxed/simple;
	bh=WIbcDd2hBVWPw5liwDAnKhJorrg6SMWEsW4UWntHIjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EtH4aP11mKJeUDL5T1fOWzwLWt45dwYfehvvOBNyg9sCZiCvyWJhSfLnMj5PfY4FLWwOia9jckGUyZuzw6FqZ9JONVK5yzIKGGxnN79GQLusbI2YNl8rn8q1sXD4T1KVxk1pPn5UFcVkWSlX647q3ZNinjP1sKdWi/oogQFCoqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=p3bhAtN9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d8ZFYSFq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="p3bhAtN9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d8ZFYSFq"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B4E0A60264; Fri, 25 Jul 2025 17:49:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753458563;
	bh=hkOlR1Au5kRDU/srz9QZOpj+qDOVeKRe1xam/M4NP7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p3bhAtN9DUX5KKUkRWHkWtPSC27WfJVZ/Oeb1lpTK0mo/qRxU1fBv04Ekd2znf0Ds
	 b+5QOfJl1Z72CL8j8ZgFtZNcdCD7WbMu5OnlgPeTKSB5uUW3T/5WVbK/O+5GyU/Bg8
	 LOwRBHGIiV9yMkXB+g9/FUm++xBcCnMyceSsYlxE41MZhRxXM//FVOTmQO5URrfCtF
	 wetz7PLj8nCPZLuSWzSRTmAy2UlUepmIdl1jJ0ZYiUiFApzunfRb8ZTGnriIbjG8hc
	 yOwito7Tw/xVJAdKDRKveovUjuoCMKXOcrb0ugRYpvLRYwCaxmaTYhlnK9Nd06roSd
	 HtUYZ44R+hwuQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C8936600B5;
	Fri, 25 Jul 2025 17:49:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753458561;
	bh=hkOlR1Au5kRDU/srz9QZOpj+qDOVeKRe1xam/M4NP7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d8ZFYSFq7eEgDxamrmyFRPNOZP4BsSxxqck3uaceJW1oA9Apk9Du1uTCjyAL80fNc
	 jizgkT2UzqkZlz00wcl76MyHbPXPQQN4wfCCx5JeZAI0rq1o2GTIt4EgRr8Sy9idMS
	 fm/lerRSgVFNy8A0jZwcpgAJOjmmhnoD+PVZyTADfgn8lxAk3GnkeFYKCmilPZjDwp
	 rqPcNky5PXOkwLa3VPt9FU4POIqBXX0UXlr2cvOp6ZGB88XUHRAGBTxEUBrJqjMv15
	 2umcShPHdzpqBCJvG7swfUSBPj/jkJR6EK8+xNdTqcGcpMdbws0aOWi5c2RjX6ttsJ
	 cIrwzuy8uNdeQ==
Date: Fri, 25 Jul 2025 17:49:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: syzbot <syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, pabeni@redhat.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [netfilter?] WARNING in nft_socket_init (2)
Message-ID: <aIOnfc06qpphQqZs@calendula>
References: <68837ca6.a00a0220.2f88df.0053.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kX7Dfd+oWmQp+3k+"
Content-Disposition: inline
In-Reply-To: <68837ca6.a00a0220.2f88df.0053.GAE@google.com>


--kX7Dfd+oWmQp+3k+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Jul 25, 2025 at 05:46:30AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    94619ea2d933 Merge tag 'ipsec-next-2025-07-23' of git://gi..
> git tree:       net-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=14bf10a2580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ceda48240b85ec34
> dashboard link: https://syzkaller.appspot.com/bug?extid=a225fea35d7baf8dbdc3
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bf10a2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d27fd4580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/afd64d9816ee/disk-94619ea2.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e1755ce1f83b/vmlinux-94619ea2.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/2061dff2fbf4/bzImage-94619ea2.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com

Attached patch should fix this.

--kX7Dfd+oWmQp+3k+
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix.patch"

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 35d0409b0095..36affbb697c2 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -217,7 +217,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 
 		level += err;
 		/* Implies a giant cgroup tree */
-		if (WARN_ON_ONCE(level > 255))
+		if (level > 255)
 			return -EOPNOTSUPP;
 
 		priv->level = level;

--kX7Dfd+oWmQp+3k+--
