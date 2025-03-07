Received: from smtpcmd03116.aruba.it (smtpcmd03116.aruba.it [62.149.158.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBD513C8EA
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 19:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741375998; cv=none; b=tpgQavMCfxIsrSOF207zoGfSNWZ9uhKsI0Dd7FYyswp4l6OsACDcyZoMflbhIMhB2Jqf5rsKWYNKxCP/opiNar+LBBg3VJZwgmIQtXBaSUQesfERXY16lBeSy5klycBPWIJd8RKwOVSgLf0Pvl55s8kl/q+odsJIwvqkOmzdoRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741375998; c=relaxed/simple;
	bh=j3VcC882O2USZdngfmzICHNDOamoMBzI62ieth2JG2s=;
	h=In-Reply-To:References:MIME-Version:Content-Type:Subject:From:
	 Date:To:CC:Message-ID; b=gy4ABlGx5Egu5XCZrId8zVx7maUKAqJmKBTrdibTDrOMOZOZX+1LNjIlLpoMDqdpbJBdO8HONjU7+2aKlHB5/YoYSuS+UOTKnvd307EJlBj3VSU8tu8uCY+DvmeQUfZL0nxqfp/BSTkQLMN9WNXHrwJi4eU3DBEpNvC7XX7X8vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com; spf=pass smtp.mailfrom=trentalancia.com; dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b=ZSqp3JO/; arc=none smtp.client-ip=62.149.158.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trentalancia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=aruba.it header.i=@aruba.it header.b="ZSqp3JO/"
Received: from [10.47.193.93] ([109.54.115.5])
	by Aruba SMTP with ESMTPSA
	id qdRTtR30MmHkSqdRTtWWVe; Fri, 07 Mar 2025 20:33:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1741375989; bh=j3VcC882O2USZdngfmzICHNDOamoMBzI62ieth2JG2s=;
	h=MIME-Version:Content-Type:Subject:From:Date:To;
	b=ZSqp3JO/nQ1YcQyPOMbgT5oycLIp0EtWmDqqtRscubvcc/TvcYNwQDLEyqzS2fF3f
	 bNCgakVF5Fh4dXWMGWQ88ACIwQfG6eiSKpoYFV1IpPzvxMpF8cZkmX0TaC1aUtQ0Xa
	 6oUqrOob3Wu4s9vo2AegqzwUAIYxyb+UVv51OpQlcMBY0Q8M04WNwaGbzYftXkm+Y5
	 YFFTDWj/LlB02zamyt9IlhbBvBh1X1M7phV8AgnTCFSSvSruZCfK9u4iCtKv5DN7VG
	 OWd1PceXGKSOufmdbVchVvr46QLSnlKvGWnSrCK96IzsvMb0GLtlVZuLrk+fVRvSWl
	 Vm6rWjVj1KPRw==
In-Reply-To: <cc4ecd68-6db9-42e6-b0f0-dd3af26712ec@thelounge.net>
References: <1741354928.22595.4.camel@trentalancia.com> <qn655027-4830-ps48-87po-r61npps888s5@vanv.qr> <d8ad3f9f-715f-436d-a73b-4b701ae96cc7@thelounge.net> <1741361507.5380.11.camel@trentalancia.com> <cc4ecd68-6db9-42e6-b0f0-dd3af26712ec@thelounge.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH iptables]: xtables: tolerate DNS lookup failures
From: Guido Trentalancia <guido@trentalancia.com>
Date: Fri, 07 Mar 2025 19:32:05 +0000
To: Reindl Harald <h.reindl@thelounge.net>,Jan Engelhardt <ej@inai.de>
CC: netfilter-devel@vger.kernel.org
Message-ID: <76043D4F-8298-4D5C-9E98-4A6A002A9F67@trentalancia.com>
X-CMAE-Envelope: MS4xfAKSrBGEA/Ww2rJ4TBsifLDN+Ki04l8IKdEzkTG1n40/rtgLHuwt7P1hACIvRqfwKraC5XQ+7kJ0ocY+ergfQ9vi33UHVkVcHVTnSwQViBO83XwE/hPZ
 IisOFnkQGyA4+2JMrXrTo3KsorhzhoRuae3mLVMmxRbl4MeJR52OZrfBlIB3cmuROwcVc8B2X1IPSmV031k2ocFljHDjiyIz6omcGoTA7FTSDuTbLZZ+rR5M
 wn9FHMCmqkuFgzTW/yEZ2N6TOr4papRZGFJwHyxJUBE=

That's the way it is, I am personally against the practice of resolving FQDNs dynamically, but many commercial services do so and the only way of setting up iptables rules in that case is using FQDNs...

Iptables has always supported FQDNs, we are not talking here about removing that support or whether it should be used or not, the point is makjng that feature more robust and fault-tolerant.

I believe the patch improves the current situation for those that wish or simply must use FQDN-based rules.

Regards,

Guido

On the 7th march 2025 20:15:39 CET, Reindl Harald <h.reindl@thelounge.net> wrote:
>
>
>Am 07.03.25 um 16:31 schrieb Guido Trentalancia:
>> Nowadays FQDN hostnames are very often unavoidable, because in many
>> cases their IP addresses are allocated dynamically by the DNS...
>
>which makes rules with hostnames even more dumb
>
>frankly you can't write useful rules for dynamic IPs at all
>
>> The patch is very useful for a desktop computer which, for example,
>> connects to a wireless network only occasionally and not necessarily
>at
>> system bootup and which needs rules for IPs dynamically allocated to
>> FQDNs.
>> 
>> Guido
>> 
>> On Fri, 07/03/2025 at 15.48 +0100, Reindl Harald wrote:
>>>
>>> Am 07.03.25 um 15:07 schrieb Jan Engelhardt:
>>>>
>>>> On Friday 2025-03-07 14:42, Guido Trentalancia wrote:
>>>>
>>>>> libxtables: tolerate DNS lookup failures
>>>>>
>>>>> Do not abort on DNS lookup failure, just skip the
>>>>> rule and keep processing the rest of the rules.
>>>>>
>>>>> This is particularly useful, for example, when
>>>>> iptables-restore is called at system bootup
>>>>> before the network is up and the DNS can be
>>>>> reached.
>>>>
>>>> Not a good idea. Given
>>>>
>>>> 	-F INPUT
>>>> 	-P INPUT ACCEPT
>>>> 	-A INPUT -s evil.hacker.com -j REJECT
>>>> 	-A INPUT -j ACCEPT
>>>>
>>>> if you skip the rule, you now have a questionable hole in your
>>>> security.
>>>
>>> just don't use hostnames in stuff which is required to be upo
>>> *before*
>>> the network to work properly at all

