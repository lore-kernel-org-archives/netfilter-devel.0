Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3639041C85;
	Tue, 25 Mar 2025 06:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742885216; cv=none; b=m4/Kc1Z48BLC3w3R3jHO9Jt75xSXNb3wqG5jQ/uqelEqpMUGrB0ZDyFq5GFR9dbg+qvdfPSkD+6MJ8tewOKJdJ9QV4NQpbLEv4UP94Sd0IfupfSfCi3iLPoHrGKk43/s70IvMmlRaIY/WlClx8wWhXYw8b20U9wN+X0irJUCbNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742885216; c=relaxed/simple;
	bh=DDHLVmQ9P26kEjdc73xBXzvR43q1Q8aMFQCblbCiNQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pR9mvJHn/mhlTYwmr+Lxiwx6ZzIH4/6oqiWttXrWGqHn9l5c/ZUZUJO66oFdaafB+z2lg+F3AtdbvWObhV+XwhWpD3YzK4oOC1SP/sx7UPUqZp8Z/X0BtLLuTnd4o+YR0qJRZiVr8G3g3UjoyrnTvfzsWIB3R0XxnQbHukVaPz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EaFQMD2P; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EaFQMD2P"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so7902496a12.3;
        Mon, 24 Mar 2025 23:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742885213; x=1743490013; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Yqv80t/9Wr1HI/sitZphT3z5GEhIavfE5giNdMHJnw=;
        b=EaFQMD2PrrZN7HyQd20DWxNA0isVT8fFPNGbNLAPCytmlry+EfAwpnK3q3xQNofn3S
         ZdQqSy/zRA9jdeKd3fhPI3/wNYW6CulBGIaqyjgOjFdKL3SFRelFRTtEviJ6GTI8hire
         DT+EkKTlZZUGc7sUWnW77nwe4GiTXXz25NY5Owj4qrVCoTn9k2DJ5UcVnFvjV2+UY6WG
         rdV04QStXnVaw7ZsB0Xp+IcIk04Wq+Pmw3v3OBdg9tcXyQtIH479wYM9U8vDaPeo/HZQ
         M97GLeFWOWtkYdvIdrO00daETOUXn94DYT53eVRyB3BOmNNYY4D8z+YrjTw/ft6WJxsM
         ubAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742885213; x=1743490013;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Yqv80t/9Wr1HI/sitZphT3z5GEhIavfE5giNdMHJnw=;
        b=XO0qhzwP3MUTDZ0CgcTeKkRLO4yhfI/wLBUn/7eFFJ8SHN0ldXDAkZhmkmTbCMKJWt
         F5gV1F3/dg8MsIcDL7Iuzj4XXlFMtaFQOlrbQlB1vsQFq/4GYm7L8m5QeyCKcDmYvxCX
         t5j20MsV9TGbZ8TFB6mavWSdvbYXagMIEgiVaTQgScL1Buy9ftv2bHA255n9LhDBqkfL
         zpnNx314Jf3By6jM17JpYuosp9sQ6dNpqSyK32eAoL0y0xwVRmPNw9+ksF6qfkLAFcbP
         Dv1mrmGIJ99G1z6d+87fqCoRic+icMPpdW5Gjy2xvy+AU/w5K7KPLiXz3vSEfRUF+8jd
         4A8g==
X-Forwarded-Encrypted: i=1; AJvYcCVTFARPWCpdtqO+BVmlDI2iEtcYXYFSF5+UluqzDNDDP74F+Y54H6v8P1FL0fQt4ndpg+ynV/BF+si+3RA/IH8=@vger.kernel.org, AJvYcCVV61WjqMdTYIUhG8afWYdEZabeArb5s6i7rGW3cJGRrSrAo1U8kVY5sEs6XEjExDu7BhZEY5mV@vger.kernel.org, AJvYcCXiOn1EPJxZpiHMUEJMWf8X9RWidbijP3KM19TVl4AN9IsEtgF3cOdbV2TS5cdcYcsjFJ4m17RAUm5n7aFRi6+e@vger.kernel.org
X-Gm-Message-State: AOJu0YzmMPMzYHd3rnLbL0fmjXMvCfrxfEFR6WUb/0BHomfyBtUiFqOo
	0gfLqwrFQajmVSgLImM2n1HFiAKzDrE0pPChsS0mJMJov5butlIay+WnAA==
