Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACB31C5D7A;
	Wed, 12 Mar 2025 16:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741796495; cv=none; b=rQoJxBw0K7ZtyWehQ3gRnNlnJDlXtUhm77xFYO+PRy4W5e4hl7Npb7GkY8Uq7a4gdbv9ktTP1ooKtML2EpOvM+KbX+bxX63dQKnKRNpWagQgHSsTUdDMxmihJ6UE2GA3ytzbB16TjhVf/FptxJ2A+vj35rzvnTGI0/ywZnawrXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741796495; c=relaxed/simple;
	bh=AA0MJOsn9jCYm6rQxqAqvA15NsJHoc5M1iB3UxZTL80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UWE+rfQ/xajbWE83aBPog+LL+4f2rztVTMykh6Bq1xorRDA29H/V/EaFLp0KfDkIsYSPM8G99WDPTblKdaV2gmiwEcmcTwn7xVC5cGA5PY3MPzpaNYRbbelTqQfT+EDouCxiHUkpzRstuBPq638R+V5BZdVHCK+a5Ex6FZM37wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SikGBZGs; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SikGBZGs"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e6c18e2c7dso7455159a12.3;
        Wed, 12 Mar 2025 09:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741796492; x=1742401292; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g+vFr6C40IK/QoHRZZXYgKsZ4IfXSOBUm8PFsyPbVxQ=;
        b=SikGBZGsJTyCQ/bohuS/YB9oL5R1dIS2E3CoMcmo8z7DnvoSveRq5bAI/3VhXDWVvy
         lyBKoX9hY5Y9kscHXteN21lTdMzQKMk08Vxqga2A6iclUoXFMvHEpNxlQxP/+68Sdq+U
         kJ186cRPEJEuXhFeW3//D/UQBR1iNNpq3u99ILwlRpHPebMBG+eTlHho73ADmwH3Fva/
         eIPoUBsBz6o2tly0n5ghKuE7csmIJOH/WhiHs1yy8/feciMMhs+3Y4fICyn/vNAzCRoT
         5hOLTXmeLXgTiUCIAuFN7x48N2kPzMqXicdJGoVCaKSh/ORIkQlVkz0yBoPP9sb8OuSh
         XM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741796492; x=1742401292;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g+vFr6C40IK/QoHRZZXYgKsZ4IfXSOBUm8PFsyPbVxQ=;
        b=R+RcGwncLiY3lJQ3lpEA3Qg8pTy/PX1qfWCLza3XRxurVSdGE2eCp51u5ihdRH7Mc2
         OtO87wzLSdwVW/n30r04qQA0ykYGEhQV1LP0KEc5/Hi+4QuMvqsbA8ogk23ciJ6S+Ip/
         wM7l/5YNHOap4FZExVVovhgnBIDyvYWUL5KpWNnQoQw0wbkVnCUamwBNAb6/xi2nBShk
         Q22NnTtyVe/+vFDItsd5QOJX9RztRB0HVznTL1ft1PcvyEP70nFUO9eDQxt93b9DAp8J
         04VD+kNCBSQA5e2iRU2D5i8wwRgPXYaGDHw/q9wovN2v2G+ZwLxeQGrhD9iSf6uMZSb0
         2WZw==
X-Forwarded-Encrypted: i=1; AJvYcCV7JV9HBlE2Yxt/QEbcGm/l0WyxkbABvfT8f5bNopu8y+Gob4M1+WmT87ZTZxjFrn3L6NCQ4suh@vger.kernel.org, AJvYcCV8MIBn6C+Z3T/ivCAEGee9zT6zfRJFI36NC1Z7BlSh20IXiL3LJOXeTlScOVZ7RjrGBllffb/njsdl9N1/zDAR@vger.kernel.org, AJvYcCWVYgiLxpap4dFXxOZ9XMU2zztNJvT/5wxaEjJ0G/LWMWK1jaixyxGky6FEP+6xisP1hdIHGAgr2f96QbN6yVw=@vger.kernel.org, AJvYcCWdLt77Kc+JMoqu2/TOSCsq4ofEj889Ev/Ky6uSYBUHU9Uj+fGGAVb0J3pNGcGQWxbH1q/c4oGcGKVQoBoj@vger.kernel.org
X-Gm-Message-State: AOJu0YwCDaPSFSEgFWudtbkk00OLAR+VKefqfa/wD2W3VF/9Zv6/dKNi
	BJrQXn9MHqGmILNjFv889HP69DkTKqYL8sNJSJdXdQFh7ehwzVq4
