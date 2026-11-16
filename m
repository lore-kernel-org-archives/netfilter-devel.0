Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788608;
	b=SbX+pmstFmBFNeb3Zq3dgISoK5dtzBCeu4BeLmlBUdTA2niRxfo6NFaui0sEnqchXzL4
	 E5b9Bjo/9mOpT6qJY9FS0j7ZA9GCat563KwbSClYJthk6oPPU9b5LrbIgpTvtrfzTqfRT
	 TRWoCH2DiCzGV4cJLS4amR9tB2F49XYth0KISwVXNp1y73n8Gma8CdU0AYPGDK9zo86+X
	 ReuOOKiq2E2QXMtsVDi/fWeQa+HC7HmEHoJ3BxnzC8cevfe0HBTXGIOxBE9/nyW7C5olv
	 H1wEK9rr+5KDF3wibIaGfVcZTqANw5YdBHE/rZMLPIk2xapVd60gqzdNZLw0KH8F9EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788608;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	b=f50AnPctDbYao+cLIMs/LiEdJFcxqWI3/ZZlrnGTlSa/XKitzjlo+L3p3fyHJ16wiUKB
	 n7FpGbXmXHJnkWDCjeTQgRndQdWraBNxPQkBG8l/kEa6gQ7q7OpvDBJpsaJbohUI4tc/k
	 3QmYXuq3VH0eEYlbeeDHJwY9Axgb/uyh3mqPJgG7LD6h5H0bQSHeTfG7A3fc4AFJZ1M+/
	 pXGG6fmQHzw2v6qiPkIIF/ue66Wri0U2mWhs7KPQB7u5HgzSmwKWQdOeu4/z1diBAvObc
	 O5i/dT5rGah5898gfYZu6/RnF4J0EaKiUkdzy5PnGfN9bnOLZcmW09bTAN68d0DxFaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="o2HZ9/DP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B8D606A31F;
	Mon, 16 Nov 2026 00:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2HZ9/DP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9337E1F000C4;
	Mon, 16 Nov 2026 00:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794788608;
	bh=Ld9+YyGfs/W/wYUchYl+G0tuTdeNOsMW/DqiAiz5bT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2HZ9/DP/vJOwVJWOxyHki0b9B9U9Ls94/8IKaJErOoWXEkd4q3z6p+9rBlWEtRRl
	 hwvNFbaVg0bEwIGW2srTEG97ltDCwYiV5htMp5ixvtDfPafnJPDrwqSeOzcg4Zp9Uv
	 uahlcJpWhXP4t2hX4IyMYD+kNKoAeOgguqUdABu9KjR/sbc2htPMRcOcM/mWXVGa/w
	 o4klyeOZZJMJE7Y4Zxn0SYf5zB2p2g9cq1pdl3K0FUC0/GpjsteIXsv0IbFeOKkL7Q
	 wy6ukPZbwkwriwuaFHyykQtYuMpdvdkLqwAdNTCvlnmzNruXUuhTEWhSP67sIieFHv
	 jcPyhDsPXK7eQ==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/13] netfilter: flowtable: do not hw offload
 flows in teardown state
Date: Mon, 16 Nov 2026 00:23:27 +0000
Message-ID: <179478860710.3291.6553894600819959606@kernel.org>
In-Reply-To: <20261116001612.2806263-2-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
 <20261116001612.2806263-2-pablo@netfilter.org>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
