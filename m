Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FE412B152;
	Mon, 26 Feb 2024 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708960687; cv=none; b=iJ/rzMKCvrNWv92S3Bqu4sD6emy6vmPSDEg/NOyrmfWzdoPonoO267AJoN/EXsQcNlNvzl9Wty+HtAALfcIKLu4Lv38f7lRFEGLSbUV/6FiZhezu3dNILJRRTiavxyiIWJ+gqFg106PIo7ZWQsetKfasEnbiJXDbxx4kuN5584k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708960687; c=relaxed/simple;
	bh=Q6aRQ+aaABdlMpDT5MgMtUKAnI1gEdR6x5KojLN1wG0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GdUBujP/TPxIS6aAZ9k23vav3YtwPXymm03SeOGD2+019L4gZv9g2MxLVdxTfr3/N1g3/BRo3BLKAmyt7aJ4wfvGtLfDQU1BI2CtapXr8t3nB1mrP+x1dtiylqOFha/FPd/lyOOGhj6hKHc+gGeLmSlsthYMgXF90Skujhp/4fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OD8PNejY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OD8PNejY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0377C433F1;
	Mon, 26 Feb 2024 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708960687;
	bh=Q6aRQ+aaABdlMpDT5MgMtUKAnI1gEdR6x5KojLN1wG0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OD8PNejYyA4HHbUAtLwWZpBacHHTvMF2Y07L0/7WLadXNWxp4+2g2g5H29K+rZJ1k
	 /SymkBz9NeCboJfPizIIfOb4bRfAjD/A3Aq13AuSo6BoNP7N6Pd98Gp1vIr97Qk3qb
	 Q0R08uPewqbnImlXNRnkj07RCaYH8mtSEp4VTn0uNpGhBQZN42KWSX27+9qgGushpv
	 JkR8GUUKkXvD7Z3c+2nbp8rxxzEltzfIo/uMQlNst+xpOQ7nXcC/U2EvvP/U+q1f5j
	 I/yDb42zRygMAckiAq0Ts4UymCATUUsn1COSM5H0+J9LI9xzAyL93nB6xHIYy/v2h0
	 8Tp0rv3YX+yeA==
Date: Mon, 26 Feb 2024 07:18:06 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net] netlink: validate length of NLA_{BE16,BE32} types
Message-ID: <20240226071806.50c45890@kernel.org>
In-Reply-To: <20240225225845.45555-1-pablo@netfilter.org>
References: <20240225225845.45555-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Feb 2024 23:58:45 +0100 Pablo Neira Ayuso wrote:
> Fixes: ecaf75ffd5f5 ("netlink: introduce bigendian integer types")
> Reported-by: syzbot+3f497b07aa3baf2fb4d0@syzkaller.appspotmail.com
> Reported-by: xingwei lee <xrivendell7@gmail.com>

Florian already fixes it, commit 9a0d18853c28 ("netlink: add nla be16/32
types to minlen array") in net.
-- 
pw-bot: nap
