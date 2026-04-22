Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2ED3A5E90
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Apr 2026 10:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776853959; cv=none; b=FbxcwkNi+thuLUk2B0AO3YCD/uVyDrBS3ytfJV/ePFoYk4uy9eGozEr3r+LQ2KpKQlpTEOBTwQ8a3IgPu8JFV8/5HHy977ov8eAMqq+EAvvpxGAtuTomGURXiJdcWPpLoDcRAT1iY8utJ86/7NAt0y2L+vg1pe+gcrddDRpLPo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776853959; c=relaxed/simple;
	bh=ftRsGwbBlXG7HcFqgFKI7EuKypI1HTPKPs5lzguV42A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDQmPs+s4nY61F3ojYfoab4VzegVdfC25+ikeIrZK7tPU2V8HpPxR6iFDFeyMO0cZVnrukG5pRDBnl/UNZquFLgfam3xJ1dXiuY/DKmRmssBYmKgWseJ84BHnhJoG8YRNucw3OkR0RyrMYuoCqKq87eGt+kJc+u5jS4WiYtZbW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UEvTgWhL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vQw3/1bB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UEvTgWhL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vQw3/1bB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UEvTgWhL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vQw3/1bB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UEvTgWhL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vQw3/1bB"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 511C05BCC6;
	Wed, 22 Apr 2026 10:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776853956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=geV2Y7KD8rYaVnkoozVtIqkBqooK12/gV2sn3Od+HHI=;
	b=UEvTgWhLaRsV1pncheyz7SidQnKJcLb3KBUOPTEYUYfiuQMem9ra6GYwtXsrPrUN0kV+3r
	mxhD0U6+a7c+hMbA4eV+E3bObpGB7KSS+CoXK+uk7hj0toGluH4r33wEAwITu3d7PZ1gSF
	QKqvK1Rtd7IKIpuP8p+mldx9Kea9zCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776853956;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=geV2Y7KD8rYaVnkoozVtIqkBqooK12/gV2sn3Od+HHI=;
	b=vQw3/1bB094z91bzpC4wdAamqcU30XlX7zEL45SeIHZi8Yd3kEf/JF1WHzuVC2uUzI0+Ve
	9BGJuCkic6KRAwDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UEvTgWhL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="vQw3/1bB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776853956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=geV2Y7KD8rYaVnkoozVtIqkBqooK12/gV2sn3Od+HHI=;
	b=UEvTgWhLaRsV1pncheyz7SidQnKJcLb3KBUOPTEYUYfiuQMem9ra6GYwtXsrPrUN0kV+3r
	mxhD0U6+a7c+hMbA4eV+E3bObpGB7KSS+CoXK+uk7hj0toGluH4r33wEAwITu3d7PZ1gSF
	QKqvK1Rtd7IKIpuP8p+mldx9Kea9zCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776853956;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=geV2Y7KD8rYaVnkoozVtIqkBqooK12/gV2sn3Od+HHI=;
	b=vQw3/1bB094z91bzpC4wdAamqcU30XlX7zEL45SeIHZi8Yd3kEf/JF1WHzuVC2uUzI0+Ve
	9BGJuCkic6KRAwDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 46CC6593AF;
	Wed, 22 Apr 2026 10:32:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yn6wDMOj6GmUdgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 22 Apr 2026 10:32:35 +0000
Message-ID: <f67a985f-c6a0-4796-b255-59d99e317b6f@suse.de>
Date: Wed, 22 Apr 2026 12:32:34 +0200
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
To: Thorsten Leemhuis <regressions@leemhuis.info>,
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
 <0b8607c8-2d29-4fca-961a-b7a677e968a1@leemhuis.info>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <0b8607c8-2d29-4fca-961a-b7a677e968a1@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[leemhuis.info,gmail.com,debian.org,bugs.debian.org];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MID_RHS_MATCH_FROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim,suse.de:mid,suse.de:email]
X-Rspamd-Queue-Id: 511C05BCC6
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

On 4/22/26 11:18 AM, Thorsten Leemhuis wrote:
> Lo! Top-posting on purpose to make this easy to process.
> 
> What happened to this regression? It looks a bit like things stalled and
> fell through the cracks. Or Fernando, did you post a patch like you
> mentioned? I looked for one referring the commit or the reporter, but
> could not find anything -- but maybe I missed it.
> 

