Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D552820D1;
	Mon, 17 Nov 2025 21:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415654; cv=none; b=O8vWKxAcCDNuonkE/s+cCVLDQFbS8VgXBuNEdbJGNMkQ217Il70o52nS32x1S5wrBQ8DEFZFB63ZaIuMUccboavCNPy8y7FIeGDYRfqNALzKqxyzdlUQ68pCu5bW/RV4kjeiB4p79X2lerLLZo1Z2buOo6tSqoRAX0hwyW/Idp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415654; c=relaxed/simple;
	bh=2L9MEP+tubxmFouodDkGZgzdSZjGQ4FKipA/69OQHss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hodzMeVvodrJ0/oEywbCGe0z/C93nvLIWAWfjXj1ss8I/OIDm2tRlKLl8ZkDPm4ZZbQySdFGL4v+9zZioh1lutX6TmRHc4PasdAw+rHk6Bm1SsOK6ffrwkf1VmDP1JSmEAktullAJRKZRlurXwko0ic/Uq17BCcmOQuLjSVgEZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HFQRtxVw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HFQRtxVw"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5FDD46027A;
	Mon, 17 Nov 2025 22:40:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415651;
	bh=UqXhDMDbe5RAOjZAmaa3JMJCiUU+9dCDXoCV/6RfTCw=;
	h=From:To:Cc:Subject:Date:From;
	b=HFQRtxVwF7Jn8vpqEEdSFxqlVr8EAW6tmpZ7fuRssweiAiRx6vThXztwPo+LsID19
	 8zxhQqVdKA+EuYbJvu+f4hb/1atbV8E+kHQxmWiknKrTi2q8HDyRLyKxV4uSAHUmXH
	 yBtaDKvbW+nYkH0011hy8pAV9LyfTMKG8XvfojXNtUQ3L/bxB8qiosYPmc7nb3Ki49
	 TkUEDBLHIVMYOSz/UaadxQrQgwbC70sHx4r0juBaGxgTDguCVZy+mBjf/Utwhr4Ybi
	 51nscp6tY7QkqZvY+17pWXg7EZhAFl0odRxHhL7OoxLMPKlHHc0a17UZSG6o6bw8p0
	 VZnKh1ffsrY6A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 0/1] Netfilter fixes for -stable
Date: Mon, 17 Nov 2025 21:40:45 +0000
Message-ID: <20251117214047.858985-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,
 
This batch contains backported fixes for 5.10 -stable.
 
The following list shows the backported patch:
 
1) cf5fb87fcdaa ("netfilter: nf_tables: reject duplicate device on updates")
   This only includes the flowtable chunk because chain cannot be updated
   in this kernel version.
 
Please, apply,
Thanks

Pablo Neira Ayuso (1):
  netfilter: nf_tables: reject duplicate device on updates

 net/netfilter/nf_tables_api.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.47.3

