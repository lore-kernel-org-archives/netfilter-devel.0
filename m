Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1342582
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Sep 2025 00:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757722422; cv=none; b=oGyspXDP+dG3KP692WBtnCzvHc3ZeVXb2fevw3aiH5iJw1BqZ80KZS80UkZFCQCV5RIlJuCikbN9IND3SDMGNb0tXEcpMAQZp+khOmON29bsuPrd5LaucQXAwBj/NIRFWldMtm2e11pWjeUfOTT1XK8xNRBWkuheRiV8OY/OLcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757722422; c=relaxed/simple;
	bh=Q0vsgHi8NTnGmFP1nhcA009dR0OCsgjtzKD5qIuk4uk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BHoUB6ZQI9kQLuRMXIW8kYLdRER1wyIj1z53m3F9ZGImCpXd0MGjY4AKqqSEk+ncXvqZWPwSA0+BSxHRF7WYQenHQj6kIvlqMPsUnC1G/S/dBibLUmTaId4Ew6JwyLhrNg6b81l3rLUcAB4ywWHBEghugEnqa2XMhR6W7icMHj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KpVgclJf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KpVgclJf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757722417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PVaoN6/mVDKAxWeqeC8w4uzxASjwes1hoGJEj/TabW0=;
	b=KpVgclJfKeRre3Y0BtbVTtOvOlWavbxYhVgZugWnC7sn8pOJVyv4KoXEgq8q5q/+7L7+9q
	Bc3FVNlCAX5HsoPZPAJn2FlyzKjNr0M/nYHYgtz/ytJNjnitTZ4YqTCbK5Z5BDCUedAW6W
	sbnKPFQiGlu3E+1rjmJzLppo+2fCQ2A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-SUBVfzn0NOKvoOwbNuijEw-1; Fri, 12 Sep 2025 20:13:35 -0400
X-MC-Unique: SUBVfzn0NOKvoOwbNuijEw-1
X-Mimecast-MFC-AGG-ID: SUBVfzn0NOKvoOwbNuijEw_1757722414
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e067ef24aaso1560991f8f.3
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Sep 2025 17:13:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757722413; x=1758327213;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PVaoN6/mVDKAxWeqeC8w4uzxASjwes1hoGJEj/TabW0=;
        b=wngNahBo1mqRLpPm1hsxEYWvpX/V2H07JiAeRokcBYg6LYtzH3zBcnhcPtbXAZvIwI
         p9ANNvoHbVQ8Q2JJD9VA919/BScwpPH2oXXLjmzx8MXDz8WmdIoAAS+IPVKBXkad6fS9
         CbIVwRx2845klSRdQj1vtNNfgcVCre+Feqk51xFyhwI8jfuqIzhI8TAkMi427t1d4Fjr
         M2w23Y1Gq1hu++MerDXKw0ZHOXNosyxeXnOExWoFgfBfLmemXzZPkKxMD/QJxraL94p7
         DGrKSHhbMpC0ffRa7h7IEEZDWdODFKT9hW7Z/JgCrlrqLjHwxTMYGm4+cu3KlCuyn+Zv
         FrNQ==
X-Gm-Message-State: AOJu0YwKxiP7n/B0ZpXtI97r6MNoMgk0P4seCk9N/qaDwb7IgyyaQGpZ
	u2GxZHjHpVfCtNaMTDNqtGxbPlmmpelKTl1W82l2cFhhjRJIatEJIKJmGqOr5MfJ6710MY1wsyB
	+i36mXk0gYrdHRinoW58B6tBzwHTIeTt5a2UUFYhbL+gUbHBFr73oZCSRVOaeuxjYQMOOI8v9Mh
	nyNw==
X-Gm-Gg: ASbGncvMdcXPR1rYMbjs/kwticKRGH09zxbJPmP4CgNL7opJ3J+ZoRvOsd/JGrBTyB5
	qst/P/8SnNFr5y/7n802H3wxAzar/+j/GZcJK44E229DE2RZZma9wNo9d05TXxo5QG2dmGMWa54
	3bXRoLtRJuc1r8lFNmAEVkqAdgflMBvNme4WnisqD+fJgqlGSohHhRlwv9CzuF8symNS3qFUcMl
	RKJ/ngzUqni5dZJoucAwjYYOBNUyTscqdRAmq9PI3KYq5bn9PYlsMdDCnyyKjLmmeFIs5UXvCFg
	RuSGco8jpWu9GkVL+hdoMu3l5r311ROtZypH1veP2lwnl5xcKQAY310xa+JYliGeHZ5K
