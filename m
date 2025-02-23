Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449FC2135B7
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2025 19:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740340739; cv=none; b=C8IuXZ1YDAUcBDcq/lg24xldOISz9b87pmZ/pKFuP5qYua/lYS0qqtyxmMH2slXnomoXoL2Z8BEvRv2u47SdnuDs+SyXRSiImxNP2tm4QDxl6dkoOzf/6u3ZSOyUjrXkiCY0UTnmpkEPpUUD4zPYnyFLPXZ6yGim9H3O0JnAUCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740340739; c=relaxed/simple;
	bh=hpL9AcRIqIXqyqiCj9GvPdRPNFUgv/c62Uh6HHqWllk=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=IBFyz2DigZL0bYHm+IqrfgJG0ALRx94L0Zt2b+j2BQ0IpkYI0yX/RaA+sJBLnk3KxT12OyQI3BgVXoMaztLjmFKv5GA2o328xRY9C7YVFc+aKhn5tDVGrsUEDYuA+xOfSdduQo5WpkICjh11VB89v/M/p7JUlEn3kNBtujXNXJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHeHsutJ; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHeHsutJ"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-855a095094fso97308839f.1
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Feb 2025 11:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740340737; x=1740945537; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:autocrypt:from:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aikn2ilCeHjjNUQaytN0R/nJuBE+Va7AG0qii0Pns0E=;
        b=ZHeHsutJutc5CSKi9FXKOQQhxYA1Xop9PFUdgWHaWoyUbvFHehihNReVsdhArJIWS1
         pBP7Al1AS78kTNjg8B2J1nmpopvONO1zlFDzCGjIeqhJTNYVYMnBks8WzkuAigGH8d8m
         gkfOc2NbuSRj7pNF6tTDruld2e1vGNr4j/bZeUIKd8hpBNUlwsh3xFp0lrsOYMezoOtD
         i4whwqxPLhlBgiQdMTCUrq2gS/Xc8kFTIWq3OjWgaJ3EKrnA8cHqPn6eY2J+wMq82V8O
         xdGEQewPmn9T4PE+y/dpNhfOmtCpL9le3+W8b1/IhhZvnq3YmxYTLOwMoJtGSMKQ6nYj
         lzyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740340737; x=1740945537;
        h=content-transfer-encoding:subject:autocrypt:from:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aikn2ilCeHjjNUQaytN0R/nJuBE+Va7AG0qii0Pns0E=;
        b=d93ci3qcKPRRagekccq2BhAKUV9AIb4Fy2dm7xWbKe0SZZOEyf58siZlOCzJpVULmB
         0u5MkkJkUHWAcCtEBd4vzFZbnL2LT3yn/ZpoIk6v+6ar0T5jrA/9niR92c7UnccYG8S/
         rQbKhHGrq1qWU+MOTf01ZB8sTDtIfw7FHeg/+L9EsiKuZ24J8txZwEaNoIYSkEWdlnD8
         UlsZW+btxt4pGNJeohITWjZwAm3g1r7J1jVqwy0h1OxJPtLi50MF7JnZ09PqVqLI94MP
         or0NBAovu1o0dBqS+tiGIt/dSLP8c2+95jn7CkF1d59rxeObza9Rg+54LvKkTqooWM43
         wEow==
X-Gm-Message-State: AOJu0Yx94k89q7/Ii56NMLWRhmCDbkfhn8a55a3AferC18wURxCXER8V
	7rJPAeN7vdDMN7a1tIuZ8abpRInVvhzDzIYzfstCgt9s2I53ZlsPg5LjnA==
X-Gm-Gg: ASbGncsKOSLnZU37pmEbKbo6uxSiwdhJLm7HqaKcjVCYMtOdjD/sn6OYuiNJqGY+b0n
	I150Qu2r4p0R7YIwE4O+5BVn3hn5PlBtaU3v8d9Ttl4RZ6VUAqUCCfALXgXXlmgvNWIGkYUXxcD
	m6ZzaclU4BHPg5iO8l2qbKHDe0GgJGsL2gABq4afLm4eGz/to7ctS34wqRT/5LZEAg7cxTphAoE
	lCdgRy3jhOdRflHvtwMRf2zDe+5Xn5sAw8ykTrNuS5KBWSv92HABJ1t+GiRvaVvmMPdZCT5x/7U
	VQPLOlFqA6xXFWQYjt1nwneU0rEnOUK78ylTVue9mbKwXYZ/UhFEhjfPnayIFnP6UgD0ZLGYwcm
	PnNc=
X-Google-Smtp-Source: AGHT+IG/wRJfICOd0rJglyxitm+BY8ebQO8VCwUEEOEq2gB861tMvqjxY+3Pnh8ldW3LMmwXobQUeA==
X-Received: by 2002:a05:6602:2d84:b0:855:705c:a555 with SMTP id ca18e2360f4ac-855daa555a5mr1182279539f.13.1740340737287;
        Sun, 23 Feb 2025 11:58:57 -0800 (PST)
