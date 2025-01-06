Received: from smtp-out.freemail.hu (fmfe36.freemail.hu [46.107.16.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3471D8DFB;
	Mon,  6 Jan 2025 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736165033; cv=none; b=NzoWYEcrjcycvFoF3tXAjddpW5eX19partp+yesFFQ85eE9c9HSBxhBQ8EkjhGBS/DCUB8QVcc1pUFkdW+WyE0ALVmz3FWyzO/KUty3BDH2DaIBj9AMGC6frkA3L9AMmE/nfgHa1VTc7Ehzu/oy8/isOyRzGM1eM9fR9UhgwHU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736165033; c=relaxed/simple;
	bh=cKyFKZR8HQPXJkeEyTijZcFLJGpOeI0uMNffok1MTsg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRUkwdYv+Lw7c+EeL0LUYaXX8vVi5jaUWYIXASwsfV6fm/aadUEwEl3Ettwvh5GqlNlAB3ufg4MBWkTe5hTZhCdzPzilArlcBMeka2mATL3WiTcq9V4wkXthU9HPlJTq0BuShXCJV4+aYqE7POK9l6ocrjF/95NRrO7TEvFUuCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=QWehaBey reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="QWehaBey"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4YRXfr71Lrzgkg;
	Mon, 06 Jan 2025 12:55:00 +0100 (CET)
Message-ID: <cb4b77e3-65c3-4fd4-94bb-a2b35a6dcfb5@freemail.hu>
Date: Mon, 6 Jan 2025 12:54:31 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h
 files which has same name.
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>, lorenzo@kernel.org,
 daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com,
 kadlec@netfilter.org, David Miller <davem@davemloft.net>,
 dsahern@kernel.org, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250105203452.101067-1-egyszeregy@freemail.hu>
 <43f658e7-b33e-4ac9-8152-42b230a416b7@lunn.ch>
 <defa70d2-0f0c-471e-88c0-d63f3f1cd146@freemail.hu>
 <ee78ed44-7eed-0a80-6525-61b5925df431@blackhole.kfki.hu>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <ee78ed44-7eed-0a80-6525-61b5925df431@blackhole.kfki.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1736164501;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=2518; bh=lfy5n6CsbSpr3jgDmUldoHdcbJ2OBU+Aw/IlhAEFXic=;
	b=QWehaBey/DzTZIUvU3+1P1PzJNJyp51bP1Kc4tirkqFQZXUTsFw8E6Ce6LOHioL4
	O7J+W2vTFmT3fdGCnbv5tuIlI32IKZeJKFk2+btgqb00Whcaw/cZkHVAC/jNfHr9qmR
	O+AYjVy+nJ45k4Lk3ArSIXq7K3I1dmfKBQK/KUn1BJEyDCKw1HOPzPsnd+R5ZC2xPv3
	Ej80t0bWtZvKvGnXrwiqgi4ncglg1a2fejAZCjFfLEepnmGPScWfWG1J+muRU+w+RRB
	GIuMWUm3QKAE34rirBTLqktS6JTqktAh7YGCaN2drjNyE8OAno0SS9FiCC7i6ojbKna
	mGhgfT0DmA==

2025. 01. 06. 8:48 keltezéssel, Jozsef Kadlecsik írta:
> On Mon, 6 Jan 2025, Szőke Benjamin wrote:
> 
>> 2025. 01. 05. 22:27 keltezéssel, Andrew Lunn írta:
>>> On Sun, Jan 05, 2025 at 09:34:52PM +0100, egyszeregy@freemail.hu wrote:
>>>> From: Benjamin Szőke <egyszeregy@freemail.hu>
>>>>
>>>> Merge xt_*.h, ipt_*.h and ip6t_*.h header files, which has
>>>> same upper and lower case name format.
>>>>
>>>> Add #pragma message about recommended to use
>>>> header files with lower case format in the future.
>>>
>>> It looks like only patch 1/3 make it to the list.
>>>
>>> Also, with a patchset, please include a patch 0/X which gives the big
>>> picture of what the patchset does. The text will be used for the merge
>>> commit, so keep it formal. 'git format-patch --cover-letter' will
>>> create the empty 0/X patch you can edit, or if you are using b4 prep,
>>> you can use 'b4 prep --edit-cover' and then 'b4 send' will
>>> automatically generate and send it.
>>>
>>> https://docs.kernel.org/process/maintainer-netdev.html
>>> https://docs.kernel.org/process/submitting-patches.html
>>>
>>>      Andrew
>>
>> https://lore.kernel.org/lkml/20250105233157.6814-1-egyszeregy@freemail.hu/T/
>>
>> It is terribly chaotic how slowly start to appear the full patch list in the 
>> mailing list website. It's really time to replace 1990s dev technology with 
>> something like GitLab or GitHub developing style can provide in 2024.
> 
> No, it was your fault in the v5 series of your patches: you managed to send all 
> the patches in a single email instead of separated ones.

Something is not OK with your e-mail processing:

- 1. [PATCH v7 0/3] which is the cover letter, is appering really slowly in the 
list after [PATCH v7 1/3], [PATCH v7 2/3], [PATCH v7 3/3] were arrived. This is 
why I made v7 after v6, because after 10 minutes i still could not see that it 
is successfully arrived in the mailing list, I fustrated about it again went wrong.


- 2. Patch name visible is buggy:
[PATCH v7 0/3] netfilter: x_tables: Merge xt_*.c files
2025-01-05 23:31 UTC  (4+ messages)
[PATCH v7 1/3] netfilter: x_tables: Merge xt_*.h and ipt_*.h files which has 
same name
[PATCH v7 2/3] netfilter: x_tables: Merge xt_*.c "
[PATCH v7 3/3] netfilter: x_tables: Adjust code style for xt_*.h/c and ipt_*.h files

[PATCH v7 2/3] netfilter: x_tables: Merge xt_*.c " -> half of real name missing? 
Real name was: "Merge xt_*.c files which has same name."


> 
> Best regards,
> Jozsef

