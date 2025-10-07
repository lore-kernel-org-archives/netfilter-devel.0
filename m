Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0522DBF6E
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Oct 2025 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759841378; cv=none; b=B5wW3EjzuxgK+2CwVh7ZrSIo+R+HhFvzyoirEW44w7bmVzXsT8BW1hVoz+w7ovJDyampEKAUDYoFtxwEw8hSZe2R6W1oDUIguP1wRGCSPxULfx5z2qDl4+RMa8DLI8jVTHxZ06mKiaR8noqWS1XqVCwj0p7cadHChe9+8y8NR1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759841378; c=relaxed/simple;
	bh=c/WLFYIFjnh2k/ZgBeBCvK2ZBmSP55ivwUxj5/6hNpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTX7ZWVpPi5FTM4jTJTyO/Yd5Eqs5D6eHoomDHyxf1uDRMgAAyYBRCZZtggIeLZYwBkr8QztfKe+SbVDAAJMmtebYTlLERfAjYe62lUtnATjwSMNk01hybVy/xtuEYeCkGTT/rG1mm3eyLCT7qxxPFQVq10/I0lMi55ZrIgA0WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fipCYBZ1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fipCYBZ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759841375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJ2c6ZhPNn3NTb/ZXUe3uUgmdMJ2RmrHeu2BLMk0710=;
	b=fipCYBZ1MqU1dBWVkNeS7r/Xdre4AGHlHDkEOueRM3mcY7XsIDdZikk9tY/qyJyFZ4dxqb
	Eh8sgkIkkV7bpq41YkpQrlPLDweftYNccfgKhNCcV6d7mhX9JM1tzPY8ml/mlKMnOAwLLD
	bhjCE9TMChjv286JSP+HtAgeXYSFXNE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-OXQtbNMAPqG7iUgvmNC9lQ-1; Tue, 07 Oct 2025 08:49:34 -0400
X-MC-Unique: OXQtbNMAPqG7iUgvmNC9lQ-1
X-Mimecast-MFC-AGG-ID: OXQtbNMAPqG7iUgvmNC9lQ_1759841373
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e44b9779eso23183705e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Oct 2025 05:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759841373; x=1760446173;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WJ2c6ZhPNn3NTb/ZXUe3uUgmdMJ2RmrHeu2BLMk0710=;
        b=os0HfWH4vYvf1K5B6xVZQWLAMZnmgqyNuUkxUJgWfMo7Zb6fXSzHumW2Te7Ckrx5BB
         zEDmivO4qgdrwaaHp+CZTOA8GOlDeMei4OyIMl+PKP8quH4rjV03lH5QZw0QeeYG3Rhe
         SQDvmb1hS5cz9YE9JNLViSHVAl3OOqu4t2nQVdq3GNSiadys8mK35ceoU9oluawyApgx
         QngDA23eVKsECapEKJTiGKkWqVL5llC6syvTwTtyzFkK2aKZeXSoXE02nyJft5TQyF9M
         X88W4r6uTW3FdlbXU64dCPpzufzc9zvcBM0IyPlfL7kI6P4v/wg2K+fM3b5JAaxg1fAX
         8vfg==
X-Forwarded-Encrypted: i=1; AJvYcCVHfPxZ2sIAaSWmRulFh5fSmGpIqgvb0cxPwje+jOVGaZSDcpVBOA9UtLCyiRbH8CkmONhoEBlUbzNAxaUh/yo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAACoHALguIweZ7rECw0bJIc/s0n6V3GWi6VRNg6d5kBVKsI7E
	hwqOHu7TDRjP2QaZ6VjRdT48PvVNd/iSDIkPrU9LYCGzKgcw0enylaBaDKrqhy9ZKm8KZBcZLPl
	YFMz5kiwYBHS5lBp9CN9Qw5F3GidYoCbba0+n7XPDscI14oS237qwUaT4Ll/g+7WEZzYCUg==
X-Gm-Gg: ASbGnct24yZqsOsJjmaO6pFIPwK8d7v9kkQ7FL02whmNn7pYQcVW0b3NII2FxdSb1au
	SHqSfSe+tSHoMGgKozceLGVN3gSMveEV2Td67duFGh/ZZg9hiAn/mPjD1jEDVYjXYFxiAyvrXtw
	7EwTODalUy7QSzSQpqt8oGmnUtaU9su5KJ/QMpGauz0IKU0Dscr4W6ITuUUlwpw8RNU9iLO3wqo
	AS43U5qg1anMxZRn/mJB454xCNnRp8IsvqO0n99nL7bASZl5KuT+rSj+yqlFj6s63Zr99+t03A6
	zvN1W4yfb2G0dJNBUL2DlC66cC92enBf0hkmCQ3iUj7t7wFdzbjHoteyEANBqsaLIv2hNsXzmTA
	6P67Wsi+v3FvynST8LQ==
X-Received: by 2002:a05:600c:680a:b0:46e:42cb:d93f with SMTP id 5b1f17b1804b1-46fa26df6f0mr24052595e9.15.1759841372944;
        Tue, 07 Oct 2025 05:49:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmEdkYp9kyJChoEBmC1Wayd07hjE4hNEA+dlV58UpIwkkn9LSiHaGwwKX8eGfaTODnJZOzSA==
X-Received: by 2002:a05:600c:680a:b0:46e:42cb:d93f with SMTP id 5b1f17b1804b1-46fa26df6f0mr24052335e9.15.1759841372567;
        Tue, 07 Oct 2025 05:49:32 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e723432c9sm204340025e9.1.2025.10.07.05.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 05:49:32 -0700 (PDT)
Message-ID: <2bca842a-0a94-4798-b215-128809956018@redhat.com>
Date: Tue, 7 Oct 2025 14:49:30 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 nf] bridge: br_vlan_fill_forward_path_pvid: use
 br_vlan_group_rcu()
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Eric Woudstra <ericwouds@gmail.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Felix Fietkau <nbd@nbd.name>, bridge@lists.linux.dev,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
References: <20251007081501.6358-1-ericwouds@gmail.com>
 <aOTm6AUL8qeOw0Sp@strlen.de> <aOT0jTumQq39V7p2@calendula>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <aOT0jTumQq39V7p2@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/25 1:07 PM, Pablo Neira Ayuso wrote:
> On Tue, Oct 07, 2025 at 12:09:51PM +0200, Florian Westphal wrote:
>> Eric Woudstra <ericwouds@gmail.com> wrote:
>>> Bug: br_vlan_fill_forward_path_pvid uses br_vlan_group() instead of
>>> br_vlan_group_rcu(). Correct this bug.
>>
>> @netdev maintainers:
>>
>> In case you wish to take this via net tree:
>>
>> Reviewed-by: Florian Westphal <fw@strlen.de>
>>
>> Else I will apply this to nf.git and will pass it to -net
>> in next PR.
> 
> There are more fixes cooking, probably we can prepare a batch.

FWIW, I think it makes sense to wait for a NF PR.

Thanks,

Paolo