Received: from ?IPV6:2a04:cec0:106a:6c96:8bd:f00c:b6c5:c3a8? ([2a04:cec0:106a:6c96:8bd:f00c:b6c5:c3a8])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee8464a680sm4161302173.41.2025.02.23.11.58.55
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2025 11:58:56 -0800 (PST)
Message-ID: <09108dc3-1bf8-4ae3-b104-8cc71e1f5305@gmail.com>
Date: Sun, 23 Feb 2025 20:58:52 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US-large
To: netfilter-devel@vger.kernel.org
From: Louis Sautier <sautier.louis@gmail.com>
Autocrypt: addr=sautier.louis@gmail.com; keydata=
 xsBNBFaBZK8BCADdpZMXADynrJO25gs4sOe8ZCESj4/43/tLuAaMF2zIgQuF7HWnzq6U1kvd
 I5yd1mNuFwdgD8xtxmSVJIQho5DMp4iXMO/PAGX2z5RR2OkeKNR+Ei/VXz/3BGLMDRxNyXpm
 uZpCwDn9cGJ8OXS6xI+4v5xhszjBIsAxHw3ZfuWGaC/Wl+L9uoK5H37WRYaQbSIxbgN24E1A
 AJjnZ7InQd1ezETwd1zNaxmUJPNyBq0WkU5j3MfUlcRI4fwVpllx4Z7LMUncxAUhta+HyuN9
 DXYtYW8d4a1HqgmSdcC8CzvAXH2sMrbqZmsqKoktRDYwPfWZxbcYuEfEPvpDe/BymqfNABEB
 AAHNJ0xvdWlzIFNhdXRpZXIgPHNhdXRpZXIubG91aXNAZ21haWwuY29tPsLAlAQTAQgAPgIb
 AwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgBYhBCGmLQw6hxIox0te9yzff9qGKyn7BQJmBhtF
 BQkRZeoWAAoJECzff9qGKyn7aecIAJZTY/62vLTC+xkpU/xY+RseJYDrXjZC03ImHHTa+d3B
 sHYfdo4giEq9VKpEbGCt0mDxUDXzyh/hM/cWHQaLs2ZpebH2xfpiiZq7tzSOcRLAcLmGSzM2
 f8fFYjt36/FMpQ1R2AK7BSXkUk9uqVGY6X9AaFzSwrVQjx7TTg81BjbFcs2XeD6L6/l130UI
 dIZ+KdDBGDvjct0o4CoGrZ54eUhAMuASvQC38LOAKMnESFRWY/KOh/xStI/sRFFgPg+5vpI5
 2PeRfAu5uzLpLOlI7CRDAvlZR9s2nJx9oqjrT+LiUBxgF1DF5sLXMqzUyB0BU8AIQRzKRX8d
 rviVHn2BqHrOwE0EVoFkrwEIAKYYdgKqnl+qN9r2OgiRgnobRhWqfKfU9akkbRaE0T5jhVmo
 9IRG96RjQJMWENt7T77a3xLirn8A6FiS4DNAA4rUeuUEmS+3U5Gc86oBOYa/p6sI+PvWZ3Ep
 spqEnge2NRIHHBIMrCKQ1p3G3/XCpF84kFDu/Rm4E+FZ0auV4s0Wpghm6+GMd/UyNhRktZhp
 Rw01L6NavhvMWJxXJ4MbPw40LjBaekSPA8MgRl1pJ9m/fDTWc9hU2FPNRr24f/Dphj0BdemM
 nJbvT6yXRKjLuJnXcY7ps+UtL99kZ0EXUFvv8oWad7NQgGGbI9uhHf8bwaNCBLxP0Z1IOOW0
 LnAvfrMAEQEAAcLAfAQYAQgAJgIbDBYhBCGmLQw6hxIox0te9yzff9qGKyn7BQJmBht+BQkR
 ZepPAAoJECzff9qGKyn7boEIAKbG66ysJ9b2kTK0xuno0wepL0soTVeibboZ0Kj2uv05Cv9I
 yRVRCH/0pP7IOsyqKC5i6q7M+MjnL0rhMM3CnmN2LzjiVwFdAAwJKLKmpGz8aVA1giJa+9wJ
 aUlhQnnOCVjFS9wb+VTLDMEAg08Ks81786xwSZMtEcyZ8CuwTQTN3kDT3Xz6S2JXGZpSmgIH
 2mLzQcKjwZDWRp4KCsvclW1oRHvmXokqekT+1CTgla92M+nMPvS0W/E7J0EXf1q4R7YEYmj5
 GcdGrXAb2n/cIq1kg2m9K896BHrUvK9HSyeEo26mIhmzEd/v4D+LgFbBuKn1FKpn8D5aY9Bb
 fhP7sxo=
Subject: nftables: handling missing interfaces in flowtable when firewall
 starts before network
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

On all distributions I have checked, nftables.service (or its 
non-systemd equivalent) is configured to start before the network is up 
(Before=network-pre.target). At that point, not all interfaces have been 
created.
This causes "nft -f /etc/nftables.conf" to fail when its configuration 
contains a flowtable with interfaces that do not exist yet (e.g. VLANs 
or bridges).

I have the following snippet where br0 is a bridge interface 
and eno1.100 is a VLAN interface:

table inet filter {
     flowtable f {
         hook ingress priority filter
         devices = { br0, eno1.100 }
     }

     chain forward {
         type filter hook forward priority filter; policy accept;
         ct state established,related flow add @f
     }
}

When the specified devices are not present, the configuration fails with:

/etc/nftables.conf:77:26-33: Error: Could not process rule: No such file 
or directory
         devices = { br0, eno1.100 }
                          ^^^^^^^^

As a workaround, I set up:

- a service that loads most of my nftables configuration, except the 
flowtable devices, before network-pre.target

- another service that loads my entire nftables configuration, including 
the flowtable, after network-is-online.target


Is there a better way? I considered keeping only the second service. 
But, in that case, I might accidentally allow blocked traffic during the 
time it takes for the service to start after network-is-online.target.

Are flowtables designed to only allow existing devices? Could something 
be changed in nftables/Netfilter to lift this restriction?


I'm not subscribed to this list, can you please CC me in replies?


Kind regards,


Louis Sautier

