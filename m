Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0988A2C3265
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Aug 2025 07:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754985067; cv=none; b=ARF9XBgm3Ea76swyMvLZmFTrPb1LLt+tHJ722RMS9SFJ28KNV/d+jtLqQxRIH1q0irmw/sj6t737qb92GHFsAMddcxO6b7WgjDamONtI7s98B0sGYfPE3D1Wfw+9EegNAzy7UZNH7lFJ+hvwRipAKRgnxFQ0aL4j3HuQaZlL+XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754985067; c=relaxed/simple;
	bh=6FcqwIFbYDR7SR+Vnwf1iscwwu1oh82gRRHzaKm0EX0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=ci8Pru42K8pJfhJ0fYRR5Lq71GLoJOvvAAbyccVcZxLGV60fqLyDe+MlFDfRqazmwc9Z2+UA4tBSwYTppDgfy05E4rCYpG1xF9sCBwB6tfSaM7kzOwuZiiK5KWD4ylLhNhKyB+Z/jdG1IPzv1BDODtdiQVCYDa6CNeTWphWQs8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b6NAbyhi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b6NAbyhi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754985065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l0TOi3NsfzGGG2ydlG14RKfRoWrXPVBirqvc7jxpA/s=;
	b=b6NAbyhiBdC9JackNSVUCnPQS3ffVRa5aEtLueK0LW5JlePxnC6T3s7C2QKlJUjsJ9foKG
	ErXuchDBtHJHbIrncC9LrIpYnCwGxw2BhFDfbzCJdEHDpQPhrMn4mO2vyVzjJETeHLQysF
	2UpbEhse9fMLuzEhyr9Ppfvion6xr2A=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-mUubDZ0ePRScWaR2rDYoRQ-1; Tue, 12 Aug 2025 03:51:03 -0400
X-MC-Unique: mUubDZ0ePRScWaR2rDYoRQ-1
X-Mimecast-MFC-AGG-ID: mUubDZ0ePRScWaR2rDYoRQ_1754985063
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7e826e0d7abso1067495085a.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Aug 2025 00:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754985063; x=1755589863;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l0TOi3NsfzGGG2ydlG14RKfRoWrXPVBirqvc7jxpA/s=;
        b=Q5xruODDv5TjEN8846uhOXTYAlolpDxVa2gb0AWoGDxNCrXn5UxpnwUVUVwwkvSKlw
         XWu0dTiLN1XMXmAM6lHYsVnYV3vI0O4doOBQMIZNJopwChlhnheeD4k7DnMyVrC0/Omg
         mg9jE5CgL9ILzx1Ti7SXDaIf4QohU7+45gg88f4Z1Fqli7Hyqf0SxLYJBthaB57w0SGM
         1XX6O65ws8NSAqB2m9qohh4s5ko7kS6xJL2kqZoGNflcwKStyAecWc2wnOTBplSUyIGB
         OLK8sSnAO+vwz5Iyy+KgZZ3Pw5rF8mqqApzzg6f1Ff4aVHFF9fDYHsihr/2iURarUCrp
         AZcg==
X-Forwarded-Encrypted: i=1; AJvYcCW7ZZLbnoJnGJ27Wofntp+xxEXrOy3UTJIipXH5axqJZYVC6bFSHMGrVk5yMQBxmtQCQRNDSetHe/XJUzKVpyY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+1cvkgM6dN0lF6y0TS/Kpho29AL0PdG21JWO1FS8ZMwXMht57
	r4iARCqNkrPDvNKMr2/Zd2/l83HNLZ9VjFCeQhc+KQHGKXJ43czx8/jOpjKip29Q1dJBnQL2b+O
	sobcqLFn+jCMa1HqIXVhc7N6Vfk9JGihqhmkzZLdwLQZu2zLETl4dk1begg4ktsM9zBpCIQ==
X-Gm-Gg: ASbGnct+5OIB4sSPw+6WjYFSZQ4x17ivgG7mnfwb05hfBIJLpijOHbtBrT3MIER2ggO
	TCyAm6rkuvIxKnw7ffxpgYdLjgdKWB47VaLzEDaHMiGiMHSQAb5WIX6ctfhrImJhpLc/NTFCnDb
	l1GZVs87c1KpnBTpd0HY2zbYbbdqSuNuYE+5ny8ZRcqKjQeViOxFOKhmdqG/YIqwERBVMrNZtiT
	9N6UC5s55rCTyG7aR9rs7VMdJmHM5bsji9WFsTXPB+pr3ERlyhx3vvhfkO7buhndcyQYH8Zr2sz
	rOxF80iFjj0PNM6o5EemmOFkmzMj8hZtLr2fmjdOgSE=
X-Received: by 2002:a05:620a:440b:b0:7e8:2c04:140f with SMTP id af79cd13be357-7e85880b848mr380958685a.14.1754985062598;
        Tue, 12 Aug 2025 00:51:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUbrxFfx8sd2v6OC8+o0ciYcjY42jBqu+ZlCnCG2eVlRZMAQbB0VdkiXLS9g6iS/ke0yILRQ==
X-Received: by 2002:a05:620a:440b:b0:7e8:2c04:140f with SMTP id af79cd13be357-7e85880b848mr380957085a.14.1754985062096;
        Tue, 12 Aug 2025 00:51:02 -0700 (PDT)
Received: from [192.168.0.115] ([212.105.149.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e83515176dsm659068485a.44.2025.08.12.00.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 00:51:01 -0700 (PDT)
Message-ID: <766e4508-aaba-4cdc-92b4-e116e52ae13b@redhat.com>
Date: Tue, 12 Aug 2025 09:50:59 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
Subject: nft_flowtable.sh selftest failures
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

the mentioned self test failed in the last 2 CI iterations, on both
metal and debug build, with the following output:

# PASS: flow offload for ns1/ns2 with dnat and pmtu discovery ns1 <- ns2
# Error: Requested AUTH algorithm not found.
# Error: Requested AUTH algorithm not found.
# Error: Requested AUTH algorithm not found.
# Error: Requested AUTH algorithm not found.
# FAIL: file mismatch for ns1 -> ns2
# -rw------- 1 root root 2097152 Aug 11 20:23 /tmp/tmp.x1oVr3mu0P
# -rw------- 1 root root 0 Aug 11 20:23 /tmp/tmp.77gElv9oit
# FAIL: file mismatch for ns1 <- ns2
# -rw------- 1 root root 2097152 Aug 11 20:23 /tmp/tmp.x1oVr3mu0P
# -rw------- 1 root root 0 Aug 11 20:23 /tmp/tmp.ogDiTh8ZXf
# FAIL: ipsec tunnel mode for ns1/ns2

see, i.e.:
https://netdev-3.bots.linux.dev/vmksft-nf/results/249461/14-nft-flowtable-sh/

I don't see relevant patches landing in the relevant builds, I suspect
the relevant kernel config knob (CONFIG_CRYPTO_SHA1 ?) was always
missing in the ST config, pulled in by NIPA due to some CI setup tweak
possibly changed recently (Jakub could possibly have a better idea/view
about the latter). Could you please have a look?

NIPA generates the kernel config and the kernel build itself with
something alike:

rm -f .config
vng --build  --config tools/testing/selftests/net/forwarding/config

/P

