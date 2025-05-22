Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B1328BA87
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 13:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747919691; cv=none; b=OTd14OZ8P/cvJxQNBEw6ZYxzp31DhQcSrcPCc5jCh9Zr2u4ppiolaSw62wS6pUvxrA4fwnJaK9yeN9vJzXRE/wXdVrfFDPxPrEwSr4ftRLdgvoUAMX8easMqb3NRsm2CNqR+XXY+/Fddv7gP4aKFlKlpvUByhOSzUCnukIDWU0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747919691; c=relaxed/simple;
	bh=SaSB3ddwwPMmreGyO/Kn8A5EPGT9AUMYcTpd+Xq3L+k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JjEVfl/LJ7OFJuozYzwDY/97xMNsYqGC4cnST5dapsnxJtosiTay1lywnsaXTr87TCMmF/VtsKFMTdmmhmE7kDICevwG1eAE1v2gMAaBM8hb8hVObe1bKcAAXwDbSwBp2NnST4aWifycaUA+BG64wH8gnoFsgelCx99s+urjv7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TIBl0mPO; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TIBl0mPO"
Message-ID: <0e89bc09-c0ee-49d0-bbde-430cca361fd6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747919686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h+Tav8BKfCsv9Hz47ZDAfnt3+WGX/PQEd2zdWgY5sEQ=;
	b=TIBl0mPOiTPdt4QODwpi8kJYfnKvCYW/bhRyMLowZxiFF0KlFFwJ34qSHJDMwumBR0iEZi
	j+E10yIgmVaqVI1ozSSm4MBEdcT2ASZ6XnZztoXw7/eQTWZwDuxURLbmrpMxiVYXUvY8JH
	ntc1EBtXJA5XBrE82e0M9kWxGL0m0rQ=
Date: Thu, 22 May 2025 21:14:32 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RESEND PATCH 1/1] netfilter: load nf_log_syslog on enabling
 nf_conntrack_log_invalid
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Lance Yang
 <ioworker0@gmail.com>, kadlec@netfilter.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 coreteam@netfilter.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, Zi Li <zi.li@linux.dev>
References: <20250514053751.2271-1-lance.yang@linux.dev>
 <aC2lyYN72raND8S0@calendula> <aC23TW08pieLxpsf@strlen.de>
 <6f35a7af-bae7-472d-8db6-7d33fb3e5a96@linux.dev> <aC4aNCpZMoYJ7R02@strlen.de>
 <1c21a452-e1f4-42e0-93c0-0c49e4612dcd@linux.dev> <aC7Fg0KGari3NQ3Z@strlen.de>
 <ac51507e-28ca-404d-a784-7cc3721ee624@linux.dev>
In-Reply-To: <ac51507e-28ca-404d-a784-7cc3721ee624@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/5/22 14:53, Lance Yang wrote:
> 
> 
> On 2025/5/22 14:34, Florian Westphal wrote:
>> Lance Yang <lance.yang@linux.dev> wrote:
>>> Nice, thanks for jumping in! I'll hold until the helper lands, then
>>> rebase and send the v2.
>>
>> Please just add this new helpre yourself in v2.

Does this helper look correct?

/**
  * nf_log_is_registered - Check if NF_LOG is registered for a protocol
  * family
  *
  * @pf: protocol family (e.g., NFPROTO_IPV4)
  *
  * Returns true if NF_LOG is registered, false otherwise.
  */
bool nf_log_is_registered(int pf)
{
         struct nf_logger *logger;

         logger = nf_logger_find_get(pf, NF_LOG_TYPE_LOG);
         if (logger) {
                 nf_logger_put(pf, NF_LOG_TYPE_LOG);
                 return true;
         }

         logger = nf_logger_find_get(pf, NF_LOG_TYPE_ULOG);
         if (logger) {
                 nf_logger_put(pf, NF_LOG_TYPE_ULOG);
                 return true;
         }

         return false;
}

Thanks,
Lance

> 
> Ah, got it. I'll do that.
> 
> Thanks,
> Lance
> 

