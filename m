Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67C01B87C9
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Mar 2026 01:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773536987; cv=none; b=uXNBVhiwni5zP3AWOKHjdEkMuNRiZ9dX9B35NJOBDPbwSqSfLI8P1oTdbN7G2qxKfLD1050O4pA28gXjlBZu+W+Gwyukq+nzur1BIP1ngn2rtBZiwc3JuzFwdRndf+67BfjaXnvlMs4oX6xUUNqpcbmgL57CE5zKLDqgfLtfcS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773536987; c=relaxed/simple;
	bh=1cGHAp0+IA6rbxYKu7JtRhj9A+B91vWfhIrGduMl/Jc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S0dwzX84FKCHvu5Zgy/3udVaeRjZht+AZjRF/Za6FzwKsfCEfT+0SU2/Z1MiO7mZh2dY7T64nNEocOya9i5Ra5dgM+VOYn70udtbSu3M25TNb2o1lsrNmyYGvaS2srykPhmtz9toQaCawUCOGNo8aMdOhAT5WX4CSeYbP3bfXsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Z46vcah3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=u+hSqfIC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oZ5rmAoZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=RcbNkZ+W; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Z46vcah3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="u+hSqfIC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oZ5rmAoZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="RcbNkZ+W"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CC66F5BD58;
	Sun, 15 Mar 2026 01:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773536983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWs+ynpUqEagn7VJCLxWFEiWmU0H5pJ30kSA7AwSPHU=;
	b=Z46vcah3TCiF9OWpUTK3muXj9mSZZzY1HAj/GVa3xaVU4Y0AHbo8Lopq5cVnLoP7N63ptk
	9ONco9ka726VpM/eEBDgIixI60CxDu+UJFnsWtlcrJP8gNz9bkWdr7OHXpeNE5Kh4Ld3uY
	BDj0W7BC0LNKqR4VhQ4ovC2pAzRTZdc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773536983;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWs+ynpUqEagn7VJCLxWFEiWmU0H5pJ30kSA7AwSPHU=;
	b=u+hSqfICmwTKA1pqWylGTa4JsCibE93S1H0/ap+eCoBARCoMUriOn9OUSA1WSUo0ZbDji7
	A2O0EeFw3fJ6YZBw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oZ5rmAoZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=RcbNkZ+W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773536982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWs+ynpUqEagn7VJCLxWFEiWmU0H5pJ30kSA7AwSPHU=;
	b=oZ5rmAoZhHGKEmewKuYjmp2cMLsTV8bfhn/Rawg8OSAE7Xf8qOnmSSdi0R8WwTjV+Ipvqm
	FgCS0z40GVJCBalSc6R5WHAwTctE528fq+cXkkmDuunZmb33ZHTgKhbVxlYUt+w8iL9pBw
	ND9g2rFWOcfalYqcIXYJbPZDEKzOC5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773536982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EWs+ynpUqEagn7VJCLxWFEiWmU0H5pJ30kSA7AwSPHU=;
	b=RcbNkZ+WRRGDHVYxyHS5iTDS9ypKMQXhE5SCRdWWlFZzaBqg0jBjSFplL0MKZnvHdkDhtd
	iUe0HTZPDXvGg4CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C03B54273B;
	Sun, 15 Mar 2026 01:09:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ia7RKtUGtmlAMwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 15 Mar 2026 01:09:41 +0000
Message-ID: <4da571ab-fa1d-4ee6-b71c-24f4a28243ed@suse.de>
Date: Sun, 15 Mar 2026 02:09:33 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [regression] Network failure beyond first connection after
 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was
 skipped")
To: Florian Westphal <fw@strlen.de>
Cc: Salvatore Bonaccorso <carnil@debian.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>,
 Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>,
 1130336@bugs.debian.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
 stable@vger.kernel.org
References: <177349610461.3071718.4083978280323144323@eldamar.lan>
 <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
 <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de> <abW2MAAqLnKZm3KF@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <abW2MAAqLnKZm3KF@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[debian.org,netfilter.org,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,gmail.com,bugs.debian.org,vger.kernel.org,lists.linux.dev];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: CC66F5BD58

