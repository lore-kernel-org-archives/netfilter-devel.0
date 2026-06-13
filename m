Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8246A303A0D;
	Sat, 13 Jun 2026 14:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781362304; cv=none; b=KgayPzlfIwEGwWmD35AIrnvFbV/eb5FIssWX9CDEdHICUjrTR6QNV5cXOvU8T7gykyUIEbEMzJ5MqEkP3MY/TK2KmuMFa8QOmTGsZZsUEGF6uK5QYYBuPwnbjEtYG7997YxUAxsRVcNlALjnNkc5odkAQyXUYw1jBwEmhQ7IPCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781362304; c=relaxed/simple;
	bh=ZY0dkVASdT3ZNWtMUdM3c1OWVTfzdIKPC3zNXMLJRUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkYjhcBCFWUiHVbHw3ItuENCb8z7vYjb7iUlo4wPKeot/lRgJiBUV7mUAO3l5YrxKLbjMLM4EnligODRYj/O/VM3eOTY1D8siYDyCCLcqgVYWG69BcLkOlqr1R6j6cTy+XXQh1X7XWx8HP6Uc7/hhExoGvgiiDoQmaDXhooO21s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6xy9N4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6xy9N4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEF01F00A3F;
	Sat, 13 Jun 2026 14:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781362300;
	bh=ZY0dkVASdT3ZNWtMUdM3c1OWVTfzdIKPC3zNXMLJRUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6xy9N4LAcZ2QAXmOBRn3WK+ymeE+NBnJmlnZuHJFxfynCIqGGS1IVUpDMfByyKyZ
	 nIskAqe5wU7tcfe0L7O40HtuVFH02MvqdQiUnBYC7iRpLjQZALQCSGQYshFF2mUCfT
	 Vu3qsiNig1nyjJa+Wo+nk++60Z4VYb3g5uSh4nX1FccY/547lx3EbXxpT7tgq+VhRw
	 OmqqTmjnItuB2tCcgxEsqmJawHPo2vJoFw3rFUBZIlyQw5Zv59B7uiStm9FMEyRSrx
	 iGPtMFjAOcDj3xL4UchEVr0LLDj3htQDX37i5fHGf8XraRKRLFbnqLVSuzEKGxRis7
	 VCvl6gOwtFkQw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Mark Bundschuh <mkbund@amazon.com>
Subject: Re: [PATCH 6.1.y] netfilter: ctnetlink: ensure safe access to master conntrack
Date: Sat, 13 Jun 2026 10:51:29 -0400
Message-ID: <20260613143003.0004-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612203906.1139574-1-mkbund@amazon.com>
References: <20260612203906.1139574-1-mkbund@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, Jun 12, 2026 at 08:39:06PM +0000, Mark Bundschuh wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> [ Upstream commit bffcaad9afdfe45d7fc777397d3b83c1e3ebffe5 ]

Queued for 6.1.y, thanks.

--
Thanks,
Sasha