X-Received: by 2002:a5d:5f94:0:b0:3d3:1ad0:e8b7 with SMTP id ffacd0b85a97d-3e765780aedmr4595363f8f.12.1757722413579;
        Fri, 12 Sep 2025 17:13:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFAzsCCN5yK+7fCW+eiIFscsquh9zcAii4pJ1S0n0PhOqj1/pTQncfXq8jAysRe9RatHZq3ng==
X-Received: by 2002:a5d:5f94:0:b0:3d3:1ad0:e8b7 with SMTP id ffacd0b85a97d-3e765780aedmr4595347f8f.12.1757722413153;
        Fri, 12 Sep 2025 17:13:33 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760776badsm8364995f8f.5.2025.09.12.17.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 17:13:32 -0700 (PDT)
Date: Sat, 13 Sep 2025 02:13:31 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH RFC nf-next 2/2] selftests: netfilter:
 nft_concat_range.sh: add check for double-create bug
Message-ID: <20250913021331.772eb857@elisabeth>
In-Reply-To: <20250912132004.7925-2-fw@strlen.de>
References: <20250912132004.7925-1-fw@strlen.de>
	<20250912132004.7925-2-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Sep 2025 15:20:00 +0200
Florian Westphal <fw@strlen.de> wrote:

> Add a test case for bug resolved with:
> 'netfilter: nft_set_pipapo_avx2: fix skip of expired entries'.
> 
> It passes on nf.git (it uses the generic/C version for insertion
> duplicate check) but fails on unpatched nf-next if AVX2 is supported:
> 
>   cannot create same element twice      0s                        [FAIL]
> Could create element twice in same transaction
> table inet filter { # handle 8
> [..]
>   elements = { 1.2.3.4 . 1.2.4.1 counter packets 0 bytes 0,
>                1.2.4.1 . 1.2.3.4 counter packets 0 bytes 0,
>                1.2.3.4 . 1.2.4.1 counter packets 0 bytes 0,
>                1.2.4.1 . 1.2.3.4 counter packets 0 bytes 0 }
> 
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  .../net/netfilter/nft_concat_range.sh         | 38 ++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/netfilter/nft_concat_range.sh b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
> index 20e76b395c85..4d4d5004684c 100755
> --- a/tools/testing/selftests/net/netfilter/nft_concat_range.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_concat_range.sh
> @@ -29,7 +29,7 @@ TYPES="net_port port_net net6_port port_proto net6_port_mac net6_port_mac_proto
>         net6_port_net6_port net_port_mac_proto_net"
>  
>  # Reported bugs, also described by TYPE_ variables below
> -BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch"
> +BUGS="flush_remove_add reload net_port_proto_match avx2_mismatch doublecreate"
>  
>  # List of possible paths to pktgen script from kernel tree for performance tests
>  PKTGEN_SCRIPT_PATHS="
> @@ -408,6 +408,18 @@ perf_duration	0
>  "
>  
>  
> +TYPE_doublecreate="
> +display		cannot create same element twice
> +type_spec	ipv4_addr . ipv4_addr
> +chain_spec	ip saddr . ip daddr
> +dst		addr4
> +proto		icmp
> +
> +race_repeat	0
> +
> +perf_duration	0
> +"
> +
>  # Set template for all tests, types and rules are filled in depending on test
>  set_template='
>  flush ruleset
> @@ -1900,6 +1912,30 @@ test_bug_avx2_mismatch()
>  	fi
>  }
>  
> +test_bug_doublecreate()
> +{
> +	local elements="1.2.3.4 . 1.2.4.1, 1.2.4.1 . 1.2.3.4"
> +	local ret=1
> +
> +	setup veth send_"${proto}" set || return ${ksft_skip}
> +
> +	nft add element inet filter test "{ $elements }"
> +nft -f - <<EOF 2>/dev/null
> +flush set inet filter test
> +create element inet filter test { $elements }
> +create element inet filter test { $elements }
> +EOF
> +	ret=$?
> +
> +	if [ $ret -eq 0 ];then

Nit: everywhere else in this file it's 'if [ ... ]; then', with a
whitespace before 'then' (same as all the examples from POSIX without a
newline). Either way,

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

> +		err "Could create element twice in same transaction"
> +		err "$(nft -a list ruleset)"
> +		return 1
> +	fi
> +
> +	return 0
> +}
> +
>  test_reported_issues() {
>  	eval test_bug_"${subtest}"
>  }

-- 
Stefano

