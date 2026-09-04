Received: from mail-wr2-f10.google.com (mail-wr2-f10.google.com [74.125.225.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D853B840B
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788540108; cv=none; b=uE2sI/ajlNTcRsIJ1CM7flk5h9I3/wA+yd2LttVxOwPMUKZGFfipzcpAj6HYdznX9O0tsK+i1PUwYEM0Ae7NwoBrGhSAbTiPeB78FaCEASbc+9rczgT1BpnWM3wyFd1kVRkM2mvg3grFD3q4Ir/9V1MA8VN+eC9cFX6uWd4Js+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788540108; c=relaxed/simple;
	bh=W+1DwyqZ0vEIC8ZbwjnEAQ/i6kezzc44cJHGVgpIou4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BR54Nq3wn/froS5jFC9WzwquCpH5pwSZbmgs5jUbhqUVYilBhP74Adj6YlLV0VcDP3XslapxVwKWL2Neka2CSYjoT6sRONkCEJFfBo/vQr3yOAvbQENPxA47NJxq+WIAFDhGrhcZly/FXHVPALNWtNRq1KJCnu2gPnDvzURLDuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f10.google.com with SMTP id ffacd0b85a97d-484373a2e82so452447f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 09:41:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788540104; x=1789144904;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=irPlhgKRfCP6rMpUfujetCdiJVbOXFe5xjl9vJMRqUQ=;
        b=mq2AH23FxSNV/Q+P9Ejothd9Jy2WuZ1nSyFu5lvzGyA4eqRZROQl/Ufes725/Ko/Wi
         VTaDFwJANfvSIdm7GfsJgtnURktCV30wnhLgz+5IBCILPttvB4S2NPS9kUDc5uLPbv51
         DlyVsDjz8O+PlYQSamX6+83UUbiTCVsVknATMf+d72T5HavynPlT4WpZER8sW6p0vIp4
         CgbTN2gr9oHL/qOLh86EiJWg1kf8IIebH2y8DJ1ebduSoFCqa4MESyicY6AXVJ0xnXfh
         TR/p9zPGE38zEp2QBtWqUdTJRqmzm4xTPmZlI/uPziPp/WhhfTiebIOyYHGlqOzdB7Np
         SibQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLye11f4R0Os+3fus/Gbok95h47Aq4efvI1y2YdAMFJGicLUBBSM/Mg8qNevD4nFkz9WiImeMIKVAKdyCiDTc=@vger.kernel.org
X-Gm-Message-State: AFuF++lQq0BaPgK6QJwbgZxALF41kRYwT8/yh1i/a9iHWE9MpF/FtTFs
	WUzgXHpPFobhrhpOOLpEJpCQ/1fblYBPoMg2dgkykAXZLTh2zkz3OpMO
X-Gm-Gg: AYBFou1hz3QfWoTNidSp8UUw1LXUzmA3KR8qI5OjvWKpbOmEqzcWOTn7a4yVigfAxgf
	jZAqfzVNb5S/BwyiNX8NGjMx81DUdCtj6D61IebXqVPK1Gj9J5NMAL3RfZjDjZCeboQHKzhyX/k
	HnxNzq2Zpw6nivYX/xRFqGUas9tb29dZa01+WGX+O9zXu3elsCEUXZRlGiufH3y+zK6i+RBEyIM
	7V0xuHFNM8lbaKFbYjEflOPIs4Um0/z101Aq8qSlaiNMhp7tQ20kOaVqBCpLGzz0axy/99T9w0O
	u9wY0PP2X3dXOX5Zqb5ZZXhlA4DjBhxKYHanz0OW33Ac1vC8qPiYevnol03J3vRruMiGIgqDA2e
	x34STNDk1gB7/KqMrFDpOz6wUwqppF6enlnN2NKawwaNSyGHXwnTv6VWnOSjrgSrr+RnXzp5t8C
	wJWeRad/qN+VwcCnCvvGxrYq+79g3WDq9vAEbgwHeG/DJ1QkQlWDjMqzEZEWX2xr02GE+VO8deL
	SY0P3+xW9flYCrGeBqZ3/X+
X-Received: by 2002:a05:6000:605:b0:485:8b66:f5 with SMTP id ffacd0b85a97d-4858b660161mr10077690f8f.18.1788540104208;
        Fri, 04 Sep 2026 09:41:44 -0700 (PDT)
Received: from [192.168.88.241] (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm7491043f8f.8.2026.09.04.09.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 09:41:43 -0700 (PDT)
Message-ID: <5d871ca2-1db4-47b8-bd48-34b3fa42961e@ovn.org>
Date: Fri, 4 Sep 2026 18:41:42 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/2] selftests: netfilter: use KHDR_INCLUDES in CFLAGS
To: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>
Cc: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
 <20260904-net-sft-nf-khdr_includes-v1-1-92455af428e9@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20260904-net-sft-nf-khdr_includes-v1-1-92455af428e9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/4/26 6:13 PM, Matthieu Baerts (NGI0) wrote:
> KHDR_INCLUDES is typically used to include headers from the kernel
> source directory instead of only relying on the ones from the host: they
> can be missing or outdated.
> 
> The kselftest doc recommends assigning KHDR_INCLUDES to CFLAGS in a
> target Makefile. lib.mk will set KHDR_INCLUDES to "-isystem
> $(top_srcdir)/usr/include" if the user didn't set it, e.g. if the kernel
> was built in a different build directory.
> 
> Other net targets have KHDR_INCLUDES added to their CFLAGS.
> 
> Fixes: 3f189349e52a ("selftests: netfilter: move to net subdir")

I think, this should point to a commit that added the first C test:

Fixes: a64d558d8cf9 ("selftests: netfilter: add nfqueue test case")

> Link: https://docs.kernel.org/dev-tools/kselftest.html#contributing-new-tests-details
> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> ---
>  tools/testing/selftests/net/netfilter/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
> index f88dd4ef8d26..df3c20c90f5d 100644
> --- a/tools/testing/selftests/net/netfilter/Makefile
> +++ b/tools/testing/selftests/net/netfilter/Makefile
> @@ -2,6 +2,8 @@
>  
>  top_srcdir = ../../../../..
>  
> +CFLAGS += $(KHDR_INCLUDES)
> +
>  HOSTPKG_CONFIG := pkg-config
>  MNL_CFLAGS := $(shell $(HOSTPKG_CONFIG) --cflags libmnl 2>/dev/null)
>  MNL_LDLIBS := $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)
> 

This solves my problem with building netfilter tests locally with uAPI
modifications.  Beside the Fixes tag, LGTM.

Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
