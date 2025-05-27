Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC61FC0E2
	for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 07:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748330258; cv=none; b=tv+fdWyvPJ9prMGP+KHvrie5IZBpehRUQ6FOWWDy0dlLlweduCY2wbTRrtzJR7M5II0TA0Cga0ORUK4F4bOGjyIAX+7F4SVhcsdiKj+FkQo4RqkJ2C0l1CNGvil+Z1XBQQ+XlfbQy4khct1i67sT5zLcNIwcqiwHquhHXTX8wVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748330258; c=relaxed/simple;
	bh=c7fLyJFyUEsXGupJPUcA5deevABmi1JPgUKpiDGU38s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjcu8ZtrrgRNSx1Jwa+mdtkGXLh3W+i6jW6VYKiTzJxTFf+dWG6s+5wgQ5EEojLqHBq5e5KzTZqTOEyIO2ybfSXzA+IdidJ3PqrJtzpk9I0zLIYtC+jf1kypR773bBzWZIJ6oHq6e7w6itgKdtmZFSzLN6toB2Y1eiOgu2hMtRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DEpe7VGI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DEpe7VGI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748330255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFoZttK1qFQLLWq/vRTqOPjL4JDl9U9JL7VK0ppo1m8=;
	b=DEpe7VGIjiW3Gs9XOhpDpJZRe6WUQyUHOPyfKH8PpIE/plFOVyKkLP//pjWWiWeoebUQwb
	r/z9wrSrk/hMCuXuMPmlE6qOMMVLeYuce4FCPmyT4EuHLimh9eGIfK1BNE7crUNiD/7Ulk
	5HIqXuKzUQQAPlo1bU6VlCS6zT396uY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-i-5118ywPCu08ZokVwbCNg-1; Tue, 27 May 2025 03:17:33 -0400
X-MC-Unique: i-5118ywPCu08ZokVwbCNg-1
X-Mimecast-MFC-AGG-ID: i-5118ywPCu08ZokVwbCNg_1748330252
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-442f90418b0so15435645e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 27 May 2025 00:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748330252; x=1748935052;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uFoZttK1qFQLLWq/vRTqOPjL4JDl9U9JL7VK0ppo1m8=;
        b=NcnecVjStyAFRNYHu81Tdr6ykdTQ8mikx5ajBc1lJmOI/m030aDnbQtNSaTj4SDg16
         bKOEQ3Yf9aVkXq/zY56JQe2WHTHSdoOV7IYXKC/xdb3jbFQyer9/ImYzM9lp5lrrquU9
         1xo13s7w1BUa9xvL5GPevYULPBbsVi52PNgSwROxK2ojqMXu5OugJvdvHGbpkj6loUJc
         x/kpxuBpN8BiPhPZpKYe9EwTlQoj97qPMWVXYj5ELwF1S2g6NwvdTezjI/434Kj41PeE
         x7d0MDxBq3d+rlyI4M35JFRmnwDC8fCiGV9HjiNsteftExA+LrmCh/9Qo0rhm3kM5/CK
         4M/w==
X-Forwarded-Encrypted: i=1; AJvYcCX4aVJnktnEJ3mpMWPQMpG63aDmw++/8v5NJQP7OlWGBrEntW+ngExyxoRVD1IqJInWkUxYdrF/Ys5sN+aNZsE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrKHnPHi+rjMK93MACw6DmKGjbY1QU4UwdFyU6bAgtxd8qgsxq
	LT8w+mPAKggplhlNdG9bMIPuRoCI78LKrnnWr1K1eDK9qp+vhCN3YWeymTw+5N5pm1nafUngTRD
	8gCx7eQBxAsXfS0oaQVidIcQ/07MN/lYKnGsynawvUOkq4anvHyFWF3mb0+Zz5cGPsN7CJw==
X-Gm-Gg: ASbGnctZo7A60ieNGdl6TacacBGn5KF16/zAW1uqEzCTJwEdCHg50xUN3tyr6IX+0eM
	2Phy/PY2V0mTBZin/28AkUikcx6S3XGxZg9scZiYAIEnMppDySiuAGwXg7RdlCGfRy3hqmVa00j
	T/nCalAVAQQNZpv4dnVQeSLA9mr84rkwrJlpgJ9vHUiElAxOokFqxsQ7DC6/2HgCu5chA5c0UoF
	1AIQ4vDNlKjUtV5ioCJ7xL889efLdK0OW48mnpfQEO/OcFagwQ3ZfIXMuQ/9B7kne6tfO9nBm4x
	HNXxUpn/ikFimyeZ0zAdI7Z3/Py/h28JD64nbrqfG+r9mggbMHQokkNiUuM=
X-Received: by 2002:a05:600c:4e45:b0:442:f4a3:8c5c with SMTP id 5b1f17b1804b1-44c919e13ddmr134348805e9.10.1748330252212;
        Tue, 27 May 2025 00:17:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6rjaM4MrEBKpkWOooZj5HtKU+xPTWzAblyNoOT7GHD0DA87EDlFyvauURgtKhnloJkF0iXg==
X-Received: by 2002:a05:600c:4e45:b0:442:f4a3:8c5c with SMTP id 5b1f17b1804b1-44c919e13ddmr134348585e9.10.1748330251888;
        Tue, 27 May 2025 00:17:31 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2728:e810:827d:a191:aa5f:ba2f? ([2a0d:3344:2728:e810:827d:a191:aa5f:ba2f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4d66a2de7sm6100565f8f.3.2025.05.27.00.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 00:17:31 -0700 (PDT)
Message-ID: <12b16f0b-8ba8-4077-9a13-0bc514e1cd44@redhat.com>
Date: Tue, 27 May 2025 09:17:30 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 26/26] selftests: netfilter: Torture nftables
 netdev hooks
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org,
 Phil Sutter <phil@nwl.cc>
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org
References: <20250523132712.458507-1-pablo@netfilter.org>
 <20250523132712.458507-27-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250523132712.458507-27-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/23/25 3:27 PM, Pablo Neira Ayuso wrote:
> +ip netns exec $nsr nft -f - <<EOF
> +table ip t {
> +	flowtable ft_wild {
> +		hook ingress priority 0
> +		devices = { wild* }
> +	}
> +}
> +EOF

The above is causing CI failures:

# selftests: net/netfilter: nft_interface_stress.sh
# /dev/stdin:4:15-19: Error: syntax error, unexpected string with a
trailing asterisk, expecting string or quoted string or '$'
# devices = { wild* }
#             ^^^^^
not ok 1 selftests: net/netfilter: nft_interface_stress.sh # exit=1

For some reasons (likely PEBKAC here...) I did not catch that before
merging the PR, please try to follow-up soon. Thanks,

Paolo

