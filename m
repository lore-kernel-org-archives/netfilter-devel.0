Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793462329;
	b=FXVMP4D9f+BHDzldAF5gZi9T2cVi5XeAGDUUr5Yrs1FOsVQFp8vn1aDoZiRXwL62dqQa
	 /pzhubTcbmwBS2avSWEvw1m6LAaHQZrF+KJ1IGyOCvPx+rorLd4kx9xAH82k3u40f+I1m
	 jp4QcULlooWrugWsMoK2mgL6Dwp4Gi+F7tQQpYVMPmeKbnB9YmzszO6zkaQBPN637/VS4
	 NNiWIqcrdyJ8KsWf4yPchAwtO8veQ7BGv25PGo/dxpHVoc9m3WkmBWqVOpFp7iVJH1PUH
	 O1CoMF9pL2/Ciu6tm7WfhE1xt8hF6DgayxAW+K9Jw17b4M+wWJUmqXAYRU9YM+jQHHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793462329;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=+J/278MT0ISd228zX/Rl+3BAd2GoKGS/Y1M9sTwnLvo=;
	b=S6tl6m028Ywyqz7EHiCSbuGyZ2Vl7QFGd91he7ed/nXE5R7xLAv5j0B0pEaiaqAArY/r
	 oZK/0iF/QJft01So7+xsRHWQ1T/cUc52Pb+YB5Kx93AAFZ5dASZAw/VT5o5eZc1Yo5hBP
	 qugV1eIKHQ5dVeBCayM37ahvIXQHnbcvYuGzdpNBiM26UTHmsoeycFi9UZFSBCUJO9oL7
	 +s59Bm6xP7ZepITG6sSyRG7sBMUlL76U+O6kAk5uEq2teZNdgG88hoasOwFfsAK9tIjO2
	 pJlEODX9Jt+LQ8X50Z6m7fZZOwb2X5H6eTsP3HHf0tL3fLsVlFy/Oztlnqh7xuEEMvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=plushkava.net;
	spf=pass smtp.mailfrom=plushkava.net;
	dkim=pass header.d=plushkava.net header.i=@plushkava.net header.a=rsa-sha256 header.s=fm3 header.b=ourNiYYq;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=TM4edF4r;
	arc=none smtp.remote-ip=103.168.172.150
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4EA0606A31A
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 15:58:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4EA0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plushkava.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plushkava.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=plushkava.net header.i=@plushkava.net header.a=rsa-sha256 header.s=fm3 header.b=ourNiYYq;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=TM4edF4r
Received: from ams-compute-01.internal (ams-compute-01.internal [10.64.2.61])
	by mailfout.phl.internal (Postfix) with ESMTP id A67EDEC059F
	for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2026 11:58:47 -0400 (EDT)
Received: from ams-imap-01 ([10.64.2.21])
  by ams-compute-01.internal (MEProxy); Sat, 31 Oct 2026 11:58:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plushkava.net;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1793462325; x=1793548725; bh=+J/278MT0ISd228zX/Rl+3BAd2GoKGS/
	Y1M9sTwnLvo=; b=ourNiYYqIIKzS6tG50PpxUg9pvmkKQKsqchZ8dLo7VuPycW0
	S5+Pzfh9fNBAIyvKLfG1MKk94geFpaMbdE03vg8WN07ErzAcvjk4itzHezLa5t5P
	NMneD+t7AJCPlamq0vUI9lULoglPEIfEvYb1Pt0ibPjTKFaLZpSZebnD2+Ovk2s8
	/RrRgrHEVYvlhs2Cj8k6irpn/W+txg1NLp4aMye0OaOZ+z3Fh8HJiEV4jKQ9/F8c
	2T3x8VpAgP9CpEAfdv1XNkC42DqSfG6e+3dvYBBb8A+zP855HAqFB/ScEi/zZaYE
	Cudz11VyeHSEX2RBoNZXz6kJyKfwQ+JobnfF0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1793462325; x=
	1793548725; bh=+J/278MT0ISd228zX/Rl+3BAd2GoKGS/Y1M9sTwnLvo=; b=T
	M4edF4retc0nxh3wXbsbuZ5DEmT1NUjsd3cUzjdBD7tBVklQnx/uz5ZW1rvyKRRJ
	28JUIA2Uc2NDgV3ZtCldoAVtZU2RB5jp3ONQGRnqI8f52j5kOs/qCCwlkxuWHcUy
	5iuZWjcfYm9IAFdLHgKJkVAbR7Q3PK39bpvKcqL364Eea8SRPHftiQcknFwGIAsg
	YFAVNo6e3mmy7o1HK9zBMTJcYOO0dqslzu84jtsmMi+9s9cdYOtKEGv6nXD3ZDnF
	O/ufplFxvTvVqWfBXgEnbwe/8yLkVCBTcGRns88ymxDJ9EdxLVRpt/J+5nRgOub/
	yNA0ltCxUjEnLQJs0Dg4Q==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=sign d=plushkava.net a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793462325; d=plushkava.net;
	mf=PGtmbUBwbHVzaGthdmEubmV0Pg==;
	rt=PG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmc+;
	s=fm3:rsa-sha256:ltu/rLmQPJuAi4MheuIM6BOD2gjhKd4YLrcqEIUXbJAUnNv
	Ep6qH0Br5Sa3V/s7YT4ZdX4ylgtqzupxhXlV2Ai5JShuVmJQXAKoIKV04lRdUypS
	8a0zwk5WZpQbqeeYx/tjHKMd2xue+C2npowJDxAeSpv2fF/1VNHTyDet9nbHyrrR
	oP7kedhBn1X/M0uhP9Fmakj70mFAkz+7OVCTiLnlB7dE/7UJw5xOSs25UeQmzEDY
	Di6KrOGSBgBkERnyPnZNgKqOqnZxt5G+D58C+oKhxLEkw6Ft00Exd5dKpyViXKrK
	H+LYJrbJ2Zul19PmksjcGE+k7dmCtn5piKjHh3g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-08;
	repo=github.com/dkim2wg/interop; date=2026-10-28; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:98yi8HegUipbZecSMunA0iun0bdsJCsqeI/hN5vmK5g=:+J/278MT0ISd228zX/Rl+3BAd2GoKGS/Y1M9sTwnLvo=;
