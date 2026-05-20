Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA75286D56;
	Wed, 20 May 2026 00:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779238468; cv=none; b=I6cm928Z+qq8whvA/CLKMdV+DOYNof4sxi0LMAFAUkSAM29xO5EDgQ6SQMz21MbnILsk8o4lWmlvlRpQwd7TAxqerhwHGWoe5Q/95kgB0/gjpMSQGxJ66vkbuCnyWds6GxWPO9tExLozpO+8RYRgjETqZ43SGyPlDUF5uwT6dMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779238468; c=relaxed/simple;
	bh=JTjbCDPLmuSpdoQdU9mPqcnutiIancNE+03TzA3n6BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8G58OaX5v6w0bIu/2o4ydIt3XxnGprfilovJ4SHQ2C+JYLzakutWBHarkVIVq7vWWLx1nrgxwsf+XLr2GAeiie+H62TLKdHWIDcrdCZsP3IR+iuIkuyMwbq7vbc7mDYgIomCvSSQxTMJJQv3n+8Iuch7ILO/bUPwsh+nlXGoSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ol51v0dv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ol51v0dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773D21F00896;
	Wed, 20 May 2026 00:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779238467;
	bh=JTjbCDPLmuSpdoQdU9mPqcnutiIancNE+03TzA3n6BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol51v0dvx8n8YPaxC6ZD8vrb7Arr0QtON0pULYEIV1qU1lEfxLaHyqh97rjwcxmvu
	 bNwO2LvxZ+NGZiJ3IeBCtoy4/uAjJY4gMQboZMLvDN7DUTb+9yH+snC0mQRxO2JZtn
	 0gWEfXLcnMXAQi+Ck9uLADovsqM014oQWSfvNAxGUfTCp87BoRFSk5pOt4lubyjaER
	 wAo2CHyVDeATeFfxGanCi+yixlw42NGafP5gJqlWdxoIQPxqxz3Wz/mnaae0SLsPCe
	 iveJzPuwTg/oYG9jBPIB2fqNZbFbOitSZgmPA9PtOk2QdFA+rfWXBvcxpiCzOzky8F
	 9aB7DakI9gn4w==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	pablo@netfilter.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	y0un9sa@gmail.com,
	fw@strlen.de,
	Li hongliang <1468888505@139.com>
Subject: Re: [PATCH 6.6.y] netfilter: nf_tables: unconditionally bump set->nelems before insertion
Date: Tue, 19 May 2026 20:54:16 -0400
Message-ID: <20260519220508.reply-0002@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519075518.2106753-1-1468888505@139.com>
References: <20260519075518.2106753-1-1468888505@139.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, May 19, 2026 at 03:55:18PM +0800, Li hongliang wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> [ Upstream commit def602e498a4f951da95c95b1b8ce8ae68aa733a ]
>
> In case that the set is full, a new element gets published then removed
> without waiting for the RCU grace period, while RCU reader can be
> walking over it already.
[...]
> [ Minor conflict resolved. ]
> Signed-off-by: Li hongliang <1468888505@139.com>

Queued for 6.6, thanks.

Note: 6.1, 5.15 and 5.10 also contain the buggy Fixes: parent
(35d0ac9070ef) and would benefit from the same fix. A hand-crafted
backport for those branches would be welcome if you have the cycles.

--
Thanks,
Sasha
