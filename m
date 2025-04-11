Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF21D1DFE8;
	Fri, 11 Apr 2025 15:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744385582; cv=none; b=ZFRzQw2YI1eiW9m0n/njH/ah8xlPDF9yp9z/OdO5MuqWRh02y1Xpsd4AJcir4oVVXmnwJCeGSJujAhAmFcW9+RDuP0pgVWQjomOOy9Pi54Dy5Tflcd8M/LTG5sKZS4/AkdB/qVWGdOZluUBNUhzHlwpV3OIYwzoaAxy/JvlfG2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744385582; c=relaxed/simple;
	bh=SK20TAu2zChiQ6H4NX04M0Z/CKTqKRyl5xeevWD9xKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FzvzPeYcNKHkBWkIeqcfyC8Q497EvTt4g8B/zkPcfjlnwwHkgUJQZ/yWkMTcB6Rxcy8c/rVvSTzn8agePj1IOIDkW7PaZNEz80UyYuKJuD4uUiSk5MpWWPoQagOon3aDTJfOjeiMK3G0rbS1SxhM8TA50IjuidSeATOvZd7PWNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UqfYoRTD; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UqfYoRTD"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so351673366b.1;
        Fri, 11 Apr 2025 08:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744385579; x=1744990379; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tNVSnf5GwiH/UxtGMsp05lXMOaVN7SeAGm2fto6OjI8=;
        b=UqfYoRTDEpbfgAeFCjHVRv2Pvln1PjgC8ptAhE6ebyYYXITIoCQ59EjVulMbwjkB1Z
         Dcd+bEvc0UptMOpc54pG9aIo0biK+klYlmvs537rfrTVmuEEKf9kOsS1aM3a7AqF3WXI
         jUHjdubpQ3zqRJ9jeCx5wfpSQctBLSrPXFTHXZAyZO6J6gRSEypD/PKR4LoB+6sJR9tM
         oNxBu1huOneXx2P7QzW0ZnH32x+0J+1wOfh8vuTjG+heZ760Z5HZNwdm5ntDbkutsaOT
         LjxEAi2jbiISUPqATMRHcRY5X0CzKudmSAcyHUBpIujWEJEo8Ths+4mf40+7uQe+hO0y
         thRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744385579; x=1744990379;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tNVSnf5GwiH/UxtGMsp05lXMOaVN7SeAGm2fto6OjI8=;
        b=Gf29x8xeODfOoIzFECY/qF5/6myijXMEG572uvKxLWL1DrR/vRTrZYCbpAhAeHluVw
         6nhIbfXBPeofIvS554gzjlzWu6DJGDgxf45eCdNhWt8fNFhdBd/OHe5bf+mVju3QBFAV
         d2jVLlyl87BSFwzubxik9lR0HCLZNMboL9sw7GoXT4Yj7/JbmYzohoRIr1TRTWebW3eI
         YztmMAlVVejMvTAukgyosjHiFmuqgw4TxFrs8IQFYS+RrDwXQlDF4fKY/Un/TTV0Habw
         diXJ8BdyOZkTIJFUnDMWv/oXFo4T6x7ApMPewEUZCDB8qsaDUwZvC4/wGjmnFFTA8rG1
         ZHVg==
X-Forwarded-Encrypted: i=1; AJvYcCWwFTE2E0C5fNkKXSbn3OZBMqBv8ec6W6DUW8P67mWZEXSy4DG9OEY5QXrTNHg8yIeFxdLbS80=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVb3WBb4O6gOxyqVl2KUX5XPLBSLU7jgnCRCTBWjU2fM994c8c
	0ZWQozzgalpWN0SJSmvBGe1wPEKT1fZdudj9VGaMd2kzR3RgFyGW
X-Gm-Gg: ASbGncvhUyDsP+rAgCY/I6/+UzdHnx5X1+GAtubJv7hBWu3IepKTkMBtWNqC/ogyun3
	14CU4I4ytcd6mJNhHfP0z3r4I/u8xkdLq4n/qSbKfPEv/bYV3LFS4VNxRNFbI+3z795NjTOA8H7
	5Cfi9p7ZvpZA144KZlAx0VsBdJ/Ibx1s97r+dqH17nsafvAL4Mys4dANmCjY6szBIU4ZWxx9oCl
	CxcVxb+B5QZmjt8Dc6RMicnrtDBLqqzrgIlT1m/hPyp4EO/0II8vB/m3FC8gJOjTPCTvolvi0SN
	6XPy6zIst79LjuivlmRA+rRfGwE6qZ28xcz7TR0CL167lYjJZaRWSwx+yL+YbEOl/Z8pVgK1JPQ
	z7Slo26QZhg==
X-Google-Smtp-Source: AGHT+IGMR93dTVW9LPxRdbl6uF4brghdUA2jSq/lImtb/EyM5W+MSHr1Z1j1zRbyov0ix1sDOE6Saw==
X-Received: by 2002:a17:907:3e0e:b0:aca:a539:be04 with SMTP id a640c23a62f3a-acad3457588mr274642566b.4.1744385578753;
        Fri, 11 Apr 2025 08:32:58 -0700 (PDT)
Received: from [192.168.1.149] (84-106-48-54.cable.dynamic.v4.ziggo.nl. [84.106.48.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acaa1bb3574sm457912566b.23.2025.04.11.08.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Apr 2025 08:32:58 -0700 (PDT)
Message-ID: <74e994cb-5ac7-4f91-8f3f-1e355c6d3d8d@gmail.com>
Date: Fri, 11 Apr 2025 17:32:57 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 nf-next 0/3] flow offload teardown when layer 2 roaming
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>
References: <20250408142848.96281-1-ericwouds@gmail.com>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20250408142848.96281-1-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/8/25 4:28 PM, Eric Woudstra wrote:
> In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
> used to create the tuple. In case of roaming at layer 2 level, for example
> 802.11r, the destination device is changed in the fdb. The destination
> device of a direct transmitting tuple is no longer valid and traffic is
> send to the wrong destination. Also the hardware offloaded fastpath is not
> valid anymore.
> 
> This flowentry needs to be torn down asap. Also make sure that the flow
> entry is not being used, when marked for teardown.
> 
> Changes in v2:
> - Unchanged, only tags RFC net-next to PATCH nf-next.
> 
> Eric Woudstra (3):
>   netfilter: flow: Add bridge_vid member
>   netfilter: nf_flow_table_core: teardown direct xmit when destination
>     changed
>   netfilter: nf_flow_table_ip: don't follow fastpath when marked
>     teardown
> 
>  include/net/netfilter/nf_flow_table.h |  2 +
>  net/netfilter/nf_flow_table_core.c    | 66 +++++++++++++++++++++++++++
>  net/netfilter/nf_flow_table_ip.c      |  6 +++
>  net/netfilter/nft_flow_offload.c      |  3 ++
>  4 files changed, 77 insertions(+)
> 

Hi Pablo,

I understand if you are busy, but this patch-set could be reviewed
totally separate from my other submissions. It addresses the issue of L2
roaming for any fastpath.

I'll wait for any other comments, before sending the fix for 'static'.

