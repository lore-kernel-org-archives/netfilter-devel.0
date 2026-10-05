Received: from smtp.forwardemail.net (smtp.forwardemail.net [149.28.215.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139E144E656
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 13:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.28.215.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205475; cv=none; b=JFY5YR6kAlgpPxqgDllrvq8LuIDDpR48xm9btoR6icbS/eTrqmWdt0RRbMegzVDVc2LdVjA40Hvs3W28wipkV7mAWAuTBrZik2Oz8Betf1ADnK2WXTFRt9PcC2K16d3/3icot2SWM/1FO9kkuvfNNhvH5g+IdDzn7keiNJMsY3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205475; c=relaxed/simple;
	bh=XgCtgbQRcxPoGRe8mzzM1S1ureZ3oYqdHQgqKRmIIZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zg3ZgPTmHwyvYRxo2nd87Rgr/MNCjumU5kjztS+0pVpGjCAoPkXi7FRtaGhaOO1IaJDxXB7VcvZC4M5QRDuT6GdxdpM1TLhE96kL79dgN9dURBMJ2CV3xJHs6jnIW+9pKhlkkMms5rJVUpt/V6gb2SyPwUOjR3nMsBbOZPcZkhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=fe-bounces.ovn.org; dkim=pass (1024-bit key) header.d=ovn.org header.i=@ovn.org header.b=ADMVgs3F; arc=none smtp.client-ip=149.28.215.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.ovn.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ovn.org header.i=@ovn.org header.b="ADMVgs3F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ovn.org;
 h=Content-Transfer-Encoding: Content-Type: In-Reply-To: From: References:
 Cc: To: Subject: MIME-Version: Date: Message-ID; q=dns/txt;
 s=fe-13eddc7e57; t=1791205467;
 bh=2KrfVbD/U4yfYNyvzPDSSWso/SrtmjhxxY8z5tMgGsc=;
 b=ADMVgs3FLMfzmSNuiasLgPWl+8r7gtWU5IBR2+D/I9qgusyxkkUh15hq+zixQnKxuwtyDQInX
 ho711T2F0lkkxoLjeu2ISxVRxAk9MtgnhSuZEVYPjEQRet8g2csevxoLT9rY5dxnF9+meb6ZpBI
 l/7gnMqOzTJteUGVYl/ir0A=
X-Forward-Email-ID: 6ac3a055667e8e74acdfd199
X-Forward-Email-Sender: rfc822; i.maximets@ovn.org, smtp.forwardemail.net,
 149.28.215.223
X-Forward-Email-Version: 2.18.1
X-Forward-Email-Website: https://forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Report-Abuse-To: abuse@forwardemail.net
Message-ID: <e909312d-76bd-498b-afec-86a1cd611e1c@ovn.org>
Date: Mon, 5 Oct 2026 15:04:18 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 01/11] netfilter: synproxy: fix reset of ct
 seqadj when reopening a connection
To: Pablo Neira Ayuso <pablo@netfilter.org>, netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg,
 i.maximets@ovn.org
References: <20260927223436.269024-1-pablo@netfilter.org>
 <20260927223436.269024-2-pablo@netfilter.org>
 <179054884482.31693.9985445366421543993@kernel.org>
 <armg511ZWKl5ZqhZ@chamomile> <asKoa2wFW5QneXEA@chamomile>
Content-Language: en-US
From: Ilya Maximets <i.maximets@ovn.org>
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
In-Reply-To: <asKoa2wFW5QneXEA@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

FWOn 10/4/26 9:26 PM, Pablo Neira Ayuso wrote:
> Hi,
> 
> Just a gentle bump to this net-next PR containing Netfilter updates.
> 
> Let me know if there is anything that needs to be addressed.

AFAICT, this PR was merged to net-next on the 29th:
  https://git.kernel.org/netdev/net-next/c/0a1a3898ab64fd4f7b90816fc61186d8eb5302a7

The bot was a little confused, but the reply was actually sent:
  https://lore.kernel.org/all/179064961102.229594.11396134169189168960.git-patchwork-notify@kernel.org/

Best regards, Ilya Maximets.

> 
> Thanks.
> 
> On Mon, Sep 28, 2026 at 01:04:07AM +0200, Pablo Neira Ayuso wrote:
>> Hi,
>>
>> On Sun, Sep 27, 2026 at 10:40:44PM +0000, netdev-bot+sinfo@kernel.org wrote:
>>> Hi!
>>>
>>> This is an automated message. This series looks like a fix, but its
>>> commit messages seem to be missing some information:
>>>
>>>  - How the issue was discovered, e.g. hit in production, hit during
>>>    development, syzbot report, manual code inspection, LLM or static
>>>    analysis tool scan.
>>>
>>>  - Whether the issue was actually triggered, or is only theoretical
>>>    (e.g. found by code inspection). If it was triggered please include
>>>    the symptoms, like the stack trace or error messages.
>>>
>>> Please do not repost the series just to address the above. Instead,
>>> reply to this email with the missing information, so that reviewers
>>> can take it into account. If the series needs another revision for
>>> other reasons, please include the information in the commit messages
>>> then.
>>>
>>> The evaluation is done by an LLM so it may be wrong, if you think
>>> that is the case please reply and explain.
>>
>> This are correctness fixes (no crashes to my knowledged, hence I
>> decided to target net-next) as the cover letter specifies:
>>
>> Patch #1 TCP sequence tracking issue was reported by sashiko as the
>>          cover letter says.
>>
>> Patch #2 Just documentation update to fix incorrect information
>>          about the maximum number of expectations.
>>
>> Patch #3 Just a cleanup patch to remove a break;
>>
>> Patch #4 Just a cleanup, typos in comments.
>>
>> Patch #5 and #6 are the result of a human triggered review of the
>>          conntrack error stats by Phil Sutter, I think.
>>
>> Patch #7 is a preparation patch for #8.
>>
>> Patch #8 removes a unnecessary workqueue flush, submitter does not
>>          specify if it is visible in production, I suspect with
>>          a very large number of netns it must be. Author does not
>>          claim LLM assistance.
>>
>> Patch #9 is a fix triggered by sashiko report IIRC, I deemed it too
>>          large for net so I am routing this rework-fix to net-next.
>>
>> Patch #10 is a feature fix, IPv6 filtering does not work.
>>           I suspect it was found when trying to use this (broken)
>>           feature by the submitter.
>>
>> Patch #11 Ilya Maximets reports the CTA_ZONE filtering feature is
>>           not easy to infer from userspace, I don't think LLM
>>           triggered this, it looks more like an improvement to help
>>           userspace tools discover this feature.
>>
>> This is human written reply, my cover letter has been generated by me
>> too to provide more context on these patches.
>>
>> Thanks!
>>

