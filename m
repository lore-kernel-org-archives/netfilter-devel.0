Received: from sphereful.sorra.shikadi.net (sphereful.sorra.shikadi.net [52.63.116.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EFA263C8A
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 01:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.63.116.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745373168; cv=none; b=LH5vSlU6DpCdHYTKwgQxgvNO2E+5KaLwvI8jdICIlwfW5XJ3YZBD9XTSsBBpGsRWDu6LbLdAd6OiqDlnLy7kyV8pLTZytiKXerWUrg2rbQzmtqnVVf/r3QFW+swWO2yoHqb3hhgPO2dzuGWzhTkiK9gS6Kh6DGUYUPPxGZBCOYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745373168; c=relaxed/simple;
	bh=WDsnd/PUX0EmQ4AuyCzlZaHdYgZa0I108KMIiyfjDlo=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=RReGYgqmzlRZVNiJPMbPdRQpywjAcGoJPvyvdZ2uIKBrhgJTMvRZzS0oIhnZs9KLqOaf41/700cuqN4S1Cs6QTqYCTuwSvlnzARhO+qPoKKSqDGiH+9VeQaXmAPsyyFbossWYE9IOX/vlwshlGfpYlfVSP8I3iMnhuDdqeAeDTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net; spf=pass smtp.mailfrom=shikadi.net; dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b=qU8z30FY; arc=none smtp.client-ip=52.63.116.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=shikadi.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shikadi.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shikadi.net header.i=@shikadi.net header.b="qU8z30FY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=shikadi.net
	; s=since20200425; h=MIME-Version:Message-ID:Subject:To:From:Date:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References;
	bh=cX6ZpyZzgXtuYDn3+oLWAOh4YYQ20OANAmowBbGPi9c=; b=qU8z30FYjkO/mAd6fcJRET7gWd
	oZOAkAvZ/z1mJInsGxzoMQf1q+M2xLltdNOon5mkLZQkp4PvFrnkBQSwXW+PB2lbcanRXl8fYbC1I
	xeg3luQJRSmLYpl1l1++xv+tL4hFmmeoDYl6mIAAi+3r/sroPWlkiyHU5m/COeBWAdzqsGkbqg+Jf
	1acud0v4+RMKAq1Hg33fbx/VbkycPoYXSh/2EEtemGU7VSH4CeowqS03Ad3gGUm3G6ZAl+KGsAi6f
	t9RtziKAWXb1b1LnUcywWX0FyF7UjI9tmdj0R8deUBnqTic3+aoTdSqv6mRUH189UNw8JPiytbOr3
	rWLGn0Ng==;
Received: by sphereful.sorra.shikadi.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <a.nielsen@shikadi.net>)
	id 1u7Ob1-0000IV-1m
	for netfilter-devel@vger.kernel.org;
	Wed, 23 Apr 2025 11:08:15 +1000
Date: Wed, 23 Apr 2025 11:08:12 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
To: netfilter-devel@vger.kernel.org
Subject: Bug: iptables -L and -Z at the same time now refuses other options
Message-ID: <20250423110812.61e2ecf0@gnosticus>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi all,

I don't have a Bugzilla account so would someone mind logging this bug
for me?

I just updated iptables and now this command fails:

  $ iptables -L -v -n -x -Z
  iptables v1.8.11 (legacy): Illegal option `--numeric' with this command

The manpage says that it is valid to use -Z with -L, which displays the
values before zeroing them.  However the latest iptables release doesn't
allow you to specify -n if you are including -Z, which means if you
want to display AND zero the counters at the same time, you can't have
the raw numeric values shown.

It works fine if you omit -Z but then you end up losing precision,
having to run two commands (one to show the counters and then another
one to zero them, with any change in the counters occurring between the
two commands lost).

If you remove the -n option, it then also complains about -x:

  $ iptables -L -v -x -Z
  iptables v1.8.11 (legacy): Illegal option `--exact' with this command

This used to work so hopefully it's a small bug that can be easily
fixed.  It looks like while -L and -Z are still permitted at the same
time, most of the options for -L are now being incorrectly refused if -Z
is also specified.

Many thanks,
Adam.

(Not subscribed, please CC)
