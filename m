Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362E64A091D
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 17:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791306381; cv=none; b=sizQVYzNzfpaxzLCOW7GHJEYm6r7tt920zJTssmTiq/snvbJ/JLsf0M4GkKzhbOsBDftm65kYs8DnDY3PJHEQMTWYdtk8fBpkix4yETNkom+j2G6JWomGKYaB2Dd7b8cYwmQeBx4NumYWWduz7YMjI2l2MswELa4HOD/e3SoV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791306381; c=relaxed/simple;
	bh=RY3wiaMI0v7K6zoFO06w3Wd7GSvNT/7FjhzrKGQeuzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ru50TE5ApYGN/8iFM6ok19HQh0rTlwzncOW9wY5FUTUksjoT2Oms3l7TW63nmNbgNvBIcZt3DkdLyqK8jnpz4HnNWiaSMebxWPzS/Fchgw2KSLTDaycaEK21cxgfbhKRvfj6DtmeHypBIwKhlE6Wd9CqXoP9x+4wTYV54uONTP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7DLNZ9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7DLNZ9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58FC1F0089B;
	Tue,  6 Oct 2026 17:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791306379;
	bh=fIkNth87PAAzC3dHg82y10jHNstH0u3W2KqSxDhGDFw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e7DLNZ9ObHgOCdY4G1pC1mpRdRJruWKN/9Vr+vWlYcVmHd1M/qyr3SLW73yLZSdcj
	 zQB6tPCYeLpodNogEqDlUCErXD+NOYBCMsHThJivF6Sj+nOSV7QMF+MkyytdEInjJV
	 VBG8/tpP6yw3/BaAOD2y4T7E2FWRDXrkYKxij4DXdmoW9y5bLHSk+mMcXxuy1AlPD2
	 IKUpq3mrFV/CKw+a8tpQvAcNMlZuGDqGivWIdYNhvMtdCl2GCiCqnFYg3Pbvj9vo1u
	 0ekVNKUKwJrDLiEqsV/S21km0zxzhXdz7w4OZ8Gyje3VIbPrptfCx/9nTadUdl45Ei
	 DAWKHb5DCQCYw==
Message-ID: <c50a369c-b126-4369-830f-cb675f920ef4@kernel.org>
Date: Tue, 6 Oct 2026 19:06:16 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH nft] doc: add MPTCP subtypes documentation to man page
Content-Language: fr
To: Fernando Fernandez Mancera <fmancera@suse.de>,
 netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
References: <20260929141425.4852-1-fmancera@suse.de>
 <ef8c754d-616f-489f-b556-073efa491cd2@kernel.org>
 <c9ea9b66-ddf8-44c2-bfc5-9dfacf837b8c@suse.de>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <c9ea9b66-ddf8-44c2-bfc5-9dfacf837b8c@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Fernando,

On 01/10/2026 10:58, Fernando Fernandez Mancera wrote:
> On 9/30/26 8:38 PM, Matthieu Baerts wrote:
>> On 29/09/2026 16:14, Fernando Fernandez Mancera wrote:
>>> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
>>> index ceccfdaa..f1de0956 100644
>>> --- a/doc/payload-expression.txt
>>> +++ b/doc/payload-expression.txt
>>
>> (...)
>>
>>> @@ -833,6 +859,18 @@ filter input tcp option sack-perm exists counter
>>>   filter input tcp option maxseg size lt 536
>>>   --------------------
>>>   +.matching MPTCP suboptions
>>> +--------------------
>>> +filter input tcp option mptcp subtype mp-join drop
>>> +--------------------
>>> +
>>> +[NOTE]
>>> +====================
>>> +Netfilter currently evaluates only the first MPTCP option found in
>>> the TCP
>>> +header. If a packet contains multiple MPTCP options, a rule
>>> attempting to match
>>> +the second option will never match.
>>
>> Would it be interesting to give an example? e.g. a rule attempting to
>> match 'remove-addr', 'mp-prio' and 'mp-fail' (and 'mp-tcprst' in some
>> cases) are not going to catch anything when the traffic is emitted by
>> the current Linux kernel stack.
> 
> could you provide a good one? Ideally the documentation should be as
> simple as possible. I thought about adding the rule you asked about
> initially.. but I realized that simply describing the issue was better
> IMHO.
What about something like this?

  Netfilter currently evaluates only the first MPTCP option found in the
  TCP header. If a packet contains multiple MPTCP options, a rule
  attempting to match the second option will never match. Having
  multiple MPTCP options in the same packet is valid, e.g. the Linux
  MPTCP stack inserts 'remove-addr', 'mp-prio' and 'mp-fail' after an
  MPTCP 'dss' option ; 'mp-tcprst' can also be inserted after an 'mp-
  fastclose'.

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

