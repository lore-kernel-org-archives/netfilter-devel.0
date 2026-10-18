Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3F53594A
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 00:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792281879; cv=none; b=YFnz+FVHWcmXS2ejJR8Zf+oRRCuPmYJXuTwGcN1aet2gB4HQQFSynkM7AV2cT7lGX93naV5DUyYxKH6psC/6r+irTQXeof4CHl9YCGbIbh0CVaMo89PpUvo0K6g+UdMwiL9TKQxjOzx46b44HLQxER/FFSyeUlYx9JolMFWNTv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792281879; c=relaxed/simple;
	bh=CRQqrOceBO7jj8qsVMNU69Rgv5g+O9xd6prK5pGo2OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dgtRi0APDT0ooXDw6xsgiV9s+vO67Vb4wtYS48eNN9p2Z4/WUHgik4gydiodAiFx5tAw6gc5bJhuLWWi/Xqv/UxeKo9luzxwU+Qa211GVMv4mTxSOBs+zAIlgc8b87BwkRpsYEFmyFK+Cq4QwYltPBgCU4T/Y9Vk4jWLTh3K9tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=wrS99lpF; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="wrS99lpF"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6aa9164072cso1228702a12.2
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 17:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792281877; x=1792886677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CRQqrOceBO7jj8qsVMNU69Rgv5g+O9xd6prK5pGo2OU=;
        b=wrS99lpFGWtZLKGWR0lQJ1G4dWf0F8rdvLmplwnrl7eZuJj9y+AAVPy61YLO4vSFko
         ygpRejT+eE5ojuzBoDX+28F6eP5HfClpRry2yUs/T4E5yuE9yIueVhWWuPU2CUjakexC
         3jj/AmhjLpgdirLaovAR5yC7REB2yQamlkStMvNe8Lenkw0iSrNr88TqvTWyVshTIMT4
         KlnTQXDnjRgDcPj2gyznwdozndDfPd12mBb2uHrs0jc9yvr8Te4NcCt3BRSAWeXqyCff
         quM2G7ZepjIb0f8un5GcBM1ep6MkPCx9V2Rk30BGW5FTRQI6/5Uq2QB70eMe6ZDKCiLJ
         0F/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792281877; x=1792886677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CRQqrOceBO7jj8qsVMNU69Rgv5g+O9xd6prK5pGo2OU=;
        b=JkPqJJ4bV4v5WF9l6Y7JiIE3YajB3/tN5RvPPCUAWNSVntY/PwR15zA//25tZ7Zae1
         BFZePDmIHAGtPrAVw1YdLgOehiMan4fQvmafP032UEMpVzLsdGheHuNS9kPaHnbDCxA1
         MURF8XJRYJ6cph8faeAMLiGtU6KhczE7Tc+8ZKUmvCNlrBKBjU5ZW4/4VbFhxYKmlCng
         UP8MdnySNPvb5T7KVZYFZTSVuWuHeqSewn56RMj50kKuik6gSz6CmwXAIgwNjp4457P7
         e1blGEM2b7or4t+aShQcw1556GmXxA6AY/vkQhS9twn6PdmbQkPsd9K8IsaS3Wx18s8z
         Nm7g==
X-Gm-Message-State: AFq9FYLy13nISmKDgcUMmvWF7GG160sFIqSSSI1NpMUkMF4WPi82nUjj
	DkYDerie0BZz57u9sULxndqOijKwshKG07SDdTfp1rrqiktvnfhuKkEBjPhcsh9fKw==
