Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2204B41D129;
	Wed, 16 Sep 2026 19:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586958; cv=none; b=LQxw+ITV/ZHjNJPDsWdAtTiD1hzGk3+voHkdkQkjvdpeXENXKEJtT9FH1zp3ED2tAUE6PnWXymjPjmiOZveMm8Uc35iRjz85eoYRBf4Zxav+wEC2dJcTfuSy3lz1baPAeh1BT7/Cj3JaPPrKm4GMQ18pMO0uJj8hlufKYn3X/xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586958; c=relaxed/simple;
	bh=7EhbcMj9P6VugQxiKzfyOwCveauffyzxOdr3dIudqME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiqDca7ZQUcUpTqBzAx6NhBPGBp7L5ENJftrbyFDBOUflGWwGWU7j33SSomTlJhLJ1g8AMpDI7ivlRz/WOasM5DlyX+PwsZF/7ngrOyEqYTNyZ/CHqJxm/O+dMhhrJL2oeHuxsVLIeLK+/8evoTMuqVSZiY7vJXiIqh2es1kguc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m698z9ZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m698z9ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342C11F008A0;
	Wed, 16 Sep 2026 19:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586939;
	bh=sWU/jAKFMJ9Iz8hD6DV6sFVjF6QEBg2ujvr7vsJshN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m698z9ZBGA/+iTqK57qz2e8ARBfmiX0KVSBQD0uZqMyzsXnioOmpGzrDcUmJH5fEJ
	 i8gsJAKm0ANofxbaN1rk07G7yMR1bW2uD196OSOfDTG8mvu0V4zONrEhNm56CZ21hB
	 00Jicbp9IZ0rba3pqAxYsGgWbGxW3tLDveczFLwOMddg8WqxjbmY1dp8xKvouDWXNN
	 66FuoZAuxkCoZmVDCTjG7jQ9ul6coE7hEcrPDH4XXx4qpwBkt/+bVYQ2liO9FFUuMP
	 hyUBQ8RDXeHnKsz6tFa1F+ANwmyC3kC7kGeMJJQ9fFHO8rZQxwyfzle1FKu8GnREto
	 8zH2QHhURm0mw==
From: Sasha Levin <sashal@kernel.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: network flow offloading broken in 6.18.45+
Date: Wed, 16 Sep 2026 15:28:18 -0400
Message-ID: <daily-reply-20260916-0028-re-netfilter-flow-offload@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqj-mK5O-J4PcbLv@chamomile>
References: <aqj-mK5O-J4PcbLv@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> My patch is a workaround, so dev_fill_forward_path() does not fail for
> this case.
>
> Does 871df5007eda fix the issue for you?

From the stable side I am not queueing anything for this yet. Your v2 is not
in mainline, and both it and a revert of b5964aac51e0 ("netfilter: flowtable:
consolidate xmit path") conflict on 6.18 as things stand.

Once the fix is merged, please tag it Cc: stable and it will reach 6.18
through the normal queue.

-- 
Thanks,
Sasha
