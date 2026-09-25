Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E883F1054;
	Fri, 25 Sep 2026 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790362095; cv=none; b=aQuxjViBXStA4miBBZGvv8Lr7Xov+VbE+ad9cq9fQMJkJ3GtHXX4Icsp5SPbJmboktpQsGAGcEtPNaUJYeHMHneZZraTGh4WUT8TRiCi/q1Ks+uiKJEBTk+wacHFTHoI06u7l6juAG7MW1Ul3XxoM1QQN2KiYWH37E8R2duA/YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790362095; c=relaxed/simple;
	bh=0H6ccYqbI2hcMxIUOoVvkuhP3SU1ip/JiiH9No7X7ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLYluo363a+K2lphHbGlPGMXo5WYTJwmbV7/KJDDvo/fL+uwBzM/wmROYvBZ1qAUA6eeEQTr5Z5GFnxSzEB9WLlpTbjojvpEB1nc5MuJz/gDDsxbubG1q6ZvoljlE38MHj6ASSr8Lzwx11WpitYZgOnjc/5x4YSY8G+ipe95hf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hsx2OoK+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hsx2OoK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B51F000FF;
	Fri, 25 Sep 2026 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790362094;
	bh=YB/U1G7HiR97zlQKfYIILR1p3MXgMHS4AOTS7YTlq7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hsx2OoK+InijxuOBg02JZ4LKP+AXSpCIrkV6k5ouNBesDp8fqC5V7L/RFXKaphkaq
	 DyGvGpPfJoPZjrq9pBTbK1gFnPbZmBzLGJorb3y5c7YL6DV616EmZYD/EyCNfasz9p
	 +q0PRp1ke7axUVUKvIN8VdKAGWGFhDs1FeZ3pW2CgcK8LwXwVorAxqfnULBNT77UIS
	 SsKUsTMZD2ki3gZc5i7qaHxR1pdG2kKm7nGqtCE0lb3zOuIfysYMpIGxH9h0uPkuFN
	 MzyjQ2/d6N6XxyRJBtj/yyOliTVK03kiYrTvGMWTc6ghn69EobaCnEcD60EH4n6qRA
	 XsVczxT8tMoIw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Yu Junzhe <junzheyu1@gmail.com>
Subject: Re: [PATCH 6.6 6.1 1/2] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Fri, 25 Sep 2026 14:47:55 -0400
Message-ID: <2026-09-25-daily-reply-0003-re-nf-tables-netdev-event-uaf@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925075128.646-4-junzheyu1@gmail.com>
References: <20260925020025.616-1-junzheyu1@gmail.com> <2026092558-grime-yahoo-6b34@gregkh> <20260925075128.646-1-junzheyu1@gmail.com> <20260925075128.646-4-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> commit fc0133428e7ad65aa6b7c8e65ccfe86e469e4512 upstream.
>
> Do not drop a netdev-family chain if the last interface it is registered
> for vanishes.

Queued the 6.12 and 6.6 series, thanks.

I'm not taking this for 6.1 though. It leaves a netdev chain with no
devices behind, and 6.1 can't handle that state because it lacks

  207296f1a03b ("netfilter: nf_tables: allow to create netdev chain without device")
  b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")

On 6.1 a non-flushing "nft -f" that re-adds the chain once the device is
back fails with EEXIST, and a ruleset dump that contains the orphaned
chain can't be restored.

For 6.1, could you either do a minimal fix for the nf_tables_netdev_event()
walker that Pablo or Florian are happy with, or get their OK to carry this
behaviour change there?

-- 
Thanks,
Sasha
