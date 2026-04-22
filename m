Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9EC3C1969;
	Wed, 22 Apr 2026 09:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776849540; cv=none; b=t0rPs3TXkB/a6s3bgEG73zMI4Vn/H17RInZ5aFsi0sxCVKA2Duo9LwMUZo/Fid3xXYBgHj/H7JWK3PYLm8ttwKjkMXnt+6u4wNcAAIQ+YlIhJaO7gNNywidCj4k+SlzwqiwcGB0mlkXRLI1G23oLUpwaJU5NnoilFNYBAtmqnGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776849540; c=relaxed/simple;
	bh=BF1zEbvNk3kTqMH+V92H0EY8hWcWDUFqzNweMj+pj7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=phwp0oguyFN3NAYEeRLaN1Gmhk+WfYK0/izZG6K0s7qdRhaEXxOOggx5FpdNZmZc4Ilmnhu01+UUkCaaOgVd4NeBbU88wPuloVATn8vJoA7379Jsb3S3DVb4ahl/FosvjQDphPpYtmBPV8nMhhRudSaXRl9lWXk3lKg9GTeJqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=fGSIJcxd; arc=none smtp.client-ip=188.68.63.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="fGSIJcxd"
Received: from mors-relay-2501.netcup.net (localhost [127.0.0.1])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4g0tvG6VDdz66yb;
	Wed, 22 Apr 2026 11:18:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1776849530;
	bh=BF1zEbvNk3kTqMH+V92H0EY8hWcWDUFqzNweMj+pj7A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fGSIJcxdGOQA5EjsNjngXsYrBrHIYnfiyM09VQTkqbONmKhnu+o0E8P4794qF2oIW
	 jDB2jJByrZOupL+zxrxn41udM9fmHrVia11fwN4Jn4uwshQXu17eQy7AqqvxhQUlJL
	 mCHo93vzHC//z96gJacLP/wImyF2G/v6UWpHR0NnMZ5fZOLj48pX4CNBqyeyIo1W8J
	 7Qt1lcawvI2mar9ilBrYyrLjpQ1KJSMmwAZ3z2uRJQTtD+sYcon+qDPo6lPVn0q/4Q
	 cjKIR4N5VLPvucHEkqKubV6haAKepoPLRy6/5beAG95dLHuqV1m5T2zd1UC/jWGrMt
	 zhj7Dy//1f8jg==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4g0tvG5mVkz4xNb;
	Wed, 22 Apr 2026 11:18:50 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4g0tvF0Qv0z8sZP;
	Wed, 22 Apr 2026 11:18:48 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 8CF1E632A6;
	Wed, 22 Apr 2026 11:18:47 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <0b8607c8-2d29-4fca-961a-b7a677e968a1@leemhuis.info>
Date: Wed, 22 Apr 2026 11:18:47 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1130336: [regression] Network failure beyond first connection
 after 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was
 skipped")
To: Fernando Fernandez Mancera <fmancera@suse.de>,
 =?UTF-8?Q?Alejandro_Oliv=C3=A1n_Alvarez?=
 <alejandro.olivan.alvarez@gmail.com>,
 Salvatore Bonaccorso <carnil@debian.org>, 1130336@bugs.debian.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev, stable@vger.kernel.org
References: <177349610461.3071718.4083978280323144323@eldamar.lan>
 <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
 <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de> <abW2MAAqLnKZm3KF@strlen.de>
 <177322336258.4376.10097494324750307114.reportbug@Desk1.simalex.iccbroadcast.com>
 <4da571ab-fa1d-4ee6-b71c-24f4a28243ed@suse.de> <abqfSB0TUik1kRU4@eldamar.lan>
 <e24a281622cedf9e8f4dc93c961813aeb7b6ce4c.camel@gmail.com>
 <8788e351-553f-48da-a6e6-ce082adacb8d@suse.de>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <8788e351-553f-48da-a6e6-ce082adacb8d@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-PPP-Message-ID: <177684952826.1966882.4123776011656959757@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 8CF1E632A6
X-NC-CID: Fc5/BRl+Om7MAoRUqKOqqQj6z/ve4Im5YY7m19THIqIw/0EvzvA=

