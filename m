Received: from mail-pz2-f33.google.com (mail-pz2-f33.google.com [74.125.228.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C295847124D
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322697; cv=none; b=XeF5i3fMEQCsvW0/6EOtixhO9XewQRWvSbLaOUNJngQJ31W7QF6GnbZkmL+IfTRZFgahv8d/ckvJ4afpiXKmd1rvvUBUQv/FI7M/QmzVcCpllAAe9JPfz9S1P4uTZKx4GkgBV5hd9/fG8MBeRkZ8y9xWAT66JsQDFwWrWCwUcms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322697; c=relaxed/simple;
	bh=YdXCyiR4X2cySroqkx8YE1OuoWF4OvlRFcmWraKLe2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njrUZFvmV9BCxcltRCw5gmIRdr9lM5WquYDr/A6PheX2rcslfgJFFNihRV9IY8FJ0nX2pu8H4yxKAj28TF7KupKjIn1wsKEparvr04Glx3kUzgHjLONarKc80vhJfhcpwHmCbQ3g45uegZL+VWEaTUTwYPJrp1F2IaCWfuCBzKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJY6CjIe; arc=none smtp.client-ip=74.125.228.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJY6CjIe"
Received: by mail-pz2-f33.google.com with SMTP id 41be03b00d2f7-cc1ab18b3e6so18838a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 00:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790322693; x=1790927493; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GSaUcI/6lyKsTgmNsM+ZpbW2BjhwM28sFNv/ftCi/QY=;
        b=nJY6CjIeCMHEp6WfJ2lMUgPX/bQ4zhBS3qbJUZ9BH7eYJwzvQh97aOaWjTnXZf9axb
         7aQbWdrIwGubGq/0tLe4l0o2ysjctleLCZ+zqj26l9MPw5mtxdQm36vDMBz91rdal0EP
         a91fkZVhRil4Xu7wF+/k4AFkr9vHOz2cfz/jQYGvSUShkpF6ohopVqPoyTmaa0VK3nh4
         Z1lAEJhY6IoxgjExIhSQwNiPysop1JU4TG4uUyO62hj64VnEybjyfE2DTo7+cI3VVZEN
         OOA6W3izMorEOgI6qFmIljq+d3lAuqvRBrjnUH78Rl9ZOYLzHxOKWz4gGH2f+Qx6SE1Y
         4omg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790322693; x=1790927493;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GSaUcI/6lyKsTgmNsM+ZpbW2BjhwM28sFNv/ftCi/QY=;
        b=D4iQEHrBaKGlcsGnxHQXw0Va4AtSCswg342raaUgsDTVN/PHH9bfUwNwYIhkH41GLR
         G8Bhz7aigu0tnHDT24EijenVnVgdCPRxaTA//lE+LMjEfCizhs/4bY5A/b4rntFSuBVE
         VGD0I31Uin31Z9tpk9O6c9oL5VMyHHk12fJFMLk0dwzOGIL+W/ZCN5mPBSot49SeIMad
         y4YhCpSyvQOoIVE9wiLEQUqz+LpeDTdFhJUQNCOTY7Xef3FsKCOwNjru/xatwOqU52wQ
         MTSipQbw9mIGWLi3iI77DruM1b6rj7K4dh2ASnPcMHia/4EzVcLZzYBTrmeu4DxfX88n
         TtKw==
X-Forwarded-Encrypted: i=1; AKwUvBxwV3zRrEO/t7dgEesv7+jrlL3tQguJHLDavxoc5MIVXXvzUU6/7gUN+1tWNX3xjtbhxsmpd9mxe4sC7crWbXg=@vger.kernel.org
X-Gm-Message-State: AFuF++mqvqa1Uu3pf35FpUidsVktinH3tVHQIGmxRXwydqcH/UMkRZ6a
	Y7yNhtQgXQNL9X4DJ9c88fXXxRLk/CpEyTx4yOjJ6Y7ymb6EYSA/eaiz
X-Gm-Gg: AYBFou2XpIH9qN1lXzLVMhCcEYxYDURnfDcQQKeOwRyRpSrDn72vbX/zvwXsTjqZ5Ag
	Fet+tMEFPRuU2Mplbmq5j4kgLCaJMcw74bDqka0WMxF5zBGA9ySNQvB+DFNCDYu78GkmeQQaLVR
	gSNOfZ5QFL5Hpmaj12UG/gcin0tZ6aI4r2q8YM860MuUt6eoHHzcHBRNa8ovZL+vBJkh5YFmhai
	/F5f6uwDTmGR32dusBr8miOUjFXaJQBzYW5BM94pp/5AFtfvYshOHJ14UkIo3aliXHN0+m4mtbq
	sYZnPkyFexd5xZjCPY9ujEUONzGf9hy48LAwUjroioiC0SHMURPg8iJudMrlkleEAokZxGOF5/s
	kafY3uzviZT+qrtjlt0W0+ekVjMqenwLWZYNDYRigMOl6ggNtV4fbVtyXwkTatXKgfsN7lqEH7H
	a3VwJkuo9dKvEz5nG6UhEhiAC4h4RFCF7jLVUqF0QT4Ag8QdZpcWh1mLYfVxWp0ZqDqHjHvVIOP
	2OVG8T1hFM=
X-Received: by 2002:a17:90b:1c05:b0:398:bad2:c10 with SMTP id 98e67ed59e1d1-3a0b26674c6mr3027118a91.6.1790322692718;
        Fri, 25 Sep 2026 00:51:32 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc790c80e62sm255962a12.28.2026.09.25.00.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 00:51:32 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH request stable 6.12 6.6 6.1] netfilter: nf_tables_netdev_event UAF of binding chain
Date: Fri, 25 Sep 2026 07:51:24 +0000
Message-ID: <20260925075128.646-1-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026092558-grime-yahoo-6b34@gregkh>
References: <20260925020025.616-1-junzheyu1@gmail.com> <2026092558-grime-yahoo-6b34@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Greg,

The two upstream commits cherry-pick cleanly. They are Phil Sutter's
"Tolerate chains with no remaining hooks" (fc0133428e7a) and "Simplify
chain netdev notifier" (375f222800bc). The second is the follow-up that
makes list_for_each_entry() safe once the notifier no longer deletes the
base chain.

The 6.12 diff does not apply to 6.6 or 6.1: those trees still check
NETDEV_CHANGENAME in nf_tables_netdev_event(). So this is two series,
not one:

  [PATCH 6.12 1/2] and [PATCH 6.12 2/2]
  [PATCH 6.6 6.1 1/2] and [PATCH 6.6 6.1 2/2]

The 6.6 series applies cleanly on linux-6.1.y as well. Neither series
touches the rest of the netdev-hook rework.

Tested on KASAN guests, with the anonymous-jump ruleset from the
original report (base chain committed, then `nft add rule ... 'jump
{ accept; }'`, then `ip link del br0`):

  6.12.111  no slab-use-after-free in nf_tables_netdev_event
  6.6.157   no slab-use-after-free in nf_tables_netdev_event
  6.1.188   no slab-use-after-free in nf_tables_netdev_event

The same ruleset hits that KASAN bug on unpatched 6.6.144.

Thanks,
Yu Junzhe
