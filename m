Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B4557F723;
	Thu, 15 Oct 2026 19:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092995; cv=none; b=aMepm4jwlN7SioHp/YOMpGLnugEtyi6vN9sDMGCzCjMIXgOZZ3DHzQT74UuvAkK6MBeObhZ5Ob9UimFpM61aRZmVn5attaWvhAhwujJy2hSIw4NxwQNXy0GtwqAZ/1dX9V7I4MuqBZ/G2tbjObLiqY7a2OX6fNvmiLExaA/P6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092995; c=relaxed/simple;
	bh=m53enD+fhYXRe7YAGr6/pnaG5LsPB/DpuQJwbu/DVSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpmqO34HC/kVNWN5z3YAd7zEta9bbSTAhoaqQgbjFxjI9uk+o0xgUfe8tlBwXxPsa88OoUsMF7CK27xBJQa03M+GOqL3CXoEyCRCNqsIfCEQGFK8HEWh6jvdDdVDHTKjE88M8lJn42xfHx0pUq6DjmjSvqntWcDhKXev2vo5rxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PWzlnFg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PWzlnFg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889471F000C6;
	Thu, 15 Oct 2026 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792092994;
	bh=C4C5BfXpN++eRrWMlSA6UJCJBD9o9A0XwfvhUhTIWpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWzlnFg/h8LEag42V6R2E+TE04dtVfdX7Ez2GAsf0FKNhuwf8jQyHzfIItMUKlqAT
	 g7rhc8/Qq+EzqljaXbifgUp3w83mvLsR+mrEiUUQRZY17QoZ32pFj17M8Se4oi6ZBD
	 rQJ0iOo/X7FyFtXp9a4lDq+WO/E+RjJyG8GMlAGaTokH8lKPNEHqFMXhIuCeaDKUhB
	 rV9JzVtBnuhrvbWsrO9NTZduQz85ABk8nD6mGxuYT83MUaARbn3p2eJYEzp72uiqCH
	 dhndon6qPuFwm5LJlnjM7OEFJsJocQrDDlRFkg8zVOFDtaJbAnBPHDtyxuXqXbvEnv
	 3s98uFRPVO/Tw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Vlad Buslov <vladbu@nvidia.com>,
	Daniel Golle <daniel@makrotopia.org>,
	netfilter-devel@vger.kernel.org,
	Gyokhan Kochmarla <gyokhan@amazon.de>
Subject: Re: [PATCH 5.10] netfilter: nf_tables: fix bidirectional offload regression
Date: Thu, 15 Oct 2026 15:35:54 -0400
Message-ID: <2026-10-15-1-daily-reply-0011-nf-tables-bidirectional-offload@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015112533.648137-1-gyokhan@amazon.de>
References: <20261015112533.648137-1-gyokhan@amazon.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Commit 8f84780b84d6 ("netfilter: flowtable: allow unidirectional rules")
> made unidirectional flow offload possible, while completely ignoring (and
> breaking) bidirectional flow offload for nftables.
> Add the missing flag that was left out as an exercise for the reader :)

Queued for 6.6, 6.1, 5.15 and 5.10, thanks.

-- 
Thanks,
Sasha