Yes, it stalled and fell through the cracks. Let me prepare a fix as I 
mentioned.

Thanks for the reminder Thorsten!

> Ciao, Thorsten
> 
> On 3/19/26 09:59, Fernando Fernandez Mancera wrote:
>> On 3/19/26 9:44 AM, Alejandro Oliván Alvarez wrote:
>>> Hi folks.
>>>
>>> On Wed, 2026-03-18 at 13:49 +0100, Salvatore Bonaccorso wrote:
>>>> Hi Alejandro,
>>>>
>>>> On Sun, Mar 15, 2026 at 02:09:33AM +0100, Fernando Fernandez Mancera
>>>> wrote:
>>>>> On 3/14/26 8:25 PM, Florian Westphal wrote:
>>>>>> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>>>>>>> On 3/14/26 5:13 PM, Fernando Fernandez Mancera wrote:
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
>>>>>>>>> Control: forwarded -1
>>>>>>>>> https://lore.kernel.org/
>>>>>>>>> regressions/177349610461.3071718.4083978280323144323@eldama
>>>>>>>>> r.lan
>>>>>>>>> Control: tags -1 + upstream
>>>>>>>>>
>>>>>>>>> Hi
>>>>>>>>>
>>>>>>>>> In Debian, in https://bugs.debian.org/1130336, Alejandro
>>>>>>>>> reported that
>>>>>>>>> after updates including 69894e5b4c5e ("netfilter:
>>>>>>>>> nft_connlimit:
>>>>>>>>> update the count if add was skipped"), when the following
>>>>>>>>> rule is set
>>>>>>>>>
>>>>>>>>>        iptables -A INPUT -p tcp -m
>>>>>>>>> connlimit --connlimit-above 111 -j
>>>>>>>>> REJECT --reject-with tcp-reset
>>>>>>>>>
>>>>>>>>> connections get stuck accordingly, it can be easily
>>>>>>>>> reproduced by:
>>>>>>>>>
>>>>>>>>> # iptables -A INPUT -p tcp -m connlimit
>>>>>>>>> --connlimit-above 111 -j REJECT
>>>>>>>>> --reject-with tcp-reset
>>>>>>>>> # nft list ruleset
>>>>>>>>> # Warning: table ip filter is managed by iptables-nft, do
>>>>>>>>> not touch!
>>>>>>>>> table ip filter {
>>>>>>>>>             chain INPUT {
>>>>>>>>>                     type filter hook input priority filter;
>>>>>>>>> policy accept;
>>>>>>>>>                     ip protocol tcp xt
>>>>>>>>> match "connlimit" counter packets 0
>>>>>>>>> bytes 0 reject with tcp reset
>>>>>>>>>             }
>>>>>>>>> }
>>>>>>>>> # wget -O /dev/null
>>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>>> rc3.tar.gz
>>>>>>>>> --2026-03-14 14:53:51--
>>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>>> rc3.tar.gz
>>>>>>>>> Resolving git.kernel.org
>>>>>>>>> (git.kernel.org)... 172.105.64.184,
>>>>>>>>> 2a01:7e01:e001:937:0:1991:8:25
>>>>>>>>> Connecting to git.kernel.org
>>>>>>>>> (git.kernel.org)|172.105.64.184|:443...
>>>>>>>>> connected.
>>>>>>>>> HTTP request sent, awaiting response... 301 Moved
>>>>>>>>> Permanently
>>>>>>>>> Location:
>>>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
>>>>>>>>> linux.git/snapshot/linux-7.0-rc3.tar.gz
>>>>>>>>> [following]
>>>>>>>>> --2026-03-14 14:53:51--
>>>>>>>>> https://git.kernel.org/pub/scm/linux/kernel/ git/torvalds/l
>>>>>>>>> inux.git/snapshot/linux-7.0-rc3.tar.gz
>>>>>>>>> Reusing existing connection to git.kernel.org:443.
>>>>>>>>> HTTP request sent, awaiting response... 200 OK
>>>>>>>>> Length: unspecified [application/x-gzip]
>>>>>>>>> Saving to: ‘/dev/null’
>>>>>>>>>
>>>>>>>>> /dev/null                         [
>>>>>>>>> <=>                    ] 248.03M
>>>>>>>>> 51.9MB/s    in 5.0s
>>>>>>>>>
>>>>>>>>> 2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved
>>>>>>>>> [260080129]
>>>>>>>>>
>>>>>>>>> # wget -O /dev/null
>>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>>> rc3.tar.gz
>>>>>>>>> --2026-03-14 14:53:58--
>>>>>>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>>>>>>> rc3.tar.gz
>>>>>>>>> Resolving git.kernel.org
>>>>>>>>> (git.kernel.org)... 172.105.64.184,
>>>>>>>>> 2a01:7e01:e001:937:0:1991:8:25
>>>>>>>>> Connecting to git.kernel.org
>>>>>>>>> (git.kernel.org)|172.105.64.184|:443...
>>>>>>>>> failed: Connection timed out.
>>>>>>>>> Connecting to git.kernel.org
>>>>>>>>> (git.kernel.org)|
>>>>>>>>> 2a01:7e01:e001:937:0:1991:8:25|:443...
>>>>>>>>> failed: Network is unreachable.
>>>>>>>>>
>>>>>>>>> Before the 69894e5b4c5e ("netfilter: nft_connlimit: update
>>>>>>>>> the count
>>>>>>>>> if add was skipped") commit this worked.
>>>>>>>>>
>>>>>>>>
>>>>>>>> Thanks for the report. I have reproduced
>>>>>>>> this on upstream kernel. I am working on it.
>>>>>>>>
>>>>>>>
>>>>>>> This is what is happening:
>>>>>>>
>>>>>>> 1. The first connection is established and
>>>>>>> tracked, all good. When it finishes, it goes to
>>>>>>> TIME_WAIT state
>>>>>>> 2. The second connection is established, ct is
>>>>>>> confirmed since the beginning, skipping the
>>>>>>> tracking and calling a GC.
>>>>>>> 3. The previously tracked connection is cleaned
>>>>>>> up during GC as TIME_WAIT is considered closed.
>>>>>>
>>>>>> This is stupid.  The fix is to add --syn or use
>>>>>> OUTPUT.  Its not even clear to me what the user wants to achive
>>>>>> with this rule.
>>>>>>
>>>>>
>>>>> Yes, the ruleset shown does not make sense. Having said this, it
>>>>> could
>>>>> affect to a soft-limit scenario as the one described on the blamed
>>>>> commit..
>>>>
>>>> Alejandro, can you describe what you would like to achieve with the
>>>> specific rule?
>>>>
>>>> Regards,
>>>> Salvatore
>>>
>>> The intended use of that rule was to prevent (limit) a single host from
>>> establishing too many TCP connections to given host (Denial of
>>> Service... particularly on streaming servers).
>>>
>>> I learnt about it in several IPtables guides/howtos (maaaany years
>>> ago!), and never was an issue on itself.
>>> Was it stupid? ... possibly... It 'seemed' to work, or, at least, when
>>> checking iptables -L -v one could see packet counter for the rule
>>> catching some traffic, without ever noticing it being troublesome, so,
>>> at the very least it 'didn't hurt', and, since DoS ever happened over
>>> the years...well, I tended to think it was indeed working the way I
>>> read it did.
>>>
>>> Certainly, I never (the authors of those guides at their time indeed)
>>> though about the possibility of just target the TCP syn.
>>> I have given a try to adding the --syn option to the rule to see the
>>> difference, and well, it is way less disruptive that way, but it still
>>> breaks things (I saw postfix queues hanging, for instance).
>>>
>>
>> The current problem with the ruleset is that it mixes both, incoming and
>> outgoing connections. This should probably use --syn flag so it targets
>> connections established against your host only.
>>
>> Anyway, I am sending a patch fixing this as it makes sense to do it IMO.
>> We just want to understand what is the real use-case and how the ruleset
>> can be improved.
>>
>> In addition, I would recommend you to transition to nftables because it
>> would be ideal for your use-case. With nftables it would be easy to
>> combine this with sets and probably quota expression to limit the usage.
>>
>> What is wrong with the current ruleset? (Even before the blammed
>> commit), if you reach the connlimit limit **ALL** TCP connections will
>> be rejected (including legit ones), I do not think that is what you want
>> to achieve.
>>
>> Thanks,
>> Fernando.
>>
>>> So, I have but screwed the idea of using connlimit anymore anyways.
>>> Sorry for the noise. Lesson learned.
>>>
>>> Cheers!
>>
>>
> 
> 

