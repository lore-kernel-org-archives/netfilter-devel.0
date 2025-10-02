Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C344D30FC2D
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Oct 2025 11:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759404096; cv=none; b=bc/Qjss1EcIorgnMVuA7SBmu6/NZRkLbCFjARG6glpbT1/4sYeJ35ensBpQIbD713UZKZCiTQ+IK31mYJVXFjUS9AaTyMwfeI2C1c68HoIgRN5E9YUB3MaMJGHiF+674/rQ8FkguxWNSjhoU8jtNpPM10QIxjI9XFW095+rO2UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759404096; c=relaxed/simple;
	bh=3cxRSFnxztdEl/3oe3MZqyfMjZ9kLl6iWNxsJEA9qnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W7m3qeFVQOLlhAEJCHFSD9P6IeVGc06EdVo3gwvAzoZZz4H3hzTxxYkyRadfT4UnhW1H7KENnJ8SGj71aDpZJexc6trmILVSFFZl7xbvQedCv5RhAxwd9kWQZ5yhAZ4XjnKv8MHmNSF8UrGtyl9nCl72APKtGA/+k8ao94RmZBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=openvpn.net; spf=pass smtp.mailfrom=openvpn.com; dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.b=C0l0h4hj; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.b="C0l0h4hj"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so605268f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Oct 2025 04:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1759404093; x=1760008893; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=esegZxLK+U9QQi38ZxjBs00HRaUbGD3FZCXde5Cjxmo=;
        b=C0l0h4hjCBWvZNRD/PrT79yQ8iTIJKY+t6c1b8RuAGfpBm1gHPhjSZFbPhilWfRges
         usgC6lJ5afzqFQvhVPPftd5HtT0WlKxth8wi9rJtARxScTI68PZuqP504IFtsIXphpk/
         8ocwGXjugBUvaUxvsyRCZV1ZJG7bdn76Sr1f8l32lIWY9UCltur8zSw9ptYqr1VRTUL9
         j4UMT0fdJtnjlBQdqn70C+LW0GdXzKlFgn5frkadwCpi+31crs71RWT5do86Go3B5Wql
         cEp6H4DdUuOV8vQIi1dJJa7UokBaov6MHpORqoKr6lnE7NKGJqgFK7OgazPlMi9j97BV
         ueXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759404093; x=1760008893;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esegZxLK+U9QQi38ZxjBs00HRaUbGD3FZCXde5Cjxmo=;
        b=redUrZAfjaQmsZ2Gfr0l3ksnCNPBLAHlAMbiptq161W5hQpB5vP9I4h3ghmEWpkrHv
         1mN147JZ95jxSIP/oo5SWSEZdonVV/F/XFG5vQICDEUftMpD2nWPb02opwhBndSQH9Ns
         mG9sUOajckXVVmB7FtkXjYGtzakaWowcfL9EEWobimiv1mKDVi8V+ARkLu8YtKJ+7C/m
         RPBw7tWFsi1VsiuxG6o7MttZPAynGJqFFVbKKFfDD0YYHY1BU4+GA9jcNttYvCGrb3y5
         qOJXKPyjsVJhWxv0iPoZfTfWJLkGQbunc8L79KxsCcBPvKb2V0OcNjkHUnGkGa6iEJdj
         G1iA==
X-Forwarded-Encrypted: i=1; AJvYcCX9trTAW/XGe9hhhtDWlDgfErLQCyXHJOAfDgfjL4H237tjDME2qrf1W5qQUDTdBJoFQ1rl2vGAa3OKKNar64Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVGvAHRLOddjreSGy7r8bSoYgv99Lkrm1iDPpq0go+IxC8NMMq
	ze9QA2rSFHoIjkFhgPtV42JtHFd+2p0fcpoSEIwAgOiPd+tDnbh/TzNf99ksep3fMNDRz8Gi4iL
	t2KTvFjQIlWW/sXnKbW2J7GyZwWP/oT6skjCPocrCK/I4oMF158y2h/OCt9R0p3Y=
X-Gm-Gg: ASbGncu2ZPSzAAPYdpRX6nNrvL+W7KJWVMXCD237KQpDmwHj2QZwIxYHIr5xVsovpnR
	yexrvRK5DS0b9g52fNzcHNwPtrRAiOVfSrd1gNm4CD054uBvnqSec40wq8hRQTJpYYlVAUI0HeF
	+enEt9B4vVZ8PW+4IkDg1i29uZxwXUiEtqqaKZXPXlY8h2QCcS1WxHy2YNPwEEQQsOCIpUZ9fXx
	134q+bABsWIBchwYYiLFEpJWyaIv9oB2LBx+aKtCfoxmJEAElxCmduSURAMRjYeEqsouq4+My/Q
	ig64YQlR3SWiJaZmVPH/FUMYraLfpKtU8Xzq6e8aX6BI8KPsziXfENZ/c7Ovc3Ag5aYikydFKmz
	POrw3J9NZ8TyuIDbBTXiGaKV2SNkJf5WncqWvv59jVBJQu68WVxwqMyJ2yFlc8LE7oFYKcTa7wr
	bGrCKsv1Y15Q==
X-Google-Smtp-Source: AGHT+IGTNHfoolP7+ES6We+KAQbTbUt0PMziY5xH2uTnyMl7liaQQ0xnKzGrdwuUKABeYW6vjPRNyQ==
X-Received: by 2002:a05:6000:400a:b0:3e5:394d:10bb with SMTP id ffacd0b85a97d-4255780b19cmr4417882f8f.41.1759404093053;
        Thu, 02 Oct 2025 04:21:33 -0700 (PDT)
Received: from ?IPV6:2001:67c:2fbc:1:9bfe:b0f3:b629:60c8? ([2001:67c:2fbc:1:9bfe:b0f3:b629:60c8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e970esm3214763f8f.35.2025.10.02.04.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 04:21:32 -0700 (PDT)
Message-ID: <8aac2981-4c90-45d3-841a-1447aca3931f@openvpn.net>
Date: Thu, 2 Oct 2025 13:21:31 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] selftests: net: unify the Makefile formats
To: Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, horms@kernel.org, shuah@kernel.org, jv@jvosburgh.net,
 olteanv@gmail.com, jiri@resnulli.us, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, kuniyu@google.com,
 matttbe@kernel.org, martineau@kernel.org, pablo@netfilter.org,
 kadlec@netfilter.org, fw@strlen.de, allison.henderson@oracle.com,
 petrm@nvidia.com, razor@blackwall.org, idosch@nvidia.com,
 linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20251002013034.3176961-1-kuba@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@openvpn.net>
Autocrypt: addr=antonio@openvpn.net; keydata=
 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
Organization: OpenVPN Inc.
In-Reply-To: <20251002013034.3176961-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/10/2025 03:30, Jakub Kicinski wrote:
> We get a significant number of conflicts between net and net-next
> because of selftests Makefile changes. People tend to append new
> test cases at the end of the Makefile when there's no clear sort
> order. Sort all networking selftests Makefiles, use the following
> format:
> 
>   VAR_NAME := \
> 	 entry1 \
> 	 entry2 \
> 	 entry3 \
>   # end of VAR_NAME
> 
> Some Makefiles are already pretty close to this.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

for the ovpn bits:

Acked-by: Antonio Quartulli <antonio@openvpn.net>

-- 
Antonio Quartulli
OpenVPN Inc.

