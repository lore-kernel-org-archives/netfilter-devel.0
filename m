Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2323672A8;
	Fri, 25 Sep 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790362098; cv=none; b=GzQzHyshgw0+I3sIsul+Uo0de/Kx+p6Ag+Vv8o5AjFniPadQQvt3oftVyEYzV3vwS7y26K3GCSOFwe0MSUxR9QOgHfvu8JOwHskIodPmKRlCKjNT2fxUWq1FJXnoLOHaAP9ZrYw5o1uShNTKW+oDf3o/eKy9rYhV+QxcLIqwajM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790362098; c=relaxed/simple;
	bh=R8GhkJl901RQqmTe3SVrmbx5f2zhZHnz1Jrp8dg2kTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLvcgiQqcbN6dDxir3C04t79hPAkxjR6UUmrve2jP1+1BXPEeDv4cNleTqPtcoZMxOQoxGVFXBC+A3X7ttwUXglD1fSa9d12B2FK3enYfio40jkYJAmiOZSUuAp77ygfZ5YDbqAtdVV9reRFpCSstg3Pxc/puRwyMaK5TvS6/t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9DvOaYU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9DvOaYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4931F00899;
	Fri, 25 Sep 2026 18:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790362097;
	bh=84i1a8lLa7/sB8sgBmdxSiZIe5clUJ7A5KCdnmsgLPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9DvOaYUh5AuF9qMPZUoCLyyPwAm7N4nIcc65Svt6n8XOB9vHfvXGMKP+p+WZzfKC
	 SjsUyCJ5nFpGvbSMKY5zGIXXdclmBcYvE2sJRv75FJgtr2ENA2q4gpsTQzlw8c7LCS
	 iwvbFuiEFfBYyjCqlKOF8+ZDIQLER9IK3856JYX6q9wHDYoOEl1vBnck6Gz4TNqTuj
	 YPEJXi0RgbfRCgCy8LJ0GO9o621ST0+nzCzECPhjt3LJjIIDHyF9mZYtKvbTAZsufA
	 Y/x8Gof5CXp87uL0Iyh3QqGmDAGL0tIJKquDmjlgnnt/bAhCQDxilpuBZPN7Ufv46j
	 hsy0FrvKOpjdw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	miguel.gazquez@bootlin.com,
	thomas.petazzoni@bootlin.com,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	"Benjamin Robin (Schneider Electric)" <benjamin.robin@bootlin.com>
Subject: Re: [PATCH 6.18.y 0/2] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase
Date: Fri, 25 Sep 2026 14:47:56 -0400
Message-ID: <2026-09-25-daily-reply-0004-re-nf-tables-splice-list-rcu-bounce@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925-cve-2026-52988-6-18-v1-0-680b24895415@bootlin.com>
References: <20260925-cve-2026-52988-6-18-v1-0-680b24895415@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I backported an additional patch, which adds list_splice_rcu(), which is
> required.
>
> Signed-off-by: Benjamin Robin (Schneider Electric) <benjamin.robin@bootlin.com>

The code looks fine on all six trees, but your Signed-off-by is missing
from 1/2 in every series, and from 2/2 in the 6.18, 6.12 and 6.6 ones.
The 6.6.y series also didn't go to stable@vger.kernel.org.

Could you resend all six with your Signed-off-by on every patch, and with
stable@ on the 6.6.y one?

-- 
Thanks,
Sasha
