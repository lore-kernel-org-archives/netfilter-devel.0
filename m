Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C883D75C2;
	Sun,  6 Sep 2026 13:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701641; cv=none; b=mg4cJNhL6KsZ+gKIt/F8SWbQZP+GYxoXzCYljSk8gJcPZtcOl1ff65MNTkqWFOz9NQ/j4BDcck4uNK9SUsXn0OujDZmYAATb+mnCFT4BKFU6tiITOCgrzWbsPh+LZS97u7KgySy6UPNdJPTjDIM+9WPDN50awOtRK2qnejIABqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701641; c=relaxed/simple;
	bh=VSzsFfROQ0qjGYdPREcWKmUmn8KCt8Lpi/1u2GL0P1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYdz9AkiHwDJ6pM9rt9/Fy5zIv0PmErA6kNLB+RJjahX62Pk38jQj6/U1xEe9IJN2rzWVcN3CPKkmNEftekO0K2xB3PYTTb+kSnwHqYvlUAEukP3P8GsKN0KH4sUn0Lj2/NYDJTqwfkivIbDWnc98b+3W6Ltg+bRaPMqmK0oPQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPFs1vJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPFs1vJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D45E1F00A3F;
	Sun,  6 Sep 2026 13:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788701632;
	bh=PrrtWABTJ6R9cQwD0nncoOzeN4zhXns1H6XcXX31kO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPFs1vJYzQwJwtnD2FvBrophLmRpaiyjwGxeLkw81d6X4K2oNS/wBsoU7eRd2IvGj
	 Ky8bPNrZoc5sp+1DUkzQ1y6W/6HE3MAq/gfNPQnpnLm34xNNscu/2hYCy62iFoj/84
	 B5nHhOJFZmf86T7WnLip6BvPAfCAJdfJcdYjCb9nPOubXZvumnXtOt18ThFIsgcXZX
	 iSscM2M4K+nmZIAufAic6f7urVVOt/G82yexNZiH+BD0j7Q6rjU9F0ymAV09aaduep
	 8hGf2KJGjem3Iv0k1QeWDmkqTgdUKFRyGpLezQdC/HLVg5qBLQIRDK4ZAb01bzVFeF
	 Y5PLsrpOmRElA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Suraj Jitindar Singh <surajjs@amazon.com>
Subject: Re: [PATCH 5.10.y] netfilter: nf_tables: make nft_object rhltable per table
Date: Sun,  6 Sep 2026 09:32:57 -0400
Message-ID: <2026-09-05-daily-reply-0027-nf-tables-rhltable-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904013055.22116-1-surajjs@amazon.com>
References: <20260904013055.22116-1-surajjs@amazon.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The nft_object rhltable is global, this allows for accessing objects
> that are being dismangled from lookup path by other existing netns.
> Given the nft_obj_destroy() releases the object inmediately, this might
> lead to use-after-free of these objects that are being released.
> Make the existing rhltable per table to address this issue to deal with

Queued for 5.10, thanks.

-- 
Thanks,
Sasha