X-Gm-Gg: ASbGnctHWa8ou9xgRIJ5f3+MB2pJUViYH8huJ3AdERAAYTI973M7x0BPl9W8sLEQNTp
	V2H9cwHf/K/xW8Rm4/COjByQBHxTeS1P+P+pMBU3WSgA33+uEST5ylqmI3fizh/5sXCIIjbMm5t
	HSYWfeKS+ojO/G0dH4cNy30sQzHA7H6p3cwVEfw7ZvVsFNmQbZ73UBaLX2P48ad0nmDg0x4uLDo
	x3Fs0N/DlGd/16MEWFi+Mbpvi8p7ghtBLFQb9xPcKtzBTi3+Q/Brg+5HbSBi09k5qwbXuGuLEKS
	awvg19Ohdb4evGSlJTcgUu0RtgE8bTFYqDa9/KjjppDKSvKXRRbMuM7cFPgpF7YHXRzKitIVB4A
	9dTyx3JrGjPImuZ0Be51nWuINv98R/VlHTWAE2T1F/m6QTwb9YfBPkOZL4vBQbb5u3LfUlgdDu0
	RUJwQ4/06uYPSxAppVy5g=
X-Google-Smtp-Source: AGHT+IHdW/he/t+ulHwxapTZHEyLROUazSeqYd0FQN0flbEiwYJzrbKOMPbT0gu9sUrhAjLE/OE1tg==
X-Received: by 2002:a17:907:d7c8:b0:ac3:9587:f2a1 with SMTP id a640c23a62f3a-ac3f20f2eadmr1557908966b.20.1742885213092;
        Mon, 24 Mar 2025 23:46:53 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efb658b4sm795792166b.118.2025.03.24.23.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 23:46:52 -0700 (PDT)
Message-ID: <b5818a44-5363-4e10-b4ff-d751b124acd8@gmail.com>
Date: Tue, 25 Mar 2025 07:46:51 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 nf-next 1/3] net: pppoe: avoid zero-length arrays in
 struct pppoe_hdr
To: Simon Horman <horms@kernel.org>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Nikolay Aleksandrov <razor@blackwall.org>
References: <20250315195910.17659-1-ericwouds@gmail.com>
 <20250315195910.17659-2-ericwouds@gmail.com>
 <20250323164800.GR892515@horms.kernel.org>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20250323164800.GR892515@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/23/25 5:48 PM, Simon Horman wrote:
> On Sat, Mar 15, 2025 at 08:59:08PM +0100, Eric Woudstra wrote:
>> Jakub Kicinski suggested following patch:
>>
>> W=1 C=1 GCC build gives us:
>>
>> net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through
>> ../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h,
>> ../include/linux/netfilter_bridge.h): include/uapi/linux/if_pppox.h:
>> 153:29: warning: array of flexible structures
>>
>> It doesn't like that hdr has a zero-length array which overlaps proto.
>> The kernel code doesn't currently need those arrays.
>>
>> PPPoE connection is functional after applying this patch.
>>
>> Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
>>
>> ---
>>
>> Split from patch-set: bridge-fastpath and related improvements v9
>>
>> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> 
> Hi Eric,
> 
> Perhaps this is due to tooling, but your Signed-off-by line should
> appear immediately after the Reviewed-by line. No blank line in between.
> 
> And, in particular, the Signed-off-by line should appear above the (first)
> scissors ("---"), as if git am is used to apply your patch then the
> commit message will be truncated at that point. Which results
> in a commit with no signed-off-by line.
> 
> FWIIW, putting the note about splitting the patch-set below the scissors
> looks good to me.
> 
> ...

Thanks, when I noticed it, it was send already. I've changed my script,
so it should not happen anymore.
