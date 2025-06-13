Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8630B155389
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 13:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749821833; cv=none; b=CDY+oybMtio0SWwIe37AoUevka9ONmNc5NYV6psJnD4laQDrkPFnO1wL1lDeEoH64S+TxRycgngl0HarTXejWwOQR6NXqyCz4hhMbLit4J8j2OpXc3eGY1G6hu9QYfcWtPXKdxXZaJX2bHxvC+IsvPYURldpTVJYdtMZClE/Cx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749821833; c=relaxed/simple;
	bh=UNmthxesLtA9P0i9N6PQquX0kaLCbrSA7syNaOLilTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F7/E1qogCJc9XkIxvvklHMXeHSVVZmjh5yoJ1bAUS74OCoIiUGGLFmPBuhh4ggigFXf+Pw1QoR2DpAwQuIcpiQqJ/3RzOGefYfUu+6B92E+Gs33FUIhhNYHvpZMLD3S6xVwNq92YrQyX0s7wjhqXbfUCF9/UB7y913GCLtwKD/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=MkvFFflX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="MkvFFflX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7qkgGT+74z62awJg3tPslpZ9BX6Rn8VKC8RWEzWBRR0=; b=MkvFFflX78y0G+fqo2DFxi5g8C
	5/F5eIzMKsDhLkwh3pP8YZjFNGy+SHa9wdOPtoOiMZHPxUCo0CqI+8GjUeUB1RqgSsANVogmLEEMP
	hUiWJk17c4vrdHgz5wNYTtGsJ3hvRguoB9pZL7mCLqMo+izsEUfmQfAawE9Op5/ECMLAetenp83vh
	hqWTZP0zjAE4KqXrxd+cG9xWCSYLCKwsOnVUKmHG3OUtvE93EoNRTRurczcNrn8VJkyK+tdX8+5ex
	k8vpQMOIdHWkec3IY/OgOToHomWHdpe6K6SUprbzcvVBW8YvfTQ8gUFYq2Ix4XhA1XaCr2kU6as3U
	IN5TCwHA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uQ4ai-000000004Ea-22kE;
	Fri, 13 Jun 2025 15:37:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v2 0/2] netfilter: nf_tables: Fix for extra data in delete notifications
Date: Fri, 13 Jun 2025 15:37:01 +0200
Message-ID: <20250613133703.9548-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes since v1:
- Split this into two patches to avoid breaking user space with -stable
  kernels

Patch 1 drops the incomplete feature to avoid people from fixing it "by
accident". It has a Fixes: tag and is expected to hit -stable. (No
problem if it doesn't.)

Patch 2 then adds the feature again with all fixes applied.

Targetting at nf-next with both since the second one depends on the
first one and that in turn is not really a fix as things are not broken
right now.

Phil Sutter (2):
  netfilter: nf_tables: Drop dead code from fill_*_info routines
  netfilter: nf_tables: Reintroduce shortened deletion notifications

 net/netfilter/nf_tables_api.c | 52 ++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 22 deletions(-)

-- 
2.49.0