X-Gm-Gg: AYBFou0bHr+ydUHWASn1huSvIN668ag9hRw0Nn3wN3VBbbm3TYk7pGsE+A60lOusQOA
	yOjeGmJUUKz49KQo1L1JXN7fXLqtMzmgPJgDNXBnCJO9Mn/6FqrCmrUwo6ySYD/DunBIcaBgtFx
	roY5N05TzwSSQD5QP/1hUmUUxxUk+8mn72egPQnfE4toDSC/xfwCczTUJM1PuHlusWfRwa7++a5
	o/ergMunIZ3WXuD19Er79iATOQQkPiOjkZc2JmktV4MohwWoYkWNypRe0pOfWzBgdTDIcdYAPPE
	Ff5YkFh4DXyPd9Eg8RXgb7rLA7m7ZOkfrA1p3V7muhsjM5TzlG32Gg55ujEA4ShB+SVJqP157mJ
	6MDRAH8iYY3Bv7QXpRbBCI0STy6hQinj7jYhfgMh+87d4/WIWLdA6D00ss7wJaimQyE6gTceJL2
	xO0heimGeu48hXas1IciHxZFF5D50/TIq1GDF9l8H2vRGK3uSmLOon2HWQmE2UU7clTlUBrgPQ8
	N/OnfeRwSN24m06COqyRm515WA4zU9/RkDwJJdcfg1yPT29lKFkmc2aCO7pCGJkn7cbvelFgRxg
	I/JEcIjNaAnqb3/6X12lzzX3nZJAv09/CnCR6V8u6A6orOCX7mgU/W6p+dR28HWwwbljO+jMM2U
	RkA5hUlMw1R3DMgzZ4613ZP7GMtW39OE0beNSN8MN8cHPCY1UoW+OzGP7XYLZ1a6iJn4q33lP9o
	ms1PkBMR52CoNxyHXrgnTJeveKIzE33VusN1egIlFLuKzHwWA7kC9Qp12P8OdeAm6pXqIHorvTa
	/W0WTdG
X-Received: by 2002:a17:907:9713:b0:c2c:d06f:cf89 with SMTP id a640c23a62f3a-c419a942f35mr242613066b.2.1792281876811;
        Sat, 17 Oct 2026 17:04:36 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f247412f10cc8c3f7d773dd5eb.dip0.t-ipconnect.de. [2003:f2:4741:2f10:cc8c:3f7d:773d:d5eb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40912ce05csm213267866b.33.2026.10.17.17.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 17:04:35 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	razor@blackwall.org,
	idosch@nvidia.com,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v7 1/2] netfilter: flowtable: tear down direct xmit flows when the fdb entry moves
Date: Sun, 18 Oct 2026 02:04:33 +0200
Message-ID: <20261018000433.1466958-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atCsGx2IRecQNK3r@chamomile>
References: <atCsGx2IRecQNK3r@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(Resent as plain text, the first copy was HTML and did not reach the list.)

Hi Pablo,

On Thu, Oct 15, 2026 at 12:34:06PM +0200, Pablo Neira Ayuso wrote:
> > Assisted-by: Claude:claude-opus-5-5
>
> I did not use this LLM assistance for my patch and I show as
> co-developer here ;-)

The tag covers my changes on top of yours, v8 says so below ---.

> This comment is not needed? LLM likes to bloat code with unnecessary comments.

Removed.

> Why LLM decided to rename this function? :-)

No reason, back to fdb_valid_dst().

> I think bridge_ifidx is not needed here and I am not sure we can cache
> this value?

Dropped. The gc now walks from out.ifidx to the bridge port through
the vlan devices in the encap. A 2-bit port_vlans says how many there
are.

> Why do we need bridge_vid? See below to explain an alternative.

[...]

> A new flag might be need, but there is room for new flags to annotate
> this VLAN header came from bridge filter filtering, I understand
> info->encap is not enough.

Dropped too, there is a bridge_vlan flag now. For an untagged port on
a vlan_filtering bridge the vid is not in the encap, so the helper
uses the port pvid.

> Why LLM moved this away from nf_flow_dst_check()?

Moved back, nf_flow_dst_valid() calls both.

v8: https://lore.kernel.org/netfilter-devel/20261017235849.1066624-1-julius@bairaktaris.de/

Thanks,
Julius
