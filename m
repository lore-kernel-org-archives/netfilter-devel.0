Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9601E5B71;
	Mon, 17 Nov 2025 23:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763423311; cv=none; b=TGu7jJNuB4ovv+FNbYPgrY3VYJN94gC3GZtQgxTJTXD31QsyfbulFOTY7fnifzQv7i/xe2DMcH/ue/B08+Kyou7HbqCV2WpLG8SVx9TaGOjAPrkL+TGxKil6MWr6tpRaGBLqUAd07Pk94DIvqNjj669O8oeDwk/uKGlq7N2SfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763423311; c=relaxed/simple;
	bh=dce3cKwv/SFkJD9wsBKIYE1I6+rB60hkIWWJ42bAipM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nju7yXmm4tnWZjQzFusM9xOnTkbE3Cf7aCPw2c9vLppek3BpSZD1ZqiVA+wh7WlMf3H3GgfqUzaYUVeMWmc7rseVbI69U4K3KwlPOQvCD4otlLLAo7bO1/ndEYF20Q56X/TD7DwJivD0GbkAp9FA9zznaLOdZw8cRRRLzbb93mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NoU5VGqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NoU5VGqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D36C4CEFB;
	Mon, 17 Nov 2025 23:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763423309;
	bh=dce3cKwv/SFkJD9wsBKIYE1I6+rB60hkIWWJ42bAipM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoU5VGqI+aOD1ONRDIDUzRh51R2DoNumdgJiEB4GpKZej3nzzsEGau8dw0ZDZSHSw
	 yUdDtQ/5xDEuf/xumo0C0fcEJjXJ3VlkMdEktVCkSMnVjDaobhxTKguGwLYf/w2CGA
	 qUg97IgHSZEZROIqajRYPW6AwwiQLSZlCi14u6QiHU9+M1hqFaFo1MT/TyczH3SquD
	 dhYI+1RGBRntNAnk2N7YMB8nsq1xu+ngAFojQREDH+6O2ed2jGtwZoFv1XDx24SMJF
	 X2IRFLk9CrbSYPdw/9gwpDlptxT9ZU3mEv623EhG6vYtyVXwBPcBetH5ZCAre12osF
	 gnXvobEgtDi5g==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,6.1 1/1] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 18:48:26 -0500
Message-ID: <20251117234826.4125934-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251117213958.858900-2-pablo@netfilter.org>
References: <20251117213958.858900-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch has been queued up for the 6.1 stable tree.

Subject: netfilter: nf_tables: reject duplicate device on updates
Queue: 6.1

Thanks for the backport!
