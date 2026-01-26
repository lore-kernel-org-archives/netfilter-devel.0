Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A120E168BD
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Jan 2026 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769449117; cv=none; b=C6ug3hdsmncA7ZfDK8YWU2XURmby080dtfIUwPZ8Q/Gnz6XiN2CdvY5BpTrHKLd1sHCp3pRRcwpiDWzJrdB7vfehM/82DeACcXqFQa9Jx5smAHQ0qlKiQwHmmeNhBT9EaQZR0zaOCKv2S621ytXw07dAwUxB2UMx+4Jhq/tgZRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769449117; c=relaxed/simple;
	bh=h6RfDwqM0jPtCc0y5wIl196B98bx6odnfoUTokMUQE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZL4AsPOX1rjJyQ+uVIbh7uDBzhTmBDl1IZxTSAI7j+0J7wuFnt7Ji3mdrqCyGoTNcLUWdHMoI7WCymrsd5MZ1XOl1jwX3hxPvskN7fdbsEGjHkZ7AlJTGbdmwX9uCIMzdjc6u8IxqjsTunbcXK3ZNXPwq3QpLwdIEvyvHMundk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=tM7DlsVW; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="tM7DlsVW"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id E8D8C295F;
	Mon, 26 Jan 2026 18:38:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769449111;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=h6RfDwqM0jPtCc0y5wIl196B98bx6odnfoUTokMUQE0=;
	b=tM7DlsVWhn+0AES1Ris2H4WXBSTrJhwSHzKFt+eMbX5fDuHOC/h7zQgBYlJlMxzE
	2+YqVAb+ugTFfYyhBrQQpX0IS7m9Cul4JNwKwqD4WFHoFVyhNpG3nRL9v1kPywx01z+
	I3ZYCO54HDDPiVV2bZh/pV/9Rxtepo2i9fP1IY+NL/03PtCvzFK9C1/zPFeIzrlMDhQ
	nMQ8cn7hFIpZkXZkYHRXYdfXyt5kHWd3kguNawrh+tncnoJqvEKeqVhVMlz7xsWfJS8
	ywoGjm1i2MggW4hA0N+zbC/0mybwSv24AXUmkEBCNtF63WgulTjFZ2dWsNPu7DpKg7N
	SkqyXwOk+g==
Received: by smtp.mailfence.com with ESMTPSA ; Mon, 26 Jan 2026 18:38:29 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: fw@strlen.de
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] datatype: fix ether address parsing of integer values
Date: Mon, 26 Jan 2026 11:38:12 -0600
Message-ID: <20260126173812.56922-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aXdZNS1fL36NL5vB@strlen.de>
References: <aXdZNS1fL36NL5vB@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Florian Westphal <fw@strlen.de> wrote:
> Yes, but it looks like it breaks backwards compatibility.
>
> 'ether daddr 99' is parsed as 00:00:00:00:00:99.
> After your patch, its parsed as 00:00:00:00:00:63.
>
> So I'm not sure we can fix this.

You're right, I hadn't considered that case. Thanks for the review.

Brian
