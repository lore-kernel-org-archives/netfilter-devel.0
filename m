Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A83B4A8432;
	Thu, 15 Oct 2026 07:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050585; cv=none; b=bY6lM0h6Ls9guPwt5xTJhSwBqJq1S/ra+NyynvLOxpdIZZJa/Hr20jmvRvP1qrOD5s1ozny5LizsuBBPsGq6DCfdK/9VIbXlDDF0xeKYit4ESR8iWRCm0l2sEGHF4IqQwkCzM+MNT1/ybuTCVyp6lsc/UUIGWq+vy5xIoZtaMQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050585; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NhrdSZ+grAl8i0DEti8HmIjMGsD57u6+M0aRu31S5CH7WgPt+slPa735vFbs7oTCz0hbTGbaxomQxpF8tqdHVzClKuL62PJhVOF6aRs9nrqJPgca0XYpgXXFyr6DZEGTpX0OQKt1ZYCoD7zwSCiw323BNtcgQI2fl/YAoGEpbBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HS+TGUBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HS+TGUBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6F01F000C4;
	Thu, 15 Oct 2026 07:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792050583;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HS+TGUBQm1vrVs0Ax8ZqhzrTZVO/5ZWp37Ddp2bPRo5Kbo72zVS6iUQqkBqXSiEs4
	 9QTLOvcgLz/v5nMtu8a3ouaFeyzd+olvu74Kc1eDhbkhEo3Xa1WOzfLUR3ZP50jSsJ
	 X0InUXuE5+cawESxicvMVz7tgbL9iQXpdJDlCQmTWWrLGoQlWLdUwlFoGQqnXxZ+dU
	 lWutYlw6ogCgIBV5z6jdp/X9bFHKwz7R6cL4Cez5lA+O/QCuPynT6ySQifLzjnYcsp
	 BRCi9JwcNeDqpflixEFHKhMQwRvV9QKhz+4USosYPzz0u2WMkbDlGG+RgA+OJ4oWXB
	 /IzcWcJsYsecw==
From: netdev-bot+sinfo@kernel.org
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, virtualization@lists.linux.dev,
 intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org, pablo@netfilter.org,
 fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kaber@trash.net, jengelh@medozas.de,
 andrew+netdev@lunn.ch, mst@redhat.com, jasowangio@gmail.com,
 eperezma@redhat.com, xuanzhuo@linux.alibaba.com, aleksander.lobakin@intel.com,
 ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, magnus.karlsson@intel.com,
 maciej.fijalkowski@intel.com, willemb@google.com, alice.kernel@fastmail.im,
 eilaimemedsnaimel@gmail.com, imv4bel@gmail.com, shiming.cheng@mediatek.com,
 sd@queasysnail.net, vega@nebusec.ai, root@tr0jan.top
Subject: 
 Re: [PATCH nf v8 0/3] netfilter: bound asynchronous packet duplication
Date: Thu, 15 Oct 2026 07:49:41 +0000
Message-ID: <179205058144.408196.393758576070980065@kernel.org>
In-Reply-To: <cover.1792048855.git.zihanx@nebusec.ai>
References: <cover.1792048855.git.zihanx@nebusec.ai>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
