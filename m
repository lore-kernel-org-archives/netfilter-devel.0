Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748E7503BEE
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788540266; cv=none; b=sinXHJ89i2bN3vtCB2eIun/G/M59a5sODe+Ytw9qPmFc6/sEqomElpjBMMUQvZf1alIQsEgUgyuKOvUal0pd27KBA3Lcd6MCYkwYiVLMo7nRJNS/ic7oIBigf+GKMiXf9Q2M4WL5fbhLUPuB2mNQ/9KGFdl3wJg+JNngdUlPEOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788540266; c=relaxed/simple;
	bh=+T8uCAV9OTwG6wpyBUuRwrNrLb3w9G4dozxeqmZKwYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DTj3IGVdfvmiJLb15My2JBjBXqIFl0gcd4jHPGvddqt7BuOnNDraaBuZJEs22wZSO9fXCgndqZIaXGLThKKNbn7wKjzyuxg5o0LBNvNpZvskM+psXVDdYsSriUYpyRseQamPFclzg+3qBtFJbMWyXdcA7lZKCBE3+ILGH08NGa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-4843169420fso279743f8f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 09:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788540262; x=1789145062;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MkwLEvNPno1uKGbPkCGLW8m9xq+mdFjkf26jMfmqkHM=;
        b=McF3XaqXM3JKFs4BaCWef1at+jlWSjBuYg4/V7kk1Ka+ZpLHOEkNy7MJSQ6VET4Hec
         da2OGwNyKUEtFavdKyzAUyhnGGYno5MObIABUAhGb8oJJ6M3AsD0J43C6SUj2UFVK69K
         3z9Q07GlFU2xfpqBvi8kL350agCJpMb1reqq1GULdZVg/OIpyHOaLrtRB9Cv0mzqyP0B
         S3bJrSxH+W9VRzw+AvWnMVL7jE5U74+ENAcSfhSEigMnZLVRS8Z+vBihz73lTh5HIIxN
         RGUovdeMbvO4dywHGO4SHqL/BTOfKmVbMLiGxeow9GpdXS4qMBT8mNUJIiBYfCy2MxR1
         ppNg==
X-Forwarded-Encrypted: i=1; AKwUvBx9oMxVJfrMWpQLVYcKp8FdeMIAO8D2052SX6GFKCLPm8JxjMqxX1ONcK5EAm/DVxdlGYcLTqfrkCFEEtYNr54=@vger.kernel.org
X-Gm-Message-State: AFuF++lr/svU6fw35TPBwD67CdlPGAPA39SIQ9oe1jtqZNltE4BtShN2
	y6+HIzahE3vozi4UdxX7SD9OkAAblazxdWesyGnHtfFrWC1y0Lv/3H5Hs3U/YNOC
X-Gm-Gg: AYBFou2HtBTJY8FBRyf7Y8P1cNl3XvXgk3MJ68LTTjLFvIKFGDFN9hxqWohYo7GPVL/
	2bfCPG7i9h0pVRPoOTUoQliK4041qDVPDq/O3RjlfZeVo2P4DdkwCuhQKq5ezUWrVp8iQY9Nstm
	S5szIJFPqhL5WPB0KSEP3OOkmuQCo+PlnGs0IxhX3SB9R/MRTHik/J0vrSSCF9s+cip6Pyd9h3v
	WbfAR5ngFRbox8GjtXyvdvtr31tlkT34a/1DhLDoXz7fbIN+kVKU+VG6VBCErBbNsfeSH9Bio4Q
	TpRNDYqb4Mb7X2D8Srs5UuQMyvNWA/Jg8YEZjHd7T+8owP5lRU6F92fvdi+SjuYzBTlVo12oTav
	7qE6VO2wgyis9NqRmA9JUcn/C16NU3o1FHrdm+KKTbm2JvRdyPmiRe8at5JRmX+sEOSLl1d4xut
	qtCH0pdy1Uku3kgyijgD97mIISsXhT1gI52N5kb4B+Ld5KmuIzVknH3j99irFMyDPpTcpoLFEzQ
	IFvJuiARxWNbw==
X-Received: by 2002:a05:600c:34d0:b0:49c:fc6e:a3d3 with SMTP id 5b1f17b1804b1-49cfc6ea71amr44437245e9.18.1788540262467;
        Fri, 04 Sep 2026 09:44:22 -0700 (PDT)
Received: from [192.168.88.241] (37-48-53-4.nat.epc.tmcz.cz. [37.48.53.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cfd3f8192sm42737055e9.3.2026.09.04.09.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 09:44:22 -0700 (PDT)
Message-ID: <4c350065-7efa-4301-b287-95c1c554d427@ovn.org>
Date: Fri, 4 Sep 2026 18:44:20 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/2] selftests: forwarding: use KHDR_INCLUDES in
 CFLAGS
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
 <20260904-net-sft-nf-khdr_includes-v1-2-92455af428e9@kernel.org>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <20260904-net-sft-nf-khdr_includes-v1-2-92455af428e9@kernel.org>
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
> Fixes: 05068eaa67b2 ("selftest: net: Add basic functionality tests for ipmr.")
> Link: https://docs.kernel.org/dev-tools/kselftest.html#contributing-new-tests-details
> Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
> ---
>  tools/testing/selftests/net/forwarding/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/forwarding/Makefile b/tools/testing/selftests/net/forwarding/Makefile
> index bbaf4d937dd8..1bdfd141c0fb 100644
> --- a/tools/testing/selftests/net/forwarding/Makefile
> +++ b/tools/testing/selftests/net/forwarding/Makefile
> @@ -1,5 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0+ OR MIT
>  
> +CFLAGS += $(KHDR_INCLUDES)
> +
>  TEST_PROGS := \
>  	bridge_activity_notify.sh \
>  	bridge_fdb_learning_limit.sh \
> 

Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