X-ME-Sender: <xms:MxDmajsi-y00OnzjD4tYBC6Xw96uroUo8SXVZQInuNtc_HVqtE1XDQ>
    <xme:MxDmavRoocgAXNBYExusne8B8PKhMFs6YKZq_pp0IrKZjU2YUzg2vMYM6CVWHh96c
    4CLkeKJ4ZpVEn8UH7EATYRrFJDwhoYujYuWDxF0TUFao4b_i8Sf>
X-ME-Proxy-Cause: dmFkZTFWO4LSJt1mdVwJ3yRAGNMCBdiwjlSZwcZW8i1IZkCsGdBv5YTZ0v7wzf409SBi6Y
    PvrhVgX9WddDHRTxqL9hIpzVX6bXUCLWGVzYiJ7liY1c7ssvoZtDqkkMnbs0G8NNT4F1F8
    DmW9Sms9h+H7fG5FvtTPZGGIMx8eD0j/YdxmS+nVOlTSfX+fbbz4fqXykp0NpIQAV+uQQs
    69L3VOGL4McnpAyGNeuaiWrlVnYMgcOD+eSD6VHFiH0TBtoUSgFyE22kAv9Yp6qJE7UVMZ
    JqX15hKELa6foh9Kx2O1SxjyQx4UtNxnhTKkSnb1KAP4yWP2WcQ68IRApKkcSR5JKPSAMI
    Igg7L1WWhQ2CAg3QUY3Xht7kvwXSQWNsbCmfWREfXDWx/MUHQTSCtW+cN8BZov6s8N/CCx
    wocJuIgADycldJ0n1bW0dzF6vPSdEncVce3L8V1FTx7cwaXbGiwNYLLFeXyqlA6u1IZ9SY
    j5ZRtJOGGY72hjSswru8rC+1+9Ttpl4Y6NLRKIjM/lR4koNlQ0NTeN0bvAD55BxbPFWKl1
    3CHfxcJcBaadKmZpwZF5ZXPqsycUtrtdl7pkbudTc+y5W78DcnWAIZZHoXfpw2D9cg5XBx
    nR3TSARws2fq+fNo/kLBwLqUOwFRIWEa5sq/laBhVGC+pDp2xgjmvTVS/aDA
X-ME-Proxy: <xmx:NBDmah07xJNZnwxpnWuHo3gvvbL2xpVPXq7iMmX2SAqUbdQTCefoDg>
    <xmx:NBDmajiH-yoNbgweod3bvQQoPHyIudcjq-QfeHgc_oUwF5f7LrA3-Q>
    <xmx:NBDmalb2HwiiSkhk90qJPrhy3r_z-ncqkDS6BwRieNN70F46RVuoKQ>
    <xmx:NBDmajQNYvOxcv-QAy3mzKbQeY3y9WHbrgPIjk-_KdfPPV7ForgJGg>
    <xmx:NRDmav45fxR7sOAvTnyp59UF7t6ZGgVjJfaVcTcphY21n2LLwPXC18sz>
Feedback-ID: i2431475f:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6CC34FA008F; Sat, 31 Oct 2026 11:58:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: A2_-JA8wPf27
Date: Sat, 31 Oct 2026 15:58:21 +0000
From: "Kerin Millar" <kfm@plushkava.net>
To: "Turritopsis Dohrnii Teo En Ming" <teo.en.ming@protonmail.com>,
 "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc: "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Message-Id: <e0e2e94b-2fc0-4b1a-8b50-bf419c554c7c@app.fastmail.com>
In-Reply-To: 
 <tFPvjiny7aomwwtbNLJpjkgm6IgE6hF9RwKQuO5ZQG6PeyBvL5F4BOOm_7cQTXn-fNYkHZOAQ1rRiGA5QyTPdvTyl8CRMNetEBnnOzr4Glk=@protonmail.com>
References: 
 <tFPvjiny7aomwwtbNLJpjkgm6IgE6hF9RwKQuO5ZQG6PeyBvL5F4BOOm_7cQTXn-fNYkHZOAQ1rRiGA5QyTPdvTyl8CRMNetEBnnOzr4Glk=@protonmail.com>
Subject: Re: Changing iptables backend on ipfire 2.29 Core 204 firewall
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 31 Oct 2026, at 3:21 PM, Turritopsis Dohrnii Teo En Ming wrote:
> Subject: Changing iptables backend on ipfire 2.29 Core 204 firewall
>
> Good day from Singapore,
>
> My ipfire 2.29 Core 204 firewall uses the iptables-legacy backend.
>
> [root@ipfire ~]# iptables --version
> iptables v1.8.13 (legacy)
>
> Can I change it to the nftables backend?

Having inspected the ipfire git repo, the answer appears to be no, because your vendor configures iptables with --disable-nftables in effect:

https://git.ipfire.org/?p=ipfire-2.x.git;a=blob;f=lfs/iptables;hb=refs/heads/master#l91

Hence, you are probably missing the necessary binaries, including xtables-nft-multi.

# command -v xtables-nft-multi
/usr/bin/xtables-nft-multi

--
Kerin Millar
