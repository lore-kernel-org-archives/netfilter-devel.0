Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65B63E47B;
	Thu, 13 Mar 2025 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741888906; cv=none; b=BwrtvY7YHcYX3NVKOTmGMznnLjTGtgqGQQnZtbMLUHn7R9PyIPmT67mox1SOSNa3K7EM/LGqbkrOODpVbtkGInWSfDIWPRwFdXTbhYEh0tKrJiA9YQGysFb3wa2Afi4Uel0Hup9HWoOcjuYe8xgpO5DLdLeFN4QlTkMdGg2O67A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741888906; c=relaxed/simple;
	bh=6jV0radH4S2lzjjNkKAxQaEnlVGn3SNEWffq1tdiwe8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TgONvomoTo1Qv3Zew5q+fV3ybBHjANS+fIFCASAUrkuDHYjOM1TWcDzncGip3niJsYvf1fFiWfiIRpKPwOR78DynPP9v/A1qLWAJ3HqU2UFZsXMCzljLfWUaOxLZD4t4oVi96nBmHnWqvyn58Mf3Nx6p2lXC06nJR9eH/Y45zZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EwI3hJMZ; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EwI3hJMZ"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5dccaaca646so2316336a12.0;
        Thu, 13 Mar 2025 11:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741888903; x=1742493703; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W/aqvoIKuR6wHeO9Dw3liQGVZV24Y7M6R/uaPC7XW8g=;
        b=EwI3hJMZfiWy0F3PRXMymRU4/wA0hwI92ctwSimkBEOUi6S5/zltisCWfaGOAz8h2r
         YSYHBDh2XyXQVU/K6y6JQ3vbHgF60udb8F/rldTjQJpGkW/zybn1VyrtwuR4ZORJd6/J
         jHA+WZRZ47jNFf4N+X5lslnkCNesVNNpb6lWCq/Gg3R9nhjM9DjB6BHPeKHjwxQJHAVQ
         6RcKb409zS+inC3oKthmfsAFgvrffGRY9RH9CgxqJ77Eui7Ew0f7I7ruk8qZhruuEaC0
         BUoqhL57+pO8MCiPidob7LAQKPYyHREA2OzpGtm3kh91eYi3urVg8Lob+lsCHRgaCjWd
         ucqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741888903; x=1742493703;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/aqvoIKuR6wHeO9Dw3liQGVZV24Y7M6R/uaPC7XW8g=;
        b=p1D4Qx97QgQb34YlrBoX2B5+NO69oAe/ZYKS6qg9uRzR2fGJaXRJHryKS75TvkgSL5
         Es6ZlYyp+ZC+m8Ti9L1awjZKuAbxfi0ecJTS6wf4oKERMaxYv+KQWV1S6nde5yo4zI+r
         zoPxBI3ufWnkXEr3yO/CoTXsB6gWth5+lhm0LJ+IoWAfaFRp8enAOdbUXvaGYqFtvBzy
         MC/h2KoqdgdUD8/4XbRC3db+4sYWcL03F8XikOJe1QQz6Z8i4Ip8Q1LCpeVCx+TtnUcB
         a99VeXnRqSVOUV90L5gbDOQWl/l30F6JRrD8cVm8W3jRg8wYnMbwjYpnwcKYy4N/gvvS
         dw3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUUTikTIKxwD6ddPg+Z4KOHTBaJCR6btXAYtoCVhAh0umMYYAkkzooMMzWUJS+/UGSIAdbyPR6oPPJVyuxnKUo=@vger.kernel.org, AJvYcCUbKo4ncz0oYwJ/vUj48B+QfdTxWBeGn2dZX5M/YgovYzKPYUrIO4pZuBa0hIfRaK9qHzwf68ZfqZS+S2vQ@vger.kernel.org, AJvYcCVOS4C+QKiJ6q69MoyG5BHF1u4pKRGFlvmwGSZ9bM05aIc6G6mK/vP/21mk8kxEPxadR+eHfXPn/e4sMEJOuS+i@vger.kernel.org, AJvYcCXq8PJ9axCecW30opIXfw2Xdgx+i6alcllm9/EBJb7A7RALNHLVFjaejYbuXCPqrcNEmLJ/atgM@vger.kernel.org
X-Gm-Message-State: AOJu0YyRICr+Yk0wFhy4uu5VMLKlgCT0Sk5H8c8GqhAMRWjnnc2GIhCJ
	/PS9w3PYmJ6LLI/ZFZ3i+9Y35LlD0H6lsblXQWlgVikKJbDRN9l7
X-Gm-Gg: ASbGncsWsto95ZKRIh9H/fmxD+gqP+BXAsJcNlyLzQ/b+tOTv62AP0hVskrsS0cDqNV
	WlBH4tXul3pSPqszIM72Ydb8004wdC3ufBAIzGucH1g4w/vtJde1cxPM7epN3TC455bXtdT2plZ
	ZLDbpoYkH7xNYr6ruSiPDXcn0cM5yiXfVsL6bZENeMtCUHm2lTmMaR2uWXHFqwSD9WXhoaimI44
	J15WAMRL8uECv8vOC9Ahhkil9lmlYpTtOBAVSmb0pVzetjz3NvKZNYyDgLAzmoc967x7vRYNidR
	NJb/AKv5rwux1CTsAwep1pWRp9plMw3KYvraooNoXFgYvePNZSpWbOxPlbGS7S6eeyS8Jnoqmrk
	TBfU6FVIhOtiFnDAHYX4whoDg+3YxAEAr8FfUbKa2T3sIpkjo6Y3icq0g4O5wVketb/x6RyZpEQ
	sTP1AKSKyqV4LC2w+E88k=
X-Google-Smtp-Source: AGHT+IFuZtAhl/EeTwlESgZEmFiH1TMtmKl7RGfRolizt1DBUCNDPnPwoWBarCBAea1UlBVhaKlHyA==
X-Received: by 2002:a05:6402:2550:b0:5e5:9c04:777 with SMTP id 4fb4d7f45d1cf-5e814d805b7mr3320106a12.6.1741888902566;
        Thu, 13 Mar 2025 11:01:42 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e81692e6d4sm945413a12.9.2025.03.13.11.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 11:01:41 -0700 (PDT)
Message-ID: <02b97708-1214-4fa4-a011-70388cff8f79@gmail.com>
Date: Thu, 13 Mar 2025 19:01:38 +0100
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
 <58cbe875-80e7-4a44-950b-b836b97f3259@gmail.com> <Z9IUrL0IHTKQMUvC@calendula>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <Z9IUrL0IHTKQMUvC@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/13/25 12:11 AM, Pablo Neira Ayuso wrote:

>> What do you suggest?
> 
> Probably I can collect 4/15 and 5/15 from this series to be included
> in the next pull request, let me take a look. But it would be good to
> have tests for these two patches.
> 

These are not most important to bridge-fastpath, but it gives extra
possibilities. How about concentrating first on patch 2/15 (with 1/15
removing a warning and 3/15 cleaning up), adding nf_flow_encap_push()
for xmit direct? It is a vital patch for the bridge-fastpath.

Anyway, I will look into writing selftests for conntrack-bridge setup,
including various vlan setups. This will take me some time, which I
do not have in abundance, so for that I do not know if I get it done
before the merge window.

