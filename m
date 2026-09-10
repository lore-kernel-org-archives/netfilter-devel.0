Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A575F4BFE93;
	Thu, 10 Sep 2026 00:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789000739; cv=none; b=SFxgMDDMydrR1uDAU9EdbETzsr7Zbg4L0hGeSBj8HjS8HokgUNZhimpOtkD+ygelynmPwUjSDB9UbEDVg6b/WjuTNRgTpYieWY5OmsQd/vlCQJzu2qv2idGEziKecpuFD90W6Nd6W0pmg+Z+FyWJA7L3w9oUjWs7yKqM5kge79U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789000739; c=relaxed/simple;
	bh=PC/muC7umsFkorl+HiGjgCTIlUFIarijMRCVjihX2Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bvgzmvQArV9moFhqMuEgPteK86dpA20ODXqyAHF3331AyF+KcrTY7NS2ub2VBQ61tTKXk/8os+Mkk753nL5TuXoM271y+aWATkRb3ZwwEPtBCjM2Ny+Y+e48tSQp5JJBQ/DAnfrB+c0pDBRWwIrQ+ES/xkLwSmHngl8YNI4j6nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l6o2AMg0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6o2AMg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC3851F000FF;
	Thu, 10 Sep 2026 00:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789000738;
	bh=sr+LYBca4V0ucS7YI5y0aV02g8Yt0XXhYVH9vI3LAKI=;
	h=From:To:Cc:Subject:Date;
	b=l6o2AMg0Fj0mFl46Jeg0Pk7p2mCcGvd4I3WjHrJtBbaLQA8eYsFXHS937hpipBeUG
	 p5Lz3a3jcWyAkQ89bVtZDHmTwWJVoX3Vrvob5/N+qdGjanidalkUqZF8fL35JyiSB6
	 ZSWcN6MasScjT89torBdgEaof6gvmch6MFvNw4WjPbv+2GCZJzKpNspGKMMr2QMsGj
	 e8cYaYtusmta+CGNXtosqrvjsZKcViwgymJM0QR2Lree+gPr/MTJkEVuQ01vRNYvRy
	 PgAzLfCxYWUAo2riKmsgQNpNlU3dilFsx/m/0iGnGyyzIf5HI9XbZQr+5VHoZfBfwH
	 ObO2u7B8d+FVQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	donald.hunter@gmail.com,
	ast@fiberby.net,
	i.maximets@ovn.org,
	one-d-wide@protonmail.com,
	fw@strlen.de,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/7] netlink: specs: conntrack: minor spec fixes
Date: Wed,  9 Sep 2026 17:38:44 -0700
Message-ID: <20260910003852.2184031-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clashiko raised a bunch of pre-existing issues on a recent series
from Ilya. Let's fix those and whatever else pops out in AI review
and looks relatively legitimate.

Jakub Kicinski (7):
  netlink: specs: conntrack: timestamp is a nest, not a be64
  netlink: specs: conntrack: fix the get reply attribute lists
  netlink: specs: conntrack: fix SCTP conntrack state names
  netlink: specs: conntrack: fix the nat-attrs attribute IDs
  netlink: specs: conntrack: describe CTA_HELP_INFO
  netlink: specs: conntrack: fix the per-CPU stats reply
  netlink: specs: conntrack: tweak definition of obsolete attrs

 Documentation/netlink/specs/conntrack.yaml | 54 ++++++++++++++--------
 1 file changed, 36 insertions(+), 18 deletions(-)

-- 
2.55.0

