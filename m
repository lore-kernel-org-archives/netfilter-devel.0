Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C69493621
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 12:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597601; cv=none; b=TzehHMD6ZfNecUrmt+8EhCUeIixVGynKat7ul1h2/RS8n/6yIKJP7VS14Jwd+YIgXH3E46t+89xwdylm1zhF1fAdT1zlSZ29wWi30ExvHgeO0TAnyeLrlx8Tt7P6yt5/MQ8lYZTaGLAn7VxNjwRQJswYXylWKTfiAxQbbduWQUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597601; c=relaxed/simple;
	bh=yDjXj+JRBMvv1m5tuqKBbxO5cPRGMU9ZXtXwZs/trSQ=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=kRTT/NBSO4E+wuuc340RBoTP2mdveL1UENwG8z4NkdYBxA4dVXQfJFS1tOkwfUT2L1YglVdst6bcXaCmg26uZvhkJ8YF0yh/5Rv6YZgJKEM0mOlQpXiZ/BjXN9vlj8wF5vPO3Js/+CP3GUmNQllhlQdNlffPUzvfic3eOnxV+CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQqgyxM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQqgyxM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6A11F000FF;
	Mon, 28 Sep 2026 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790597599;
	bh=0O0ws+ONbO7EDurS4fhp/iCatQQ9z7yMuazDsX2DUSg=;
	h=Date:From:To:Subject;
	b=LQqgyxM4pnXhUWLTlta+1oudVDtST8deg2NRKslLHOTEvb5q94JfTyQUnYIVt+jVt
	 7XdTDdQ4MzWiwoVgc1Wa+85IYxPh+nJQcd/ETp/fXwzN6Fr4bJAhq/cMqc0GYcfd+B
	 xQj2VdFYYowI8CxHLksUhrtVHMvSAcTZ9PlrpS0cglqediFHGyz8eLkztYjLofGb7b
	 JGcUWBuwNFYp6aF2Ry37xRuufY0GWazQ7YDdjY3o0tr95X/IN4JBqJV7d8WpyjzzHY
	 iA0L0FZkm1l9THw60dS1TrT3rMsCgfBu+Hks/rj5+8zzI4q1lRdl9nuDWIFXwZ8opM
	 tKgC6oJseUu+Q==
Message-ID: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
Date: Mon, 28 Sep 2026 14:13:16 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Matthieu Baerts <matttbe@kernel.org>
Content-Language: fr
To: Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
Subject: Netfilter: match "tcp option" with the same type present multiple
 times
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello Netfilter devs,

First, thank you for maintaining Netfilter in the kernel and the
userspace tools.

The MPTCP selftests are switching from IPTables to NFTables, and
Clashiko reported that this part of a rule wouldn't match anything:

  tcp option mptcp subtype remove-addr drop

When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
added to the TCP options, it is added after an MPTCP DSS option (type
0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
(type 30) options in the TCP options. It looks like Netfilter doesn't
handle that, because it stops processing other TCP options when the
expected type is found:

net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
    ...
	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
		optl = optlen(opt, i);

		if (priv->type != opt[i])
			continue;
		...
		return;  // <== it will look at the first MPTCP option
	}
    ...
}

It looks like it shouldn't stop if the wrong subtype is found, but the
subtype is not compared there if I'm not mistaken. Should there be a fix
to support this case?

For more details about the Clashiko report:

https://lore.kernel.org/179058242453.3145.1450534124183352369@kernel.org


BTW, I'm probably missing something, but adding the following doesn't
seem to have any effect on my side:

  nft add table ip filter
  nft add chain ip filter OUTPUT \
    { type filter hook output priority filter; policy accept; }
  nft insert rule ip filter OUTPUT tcp option mptcp exists counter drop

Same with "mptcp subtype mp-capable", other subtypes or other types like
"timestamp". But if I use ...

  nft insert rule ip filter OUTPUT meta l4proto tcp counter drop

... then the drop is effective. Any idea what I'm missing here? :)


(Also, it looks like the MPTCP suboptions are not documented in the nft
man page :) )

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

