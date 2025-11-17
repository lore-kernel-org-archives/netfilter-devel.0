Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D693128A6;
	Mon, 17 Nov 2025 21:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763414962; cv=none; b=tI9Yt+z9xibJtvBSIdrGeL2dpwvdVzVFoWnWweMxC5jRA1x8x843THj+snrLpUTKiIGVlNnLommyMchoA2+2ZMH4ZO4GwB6fhbxUkUiVZM9DRoCAHSxOR1fjpcRWpd02o/SHsEGVQjp7gd6ewVl5+5q+E1XEtN8OcHAKLIsdbh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763414962; c=relaxed/simple;
	bh=4rDC3HejEYto/qdVeLBV/ZKkeHUa2aqH6kVjDsMPLqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eP51xoVXtSzHFvX/PTrPfBz2bQtvrZaRHWwmNdLMcdu56ZZT2/2Fq3Px2CtsPjpzDjrqhcc7ihF8/IOAcJLmKeO990IiM4lHoiJxq8XGsNolod+2Pck0fg7Tr5Ae702pNfxsPz8UgialdPxN9DNPmgaTCQQgW8uBsQ1cAyQfM10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MoUkqv5/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MoUkqv5/"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9C1476029F;
	Mon, 17 Nov 2025 22:29:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763414949;
	bh=ss/cmmmtpcBwry7DT/YhtvJAsGVUQdAfv2KmpuE1HpE=;
	h=From:To:Cc:Subject:Date:From;
	b=MoUkqv5/MyU+w+hBHJM+0PeVM/98qnVSNsbd4bL9nNZAaLfPPFPT7Je8EBENSJ5df
	 0WsKpWLwGg4Xl71vsF0h6nihQ9qmgahY0sBzuCsBAeFEVljmixrEwAP8BPfogBmT90
	 kI78A40lnCE8JSutl8jLvaOAG74Z0schOlMtbCjj9v3/WvvwUTr8zdtAitJGE0bh27
	 kF0S8cqEjFeXy4OwfQdBVpuZrrZ+WZTtRYe2fQTTpomC6uh6NR9E32vayzvhe0k40c
	 kF15GSvu/WA/piMwmj5xMdmcLB2GCiW7qVUjmRgvNTSM3GCXtQFtIG/CUBYVtNZumo
	 oPeXWFgMfWwAw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.12 0/2] Netfilter fixes for -stable
Date: Mon, 17 Nov 2025 21:28:57 +0000
Message-ID: <20251117212859.858321-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains backported fixes for 6.12 -stable.

The following list shows the backported patches:

1) Partial revert of commit dbe85d3115c7e6b5124c8b028f4f602856ea51dd
   in -stable 6.12, this patch does not exist upstream. This unbreaks
   old nft userspace binaries which cannot parse this shortened deletion
   event.

2) cf5fb87fcdaa ("netfilter: nf_tables: reject duplicate device on updates")

Please, apply,
Thanks.

Pablo Neira Ayuso (2):
  Revert "netfilter: nf_tables: Reintroduce shortened deletion notifications"
  netfilter: nf_tables: reject duplicate device on updates

 net/netfilter/nf_tables_api.c | 66 +++++++++++++++++------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

-- 
2.47.3

