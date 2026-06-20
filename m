Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D0F392C28;
	Sat, 20 Jun 2026 11:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781956508; cv=none; b=tMokOOHmPdnHV7sZeRM8aVofwBeXLnO3h05bs1cs3jS/pIiTZu5C1iuV87Oe+C9Y3yMCzwdeNhMpgWX5ZYU6waJGkN3faePUazO7QM0zPBumGEfppv710rlKsOBljX9OGoep5w/tW7caRyUkQG2TlKIbOB6+9rPIPLUiJTmFSh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781956508; c=relaxed/simple;
	bh=GrkI7+TBzY8SA8Ry5eLxaHWyBkc0ocX8WALmjWR1HBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/oLyQU//CF/mEFvcCtjU2YHW0fsyAv9OYPUI4ctU0aDnAgGdpMw3CdTNHIiGWfIIbgHak0Pcu5MJ/50FnzApgFkrVW6H8ZmZWY+NnXCw43YwumdxMshIbDclG4DQEIkf3phQVfsI5xfYqGKucisu5O5OeBPzUhNjoYMn6V30BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMZnVmXR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMZnVmXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFBE1F00A3D;
	Sat, 20 Jun 2026 11:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781956507;
	bh=hPnk0R8V3mCAmK/6KNk62qrYp7PI24nMqvfDkXFCGEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMZnVmXRDx8b5/A0sghFqKlV3GySuuJJDHPdTSLUr1xmDdAXO5lf/PwWXJGdbPqVn
	 V6Qj6nY8RMogTVXz7LyKDE7T85D1EyASzFhCVaZKFyQwkz9xXC/FP6FomU/oZJeF14
	 U/V1Aqleky+wJeQH+4yh5RhGj0I9PpfnT2eKL0H7iPO3dz/kupPxwYRP7AxQ8IW0Cx
	 NW/geufOwud5oF0ND1opX1Raae1cJG+mrLM10GuIvQlktXp1HZ1MFb9gUQy57mGAOu
	 TKR/wMdEgSDlIYTEgStuJubvj1d81yutP8PA9CdJEVb3jzqttHiVbKAQruQ3FtZ6bi
	 tqAOmdl9bHfXg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com,
	alexey.makhalov@broadcom.com,
	vamsi-krishna.brahmajosyula@broadcom.com,
	yin.ding@broadcom.com,
	tapas.kundu@broadcom.com,
	Yiming Qian <yimingqian591@gmail.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: Re: [PATCH v6.6-v6.1] netfilter: nf_tables: always walk all pending catchall elements
Date: Sat, 20 Jun 2026 07:54:54 -0400
Message-ID: <20260619.0004.reply@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260618083438.1269242-1-shivani.agarwal@broadcom.com>
References: <20260618083438.1269242-1-shivani.agarwal@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH v6.6-v6.1] netfilter: nf_tables: always walk all pending catchall
> elements

This one didn't apply to either 6.6.y or 6.1.y.

-- 
Thanks,
Sasha
