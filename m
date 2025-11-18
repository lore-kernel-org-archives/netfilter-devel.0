Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC69A2D94B9;
	Tue, 18 Nov 2025 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763427921; cv=none; b=SBucsM6XG2behuXcpuBoSvsZ2G7G9aeHd5bkhRM+lUNcDtN5oHA4VAJIKKiQvBFFXmFGqouBU/f9nWennU49f+oCgESjl5b4o13Votwiozx2POK5z49vxmsHJrAvpCKX1h9TBQF+RAlFuHNDKOaMQOW5XbRbHjDLo5l2rWGND7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763427921; c=relaxed/simple;
	bh=PzV0c0sqvr8ORwUIKl8WKcw16mVdkiKtVU8Dq1Lafbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDF/DyOxWjIKT7QippHd8flkOr0B4ILBfLqBo0cQLDEhyJ7B11CgSeATwvLqItxP6dHLv1t6NaNkrEPdFjrb6e6Ok4HiAI1cK3LXgH0i8myxgfWunFQBrDq+UKJeHBD6PA8Vrel69ieVrJQX1QyxBKhueFsAs4YsXIEKjbf9Ykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ovvh2G/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ovvh2G/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6608C2BC86;
	Tue, 18 Nov 2025 01:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763427920;
	bh=PzV0c0sqvr8ORwUIKl8WKcw16mVdkiKtVU8Dq1Lafbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ovvh2G/RSpNuQGoLSu+tZcuXzAsx1NGUqKjavC5JSWig1p+WEzZcqMwFU6keCaHoe
	 s0hqv5HUJ3akGba87Hvwf8IoXS53gdE6WLRYrGz5m5RU4ltlRL7Usts8L0iHRQ5RUA
	 kjdXUM4dsaWxhshng3gS1BYCmG1QvMxnPy3vh6M8w6kS+7nWyZ3WjKsIyQLBhIsnFF
	 nzc2rS4fDyU6EfnMb6rbz4JfQGeI2QplPqbaueX8Pibo2IZx7cFp7zjFAyptYUbtjS
	 KE8qJMe1qeZ+EZF9nNubwFfZA0yVZDVLYxg8vuYDNtwk/4a/jQf4ljZbB3I1WTYy9x
	 GwK+bUKTog63A==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.10 1/1] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 20:05:16 -0500
Message-ID: <20251118010516.4139867-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251117214047.858985-2-pablo@netfilter.org>
References: <20251117214047.858985-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch has been queued up for the 5.10 stable tree.

Subject: netfilter: nf_tables: reject duplicate device on updates
Queue: 5.10

Thanks for the backport!
