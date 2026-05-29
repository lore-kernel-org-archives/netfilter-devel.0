Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107D83C0630
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780051453; cv=none; b=GY8IdPNMcRJkZNLV4nvhmSqIKbc8yXf+QWgk8nYhjGAtyE1qpG6iX6MU5RcMBU3hPhV83/fZrQ2NPYOEwyDCWycJZOZuGGYDfdoA/A/rKIaLmhiCLtFZPC76J0GNInuI8cZQD87fGF08A5hMPjw1tU3Kxph13D6VkBuUH519+6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780051453; c=relaxed/simple;
	bh=I5S8k/JMKwGUwSZMT68XJfAURo2N9wKPHUe4tpEhYjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQoQ0vmuFLHqbYA8KLMZYCZgtoge+oLSoemCWRYyM5xqcK6zv2mB6vvlXfTkyGsxYEGpF03VT8dq0+Fi0WlNe/z+C12Ci1u04tQLJW2hsYLAQEvgMCoV/hNW36ZI7157GiA23Re3YoFJUW9lwvE7hN0C45EnQYd29GfC1DLZrDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jpdAWPvL; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpdAWPvL"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-841513664bbso4418627b3a.1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 03:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780051451; x=1780656251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dEo/wAF2Vg4x050FkAPkUeP1qeuJRwK4JVX4fGCPq9o=;
        b=jpdAWPvLXL/6AnocOgYKW9yHV6WwPO4S6Qe4PbHduN8q+13NGQdbe3QxqhfGaz1wHp
         ePZhwWzaYyY97KEi8jWiO9O0k+h+QY9E3Plvt4v1HsWdcbYDiZdJbJgs5pIusLjuSQXe
         vF0XqIi39Yzo3ehga8niAMLv1sMQmaOfTJcr9vjLkLuiFJ3ovR07ifEOrhmaBwaAowV5
         Z8toqXAC08NbV+Ea88z12IKX494x/BV5lfc1Kc4W5o5iMR6mfSfZnA5EsdM8UX4KuAxF
         iFuKCF1gKT1p+XCbRRmKtHOT6dIdboS9eydTfO2XRjqkVIkQvhNucEG9PjMGAtKfofFI
         oGdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780051451; x=1780656251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dEo/wAF2Vg4x050FkAPkUeP1qeuJRwK4JVX4fGCPq9o=;
        b=A8flSYfuoqoyt3BbmOixPioKnGzds5VUmNcFsBVmPTGUKbR194cVPG/WKetfGG4UXt
         fkN04vJVVKRI+TycuvfXynKYv1A8O8SiQ4Q1o6qJSQofLfndhqecTF3wsCoSlK2VWEAA
         Snw3x4Zbyez470xHFGQb+RRoaTKU/7XmpndWK1kgmduwGIwj8RrNaZi3wYoQ1e3x53Qe
         jssEQ/r3cINAvi45hmls7eSkDLWAucZ9oNM5SnOdYp68xUOe9akk6b9p8/7G/vFAygXn
         bxDM5fNigIZyovbEQgVxZNkQKRdFVRT5Xp5eVmVwMWi2MYqmnQ6sP4uIle8AyXmvXY8N
         g/xw==
X-Forwarded-Encrypted: i=1; AFNElJ/khKF0vu7W7LT+8e3wqPBoaCExuOj8n7aCdgGQrAqTgLw00wpiO41ILi2T4sj32go/QpFarOFccNEacWFJVvM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3/YEEpwTHEMCLflyaC+RmQFtbr1/zZIzsnXJBBZ9YqzIUx+Qt
	Q7u9PL4k7CctHbuDQ0xywENWXbO2BAZISTy8xHmg4zhWQvm89jOq2BvJ
X-Gm-Gg: Acq92OEBCDNicrnGWJuDqJEfVJhro2HsHbWiSDt2YJ2CHcajuId0jcEdv1JrvzWUABj
	fDyOF8LPpuGTcf9WUa0UV+PdIGDphqRPgoxs/oARY0MTP7JzALl0nJTt3H2N9PptEoBoBC0yMPg
	UQ/1wn7dHNE56T6VhGq8Y4uDJbacO2o0AeJdo+iimKQMq26DnbzOXrKJQzfE5C+8OT6/aZt0ZB7
	kGAjo2Kn2z0Wa/ZKiKnD2ArSE7dpS0bddNjPkPCKhyu+LWFJAY7mObl2bKVEzZ5GNn1U4eyIxPx
	foADkXn1a1Llf9mBjDgyLfaV4IEitHZqjfwOZphjNbQaZQ9HeiiEh9kRUzxv2mEO82kCH6Fox2p
	MlShCQiBNieUeaIu1a1BLac8CnddDk4lg9NzUUFCFPNrP2EuiHtFSuH7kM9OIpItoVQgrApY2Kh
	vW+Vx8LrBGxNlyOvnjQ2NhMp77UINCZ4+0q8AkWueVLUAFUEko5uGJwbA=
X-Received: by 2002:a05:6a00:2905:b0:838:5145:c1c5 with SMTP id d2e1a72fcca58-84210b3b262mr2263498b3a.21.1780051451262;
        Fri, 29 May 2026 03:44:11 -0700 (PDT)
Received: from teatimelab.tailcd024.ts.net ([192.129.190.145])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8421bfec5cbsm335418b3a.41.2026.05.29.03.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 03:44:10 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: fw@strlen.de
Cc: jiayuan.chen@linux.dev,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org,
	dsahern@kernel.org,
	idosch@nvidia.com,
	horms@kernel.org,
	lyutoon@gmail.com,
	stable@vger.kernel.org,
	Qi Tang <tpluszz77@gmail.com>
Subject: Re: [PATCH net] ipv4: validate ip_forward_options() option fields against skb tail
Date: Fri, 29 May 2026 18:43:56 +0800
Message-ID: <20260529104356.911666-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ahlfI38aDciPfG2S@strlen.de>
References: <ahlfI38aDciPfG2S@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Florian Westphal <fw@strlen.de> wrote:
> I'm not sure netfilter is the only facility that can munge data this
> way nowadays.  The plan is to disable arbitrary network header rewrites:
>
> https://lore.kernel.org/netfilter-devel/20260527121147.22076-1-fw@strlen.de/

Agreed, the source side is the better place for this on mainline.

I went looking for other ways into the window between option compile
(ip_rcv_options() in ip_rcv_finish_core, after PREROUTING) and
ip_forward_options(), and only found nft_payload and nfqueue at the
FORWARD hook. tc/cls-act run before compile (ingress) or after
ip_forward_options (egress), BPF at the netfilter hook can't write the
packet (base helpers only, no bpf_skb_store_bytes), and the LWT_IN BPF
path is blocked by the verifier. So your two-part restriction closes the
only in-tree triggers I could find.

This is just one consumer of the pattern; __ip_options_echo(),
ipmr_cache_report() and the CIPSO/CALIPSO netlbl_skbuff_getattr() path
are the same, posted as a series here:

  https://lore.kernel.org/netdev/20260524041442.2432071-1-tpluszz77@gmail.com/

so if the source-side restriction is the way to go it probably makes
more sense to drop these consumer-side checks than to fix each site.
Your call.

Thanks,
Qi