X-Gm-Gg: ASbGncvTxHFfrJDX+0eL3dbyKzs+CjqdptRPHW4maUQkcd5ZiHpnXN01sDzld5onoaU
	2waFRrJvZAl7/QLWqLtSrUs+AewaONncWjXcdq0lg0qUuEf0aFRU7KMq63LeXmd3dcZhqcTCd28
	ty9PH+y+nJpNKs4/CzY49Ob1YnfNj9dkmtwMaSaFF8P431o6ZPZ0eD2MnJtafmcW4JFX/qDGhkZ
	8Eyi4fpJ5it2mF7X4/rrvK1I7pTQDqpvcSZxAWRYAf0DN0olr0ce3Mc9bMRrXf+DzahuazMPKDh
	UAmPq33jmhf9tK4yFmNodcOVLSV/SOMd0YX4SoXoUFd8AHGCD1cVQbwiQbyHAqbvNMzoyKZadtj
	lq8OPOBgpq1ZXAYAmoF4du//akk7KpXO9g5kX1P2aB3e7Opdq7Jrc/ga9bFu5E5/js9uIVdj0Pa
	eiMUlVkVKbN6nVkkqYkTDqzTwkU1Vy9A==
X-Google-Smtp-Source: AGHT+IEaEC38X6pFHkhcOdl/BcwH+TXUrXY3YHVZyCJc94P4HbdEGDzPYfpH7BevKXGOFc1f9RUFvg==
X-Received: by 2002:a17:907:1b16:b0:abf:607b:d0d with SMTP id a640c23a62f3a-ac252a884cfmr2996838866b.16.1741796492007;
        Wed, 12 Mar 2025 09:21:32 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac23943945asm1081554266b.22.2025.03.12.09.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 09:21:31 -0700 (PDT)
Message-ID: <58cbe875-80e7-4a44-950b-b836b97f3259@gmail.com>
Date: Wed, 12 Mar 2025 17:21:29 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 nf 00/15] bridge-fastpath and related improvements
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Roopa Prabhu <roopa@nvidia.com>,
 Ivan Vecera <ivecera@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Simon Horman <horms@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Ahmed Zaki <ahmed.zaki@intel.com>, Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
References: <20250305102949.16370-1-ericwouds@gmail.com>
 <897ade0e-a4d0-47d0-8bf7-e5888ef45a61@gmail.com> <Z9DKxOnxr1fSv0On@calendula>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <Z9DKxOnxr1fSv0On@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/12/25 12:44 AM, Pablo Neira Ayuso wrote:
> Therefore, I suggest you start with a much smaller series with a
> carefully selected subset including preparatory patches. I suggest you
> start with the software enhancements only. Please, add datapath tests.

Then I will split it in:
1. Separate preparatory patches and small patch-sets that apply
     to the forward-fastpath already.
2. One patch-set that brings the bridge-fastpath with datapath tests.

> P.S: You work is important, very important, but maybe there is no need
> to Cc so many mailing lists and people, maybe netdev@,
> netfilter-devel@ and bridge@ is sufficient.

Ok, but my main question then is which tree should I work in, and
therefore which tag should I give my patches, [nf] or [net-next].
I think it will get more complicated if I split my patch-set and half of
the patches go to [nf] and another half to [net-next].

What do you suggest?