On 3/14/26 8:25 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 3/14/26 5:13 PM, Fernando Fernandez Mancera wrote:
>>> Hi,
>>>
>>> On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
>>>> Control: forwarded -1
>>>> https://lore.kernel.org/ regressions/177349610461.3071718.4083978280323144323@eldamar.lan
>>>> Control: tags -1 + upstream
>>>>
>>>> Hi
>>>>
>>>> In Debian, in https://bugs.debian.org/1130336, Alejandro reported that
>>>> after updates including 69894e5b4c5e ("netfilter: nft_connlimit:
>>>> update the count if add was skipped"), when the following rule is set
>>>>
>>>>      iptables -A INPUT -p tcp -m
>>>> connlimit --connlimit-above 111 -j
>>>> REJECT --reject-with tcp-reset
>>>>
>>>> connections get stuck accordingly, it can be easily reproduced by:
>>>>
>>>> # iptables -A INPUT -p tcp -m connlimit
>>>> --connlimit-above 111 -j REJECT
>>>> --reject-with tcp-reset
>>>> # nft list ruleset
>>>> # Warning: table ip filter is managed by iptables-nft, do not touch!
>>>> table ip filter {
>>>>           chain INPUT {
>>>>                   type filter hook input priority filter; policy accept;
>>>>                   ip protocol tcp xt
>>>> match "connlimit" counter packets 0
>>>> bytes 0 reject with tcp reset
>>>>           }
>>>> }
>>>> # wget -O /dev/null
>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>> rc3.tar.gz
>>>> --2026-03-14 14:53:51--
>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>> rc3.tar.gz
>>>> Resolving git.kernel.org
>>>> (git.kernel.org)... 172.105.64.184,
>>>> 2a01:7e01:e001:937:0:1991:8:25
>>>> Connecting to git.kernel.org
>>>> (git.kernel.org)|172.105.64.184|:443...
>>>> connected.
>>>> HTTP request sent, awaiting response... 301 Moved Permanently
>>>> Location: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/
>>>> linux.git/snapshot/linux-7.0-rc3.tar.gz
>>>> [following]
>>>> --2026-03-14 14:53:51--
>>>> https://git.kernel.org/pub/scm/linux/kernel/ git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz
>>>> Reusing existing connection to git.kernel.org:443.
>>>> HTTP request sent, awaiting response... 200 OK
>>>> Length: unspecified [application/x-gzip]
>>>> Saving to: ‘/dev/null’
>>>>
>>>> /dev/null                         [
>>>> <=>                    ] 248.03M
>>>> 51.9MB/s    in 5.0s
>>>>
>>>> 2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved [260080129]
>>>>
>>>> # wget -O /dev/null
>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>> rc3.tar.gz
>>>> --2026-03-14 14:53:58--
>>>> https://git.kernel.org/torvalds/t/linux-7.0-
>>>> rc3.tar.gz
>>>> Resolving git.kernel.org
>>>> (git.kernel.org)... 172.105.64.184,
>>>> 2a01:7e01:e001:937:0:1991:8:25
>>>> Connecting to git.kernel.org
>>>> (git.kernel.org)|172.105.64.184|:443...
>>>> failed: Connection timed out.
>>>> Connecting to git.kernel.org
>>>> (git.kernel.org)|
>>>> 2a01:7e01:e001:937:0:1991:8:25|:443...
>>>> failed: Network is unreachable.
>>>>
>>>> Before the 69894e5b4c5e ("netfilter: nft_connlimit: update the count
>>>> if add was skipped") commit this worked.
>>>>
>>>
>>> Thanks for the report. I have reproduced
>>> this on upstream kernel. I am working on it.
>>>
>>
>> This is what is happening:
>>
>> 1. The first connection is established and
>> tracked, all good. When it finishes, it goes to
>> TIME_WAIT state
>> 2. The second connection is established, ct is
>> confirmed since the beginning, skipping the
>> tracking and calling a GC.
>> 3. The previously tracked connection is cleaned
>> up during GC as TIME_WAIT is considered closed.
> 
> This is stupid.  The fix is to add --syn or use
> OUTPUT.  Its not even clear to me what the user wants to achive with this rule.
> 

Yes, the ruleset shown does not make sense. Having said this, it could 
affect to a soft-limit scenario as the one described on the blamed commit..

xt_connlimit was designed with --syn on mind but it was not enforced and 
people used it for many different things. At least, we are learning many 
people ignored --syn completely.

>> +static inline bool tcp_syn_sent_or_recv(const struct nf_conn *conn)
>> +{
>> +	if (nf_ct_protonum(conn) == IPPROTO_TCP)
>> +		return conn->proto.tcp.state == TCP_CONNTRACK_SYN_SENT ||
>> +		       conn->proto.tcp.state == TCP_CONNTRACK_SYN_RECV;
>> +	else
>> +		return false;
>> +}
> 
> We're adding ever more complex checks in the conncount backend.
> I don't like any of the solutions.
> 

As we are already fetching the ct.. would it be fine if instead we go 
for a protocol agnostic solution with:

if (ctinfo == IP_CT_NEW)
	goto check_connections;

inside the confirmed if statement? If I am not wrong, it should be a 
valid solution too and IMHO a better one.

> What about reverting the offending commit, at least for tree_count?
> That way it continues to work as it did in the past.
> 

Before the fix, soft-limiting scenarios were broken and therefore this 
specific ruleset was too. I hope this is not a ruleset in production and 
it is just for reproducing the issue.

P.S: I have been investigating on a way to improve conncount backend 
structure so the GC is not that expensive.. I don't have anything 
relevant yet but I plan to provide some updates.
