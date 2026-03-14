Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EF533C52E
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773504806; cv=none; b=SsNHnFOKjuKov3DigMwlD7BwSPEvuueJPq9++v+Jx6YS/L2OlEVlYt9IXpwvEbAXrDdv97/lAn9SRxb93dsPpihnXZxXmSuQJW4imso9i6wv7mWnrGItBMf7nhVJr6u1A0BodVozsAUnnOlRQqVa9mRAZjm7jdO8Pj/qXzJ8/hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773504806; c=relaxed/simple;
	bh=Mae2/w4abHA8kh6yARLjOYoztZzFL7n+8muNpidz7NQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PPToSIjJQYbW4/pI41dQ86/U9dX/xbTQUna8tIc8bUc9hDv1kTqO1xWSdZ4QLNf25EU2Fl3hXQqMBopDe5HPvPnmtgL5I5x4fu5jTw6t5sOdrFvDtoJeXTsEMs9NO1U1mLqO3eXuSxQpF5xqpAYksNi4PaiMNXVIb3nSTG5g2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D1mSdLJG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sqdqzD1W; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D1mSdLJG; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sqdqzD1W; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D1mSdLJG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sqdqzD1W";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D1mSdLJG";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sqdqzD1W"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9552C4D205;
	Sat, 14 Mar 2026 16:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773504803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SNJELziumJN+7WTPukQjXt809HE9JLgHCSJSSDmqMPE=;
	b=D1mSdLJGmdUy+fajfjONs9n+A6zwNw4jByeBDrlshJtYB8vqvYnPK8Y23IeRni8do4kE0C
	FlezAOH1d+TSzdcQiBcGbspqwycI0aoO0ey/WfQElVsg8GnCZ2mzeVwTsYh84o/0FLHfB+
	/AYl28d2M3FvGsdOcpkRLPkxJwhdzqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773504803;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SNJELziumJN+7WTPukQjXt809HE9JLgHCSJSSDmqMPE=;
	b=sqdqzD1WVnQoMhTrfUAveW9aXUjvvHY+MrT5wAYhELzU/ZrCVnpHnqKhgSJl6fYYsq7gxL
	+d7+zkSX2o9nMGAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=D1mSdLJG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sqdqzD1W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773504803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SNJELziumJN+7WTPukQjXt809HE9JLgHCSJSSDmqMPE=;
	b=D1mSdLJGmdUy+fajfjONs9n+A6zwNw4jByeBDrlshJtYB8vqvYnPK8Y23IeRni8do4kE0C
	FlezAOH1d+TSzdcQiBcGbspqwycI0aoO0ey/WfQElVsg8GnCZ2mzeVwTsYh84o/0FLHfB+
	/AYl28d2M3FvGsdOcpkRLPkxJwhdzqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773504803;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SNJELziumJN+7WTPukQjXt809HE9JLgHCSJSSDmqMPE=;
	b=sqdqzD1WVnQoMhTrfUAveW9aXUjvvHY+MrT5wAYhELzU/ZrCVnpHnqKhgSJl6fYYsq7gxL
	+d7+zkSX2o9nMGAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 985D842724;
	Sat, 14 Mar 2026 16:13:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5u6pISKJtWnAKAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 14 Mar 2026 16:13:22 +0000
Message-ID: <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
Date: Sat, 14 Mar 2026 17:13:14 +0100
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
To: Salvatore Bonaccorso <carnil@debian.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Cc: 1130336@bugs.debian.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
 stable@vger.kernel.org
References: <177349610461.3071718.4083978280323144323@eldamar.lan>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <177349610461.3071718.4083978280323144323@eldamar.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_TO(0.00)[debian.org,netfilter.org,strlen.de,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,gmail.com];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	TAGGED_RCPT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:32098, ipnet:2800::/6, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 9552C4D205

Hi,

On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
> Control: forwarded -1 https://lore.kernel.org/regressions/177349610461.3071718.4083978280323144323@eldamar.lan
> Control: tags -1 + upstream
> 
> Hi
> 
> In Debian, in https://bugs.debian.org/1130336, Alejandro reported that
> after updates including 69894e5b4c5e ("netfilter: nft_connlimit:
> update the count if add was skipped"), when the following rule is set
> 
> 	iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset
> 
> connections get stuck accordingly, it can be easily reproduced by:
> 
> # iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j REJECT --reject-with tcp-reset
> # nft list ruleset
> # Warning: table ip filter is managed by iptables-nft, do not touch!
> table ip filter {
>          chain INPUT {
>                  type filter hook input priority filter; policy accept;
>                  ip protocol tcp xt match "connlimit" counter packets 0 bytes 0 reject with tcp reset
>          }
> }
> # wget -O /dev/null https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
> --2026-03-14 14:53:51--  https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
> Resolving git.kernel.org (git.kernel.org)... 172.105.64.184, 2a01:7e01:e001:937:0:1991:8:25
> Connecting to git.kernel.org (git.kernel.org)|172.105.64.184|:443... connected.
> HTTP request sent, awaiting response... 301 Moved Permanently
> Location: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz [following]
> --2026-03-14 14:53:51--  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz
> Reusing existing connection to git.kernel.org:443.
> HTTP request sent, awaiting response... 200 OK
> Length: unspecified [application/x-gzip]
> Saving to: ‘/dev/null’
> 
> /dev/null                         [                         <=>                    ] 248.03M  51.9MB/s    in 5.0s
> 
> 2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved [260080129]
> 
> # wget -O /dev/null https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
> --2026-03-14 14:53:58--  https://git.kernel.org/torvalds/t/linux-7.0-rc3.tar.gz
> Resolving git.kernel.org (git.kernel.org)... 172.105.64.184, 2a01:7e01:e001:937:0:1991:8:25
> Connecting to git.kernel.org (git.kernel.org)|172.105.64.184|:443... failed: Connection timed out.
> Connecting to git.kernel.org (git.kernel.org)|2a01:7e01:e001:937:0:1991:8:25|:443... failed: Network is unreachable.
> 
> Before the 69894e5b4c5e ("netfilter: nft_connlimit: update the count
> if add was skipped") commit this worked.
> 

Thanks for the report. I have reproduced this on upstream kernel. I am 
working on it.

Thanks,
Fernando.

> #regzbot introduced: 69894e5b4c5e28cda5f32af33d4a92b7a4b93b0e
> #regzbot link: https://bugs.debian.org/1130336
> 
> Regards,
> Salvatore
> 

