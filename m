Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACDD5C96
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 07:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748418624; cv=none; b=dP5G/zMY+HaGjdyjfZ8+aIBC6DS3Lk5hlPa3IwVh2Q4gxWvedkFewcdynPyuB7x1jCiMd6oVe6PDe1W3iCpmvk9d2xqzU5T5QrLYwydtEmerjXe22zLNEYd6nWiSwBvzp4pBJQz28qUjv+kXV+KuXmeH818/XSyONmjW6E9QZ1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748418624; c=relaxed/simple;
	bh=NqihgWTEBh1jUCG7kUpeQ20C703nVkPYq6iLxWxEZ7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZ7/TZO1iEiGF78oZrbMYAUCQs8q1TRDsNAi6hLxIyevbPYlpQl9Ohh05jQ/QcGTgeeTdDBzzMunRNfMmXWxTSRWUsccAq+wimPHWUdYUaFw4D6sVkF9ewkjpdm+w2x57IIDuQ0zM9iLzN1beo65rLLAJ+BZHmGWQNiUJgv/SPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MwSEaVm6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwSEaVm6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748418621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1tpi47h6CncFHkErQUdzowao9tBVRUGMqpMcapTTkpA=;
	b=MwSEaVm6XqZXPkAgmW9LfteNWD6rxIsLYpL6FvH9mVDHjjjcdPHC6O9HlhgI8z8cccVSUO
	pJ5f9FFHNibHhIOkrR4o0Kqu5a/nkw40xnGL8gZOa90n7f8haCnXzWecH7sPghqPXaiiaF
	6ttP/d6rk06mCsVuB9iC+Py7N7WEr/0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-KXzNFne0N92PeJBB5j_Bbw-1; Wed, 28 May 2025 03:50:20 -0400
X-MC-Unique: KXzNFne0N92PeJBB5j_Bbw-1
X-Mimecast-MFC-AGG-ID: KXzNFne0N92PeJBB5j_Bbw_1748418619
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43efa869b19so26921585e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2025 00:50:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748418619; x=1749023419;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1tpi47h6CncFHkErQUdzowao9tBVRUGMqpMcapTTkpA=;
        b=UvqowZ5atcSOH9VCEs3E/Gp/EWGnXgaKZKbNhMwZgAKWP1H8P01hU4RRVONd9emMoW
         0bnp7/9tQjASMGW6yh5q/5KB6l4jKbDVthkiui6f/NKUBBi+FamekjIZIABE8pMqE2bY
         Y1IQs0oZ/PJcTO3H6i0VAqeLKA2qY1NhFyaVv4HhPCa/ImPairXhgVBqn04hxq3/nQKZ
         VejKytlr8y9zO+WchoYKj9anYCz9Pr37MJIFHsko2U0cNFQTfb8PpDHTllpRJPNkKzk1
         yWRTEtXGH0jzetBwNRnMynnWD94hj6h9D0kjrU5nHNm2QjRF3lZ6rEcoRME+G6LwuTuC
         sY4g==
X-Forwarded-Encrypted: i=1; AJvYcCV0q5/NnXEkTpHE+QhM8fCp1BB8kNbWOBomSSfQ1Gsg/JKl4IKXUPvv87K4eLFM/92ZA2EhmsSicW4XX7iKqhM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwyQwe0+G8Ek5lLyWhrL4m/l5qmd1Hrk+lA6QHgqZoN/5pjDuTc
	kvyFXrEX9/55TF57ucBObPk/o2P4id3LXh7kYbN29LS28RQdQLIdxXKGxoew8oPoTGAJwG9wQp0
	JTU1IPZ2S5lVsBDf0yFkaJul2tzER1KNTUnM02eG28eFUqXIngrHzo+GLS/vp4BLSSDnG3g==
X-Gm-Gg: ASbGncvVw9oRBVbwNES8lAQRqIW0SlAl+fEVayv7uRiIIIqC6bWmFsMolkD/ijDRKrw
	TWf+SpiddVDXI/He6T9OG4Q2h54h015t8ffd+0Sl6zySZmx8wtjfP4TXocpsHwXcQ3yzc/nhxKe
	yPG7LwZIi7Ekf0G/DRTF8scAztEyPiWbBsYXCmZUqm+acIco2jEmTuiWsZShgVFGPQZnaXsqtot
	0P99h/a8IRv7sVYxKWKVuV1ep4ECvVjy/GBx1eg7VQiT7HrYFld6FZhEVWeJBURhWxsCfaYvp90
	F80bLfsSInReEBzx4BrLoq83rwMyLPxYFfRxpsUjFjZYdD5uitHILmqnK1I=
X-Received: by 2002:a05:600c:648a:b0:442:ffaa:6681 with SMTP id 5b1f17b1804b1-44c959b8d8amr110637305e9.28.1748418618965;
        Wed, 28 May 2025 00:50:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBWJyZILJbrgkPiDDB8tVOLhwXdtQjh+xX3gUrTyMstA+8ge6QPCVLy/QC/PtLY7yRC/4N5Q==
X-Received: by 2002:a05:600c:648a:b0:442:ffaa:6681 with SMTP id 5b1f17b1804b1-44c959b8d8amr110637095e9.28.1748418618539;
        Wed, 28 May 2025 00:50:18 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2728:e810:827d:a191:aa5f:ba2f? ([2a0d:3344:2728:e810:827d:a191:aa5f:ba2f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4507253bebdsm9195275e9.4.2025.05.28.00.50.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 00:50:18 -0700 (PDT)
Message-ID: <f2ce8d64-2e0b-4fa0-b266-4b4c547771bc@redhat.com>
Date: Wed, 28 May 2025 09:50:16 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [net-next PATCH] selftests: netfilter: Fix skip of wildcard
 interface test
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org
References: <20250527094117.18589-1-phil@nwl.cc>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250527094117.18589-1-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/27/25 11:41 AM, Phil Sutter wrote:
> The script is supposed to skip wildcard interface testing if unsupported
> by the host's nft tool. The failing check caused script abort due to
> 'set -e' though. Fix this by running the potentially failing nft command
> inside the if-conditional pipe.
> 
> Fixes: 73db1b5dab6f ("selftests: netfilter: Torture nftables netdev hooks")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

FTR I'm applying this patch below the 24h grace period to avoid sending
a net-next PR with known issue and known unapplied fix.

/P