Lo! Top-posting on purpose to make this easy to process.

What happened to this regression? It looks a bit like things stalled and
fell through the cracks. Or Fernando, did you post a patch like you
mentioned? I looked for one referring the commit or the reporter, but
could not find anything -- but maybe I missed it.

Ciao, Thorsten

On 3/19/26 09:59, Fernando Fernandez Mancera wrote:
> On 3/19/26 9:44 AM, Alejandro Oliván Alvarez wrote:
>> Hi folks.
>>
>> On Wed, 2026-03-18 at 13:49 +0100, Salvatore Bonaccorso wrote:
>>> Hi Alejandro,
>>>
>>> On Sun, Mar 15, 2026 at 02:09:33AM +0100, Fernando Fernandez Mancera
>>> wrote:
>>>> On 3/14/26 8:25 PM, Florian Westphal wrote:
>>>>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>>>>> On 3/14/26 5:13 PM, Fernando Fernandez Mancera wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
>>>>>>>> Control: forwarded -1
>>>>>>>> https://lore.kernel.org/
>>>>>>>> regressions/177349610461.3071718.4083978280323144323@eldama
>>>>>>>> r.lan
>>>>>>>> Control: tags -1 + upstream
>>>>>>>>
>>>>>>>> Hi
>>>>>>>>
>>>>>>>> In Debian, in https://bugs.debian.org/1130336, Alejandro
>>>>>>>> reported that
>>>>>>>> after updates including 69894e5b4c5e ("netfilter:
>>>>>>>> nft_connlimit:
>>>>>>>> update the count if add was skipped"), when the following
>>>>>>>> rule is set
>>>>>>>>
>>>>>>>>       iptables -A INPUT -p tcp -m
>>>>>>>> connlimit --connlimit-above 111 -j
>>>>>>>> REJECT --reject-with tcp-reset
>>>>>>>>
>>>>>>>> connections get stuck accordingly, it can be easily
>>>>>>>> reproduced by:
>>>>>>>>
>>>>>>>> # iptables -A INPUT -p tcp -m connlimit
>>>>>>>> --connlimit-above 111 -j REJECT
>>>>>>>> --reject-with tcp-reset
>>>>>>>> # nft list ruleset
>>>>>>>> # Warning: table ip filter is managed by iptables-nft, do
>>>>>>>> not touch!
>>>>>>>> table ip filter {
>>>>>>>>            chain INPUT {
>>>>>>>>                    type filter hook input priority filter;
>>>>>>>> policy accept;
>>>>>>>>                    ip protocol tcp xt
>>>>>>>> match "connlimit" counter packets 0
>>>>>>>> bytes 0 reject with tcp reset
>>>>>>>>            }
>>>>>>>> }
>>>>>>>> # wget -O /dev/null
>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>> rc3.tar.gz
>>>>>>>> --2026-03-14 14:53:51--
>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>> rc3.tar.gz
>>>>>>>> Resolving git.kernel.org
>>>>>>>> (git.kernel.org)... 172.105.64.184,
>>>>>>>> 2a01:7e01:e001:937:0:1991:8:25
>>>>>>>> Connecting to git.kernel.org
>>>>>>>> (git.kernel.org)|172.105.64.184|:443...
>>>>>>>> connected.
>>>>>>>> HTTP request sent, awaiting response... 301 Moved
>>>>>>>> Permanently
>>>>>>>> Location:
>>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
>>>>>>>> linux.git/snapshot/linux-7.0-rc3.tar.gz
>>>>>>>> [following]
>>>>>>>> --2026-03-14 14:53:51--
>>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/ git/torvalds/l
>>>>>>>> inux.git/snapshot/linux-7.0-rc3.tar.gz
>>>>>>>> Reusing existing connection to git.kernel.org:443.
>>>>>>>> HTTP request sent, awaiting response... 200 OK
>>>>>>>> Length: unspecified [application/x-gzip]
>>>>>>>> Saving to: ‘/dev/null’
>>>>>>>>
>>>>>>>> /dev/null                         [
>>>>>>>> <=>                    ] 248.03M
>>>>>>>> 51.9MB/s    in 5.0s
>>>>>>>>
>>>>>>>> 2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved
>>>>>>>> [260080129]
>>>>>>>>
>>>>>>>> # wget -O /dev/null
>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>> rc3.tar.gz
>>>>>>>> --2026-03-14 14:53:58--
>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>> rc3.tar.gz
>>>>>>>> Resolving git.kernel.org
>>>>>>>> (git.kernel.org)... 172.105.64.184,
>>>>>>>> 2a01:7e01:e001:937:0:1991:8:25
>>>>>>>> Connecting to git.kernel.org
>>>>>>>> (git.kernel.org)|172.105.64.184|:443...
>>>>>>>> failed: Connection timed out.
>>>>>>>> Connecting to git.kernel.org
>>>>>>>> (git.kernel.org)|
>>>>>>>> 2a01:7e01:e001:937:0:1991:8:25|:443...
>>>>>>>> failed: Network is unreachable.
>>>>>>>>
>>>>>>>> Before the 69894e5b4c5e ("netfilter: nft_connlimit: update
>>>>>>>> the count
>>>>>>>> if add was skipped") commit this worked.
>>>>>>>>
>>>>>>>
>>>>>>> Thanks for the report. I have reproduced
>>>>>>> this on upstream kernel. I am working on it.
>>>>>>>
>>>>>>
>>>>>> This is what is happening:
>>>>>>
>>>>>> 1. The first connection is established and
>>>>>> tracked, all good. When it finishes, it goes to
>>>>>> TIME_WAIT state
>>>>>> 2. The second connection is established, ct is
>>>>>> confirmed since the beginning, skipping the
>>>>>> tracking and calling a GC.
>>>>>> 3. The previously tracked connection is cleaned
>>>>>> up during GC as TIME_WAIT is considered closed.
>>>>>
>>>>> This is stupid.  The fix is to add --syn or use
>>>>> OUTPUT.  Its not even clear to me what the user wants to achive
>>>>> with this rule.
>>>>>
>>>>
>>>> Yes, the ruleset shown does not make sense. Having said this, it
>>>> could
>>>> affect to a soft-limit scenario as the one described on the blamed
>>>> commit..
>>>
>>> Alejandro, can you describe what you would like to achieve with the
>>> specific rule?
>>>
>>> Regards,
>>> Salvatore
>>
>> The intended use of that rule was to prevent (limit) a single host from
>> establishing too many TCP connections to given host (Denial of
>> Service... particularly on streaming servers).
>>
>> I learnt about it in several IPtables guides/howtos (maaaany years
>> ago!), and never was an issue on itself.
>> Was it stupid? ... possibly... It 'seemed' to work, or, at least, when
>> checking iptables -L -v one could see packet counter for the rule
>> catching some traffic, without ever noticing it being troublesome, so,
>> at the very least it 'didn't hurt', and, since DoS ever happened over
>> the years...well, I tended to think it was indeed working the way I
>> read it did.
>>
>> Certainly, I never (the authors of those guides at their time indeed)
>> though about the possibility of just target the TCP syn.
>> I have given a try to adding the --syn option to the rule to see the
>> difference, and well, it is way less disruptive that way, but it still
>> breaks things (I saw postfix queues hanging, for instance).
>>
> 
> The current problem with the ruleset is that it mixes both, incoming and
> outgoing connections. This should probably use --syn flag so it targets
> connections established against your host only.
> 
> Anyway, I am sending a patch fixing this as it makes sense to do it IMO.
> We just want to understand what is the real use-case and how the ruleset
> can be improved.
> 
> In addition, I would recommend you to transition to nftables because it
> would be ideal for your use-case. With nftables it would be easy to
> combine this with sets and probably quota expression to limit the usage.
> 
> What is wrong with the current ruleset? (Even before the blammed
> commit), if you reach the connlimit limit **ALL** TCP connections will
> be rejected (including legit ones), I do not think that is what you want
> to achieve.
> 
> Thanks,
> Fernando.
> 
>> So, I have but screwed the idea of using connlimit anymore anyways.
>> Sorry for the noise. Lesson learned.
>>
>> Cheers!
> 
> 

