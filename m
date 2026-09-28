Received: from out-utut-a192.jellyfish.systems (out-utut-a192.jellyfish.systems [198.177.127.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3BF4DE711
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.177.127.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790609057; cv=none; b=cKlv4DTYFgI6A04HqmlAlc+B/SnDLQRMdNt/K0QLasYYeMyn6yohei2ElHe3mha1iGa8xeRHDyXUysdqHOcbL+MhYmyDwpeip60SvCo9OxlEx45WJ+MfOFFwK2o7P82THu/1rzyReXb5WBse2kJqZNuZex6v5wik6CrZwGQx/Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790609057; c=relaxed/simple;
	bh=ClKhGltR4eB1XFj3pX95qGxTIPfqSLxeNuu3Fnxr/aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsv0PMIhXmrF5XT/utxG/hNT/lPGWNi400fT98fL1kj4r440EnGWP9UoI79OLoRgjy/9Fa1Ix7rzP7GOThXcTBRlujTTd2eLr02nR25kR3XDSZHHONHGrmXTxnTZV4SwllnTkx83LbHXrA7Ohek13kAMeqIGYFPx9q20FHzjoXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=m/7CQ3Fa reason="key not found in DNS"; arc=none smtp.client-ip=198.177.127.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="m/7CQ3Fa"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4htlT52n89z6tkL;
	Mon, 28 Sep 2026 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790609034;
	bh=NcYeN5QvucJLvZ0yXZEuuOumqd10ui29ZwRx+Y0H3J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/7CQ3Fa1ZrXJuwD2ljKB3rlIgiCgvC6WjwOMJybYEyM6m4tmIGVOIBMbdDOGtrGb
	 yTdYofUvJzyk24+jcvvh3wfnZ5ky8dJuaZm9ieDTfP77NoOcy/wPLw1lgELtQ0xgEc
	 8NKRFxAuMgaRzArupY5rr9ysi15r/stuB10LQVQ2fEJ9gSNOZ1zR58OmuOAcgWIyD3
	 ZIlgIT09ddziYVUn8wJ7UzdD6SBW6J7ROX7B233BQbOH52HX+3iiAUp/T8vEpQ7Wlo
	 NvuLjdBtALHe8sitF5MZ2Qxl/X7thmGF2lrcPy36h7603C7OKBGyIwzInxMNF30Gch
	 yi+iE6ugzHoEA==
From: Rahul Chandelkar <rc@rexion.ai>
To: netdev-bot+sashiko@kernel.org
Cc: Rahul Chandelkar <rc@rexion.ai>,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v4 2/4] netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
Date: Mon, 28 Sep 2026 15:23:52 +0000
Message-ID: <20260928152352.143195-1-rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179053062273.2160803.6696795410529862010@kernel.org>
References: <20260923131501.2934482-1-rc@rexion.ai> <179053062273.2160803.6696795410529862010@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

On Sun, 27 Sep 2026 17:37:02 +0000, netdev-bot+sashiko@kernel.org wrote:
> Should that clause be removed, with the logging change mentioned in the
> commit message?

Yes.  v5 will remove the dcc_port == 0 test, and its commit message
will say that a DCC command with port 0 now takes the "unable to parse
dcc command" debug path instead of the "Forged DCC command" warning.

> Could the helper documentation, or this commit message, mention
> the limit?

Yes, both will in v5.

Thanks,
Rahul
