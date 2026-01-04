Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73911211A09
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Jan 2026 15:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767539330; cv=none; b=Xe+hZVqknR/q7kAhGgPmY7Y/GzIOw39oq2wAcje4xl6o6P+Ml/72BiBthNHRUknXFSvXkAaVToK9ynmLe4xq8vtqIGLShNeriFXC5im3GAsKIWarSjXMZaZTYC5CVLPeSXf5J2aeN1JiZStZ144V2Xi6/7dq5jtju2F/sb4q+Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767539330; c=relaxed/simple;
	bh=2ytmY8WDAv7msd+5/X+R+vDldStOwDi2tc2kg4LNrDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S8nAfNG3RY8pZWEqXmjASa3Q4WSzk4NJZrgStz9cAjzucmg1RsTLUvSc/Js5M6dLtWA2k4mBI8mBqNqLzaSuimo2qPHklBEdU2iBBBM0yBVhObDKpGS666XfN8ZJotJpxydOIHIhm3QAK5QM/k8IPtwg1Slf4ju3bTguOu6eiBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IoWF1t73; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=sg2TKwIL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=TnwTOr1J; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bONho37o; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IoWF1t73";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="sg2TKwIL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="TnwTOr1J";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bONho37o"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E40DA5BCC2;
	Sun,  4 Jan 2026 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767539321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UeaNNK2EDaip86XtFRwZuPspC+jGXWJoSS2NPIrkj3M=;
	b=IoWF1t73agg8CbpC+vj7d4T30lE/RQpX85gotGkUD+8Kkq3VfhcChJ88N+aqqV0uX54ZdG
	hbBvsHkkAx5bWudUn+QlgXxr7eAdd7RAJAG0whslN1K9UIpbRPn0GcCmyd74Q+C8hOszbI
	tvexXMNUg0SMRj/1CxcMjRgfuuveeXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767539321;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UeaNNK2EDaip86XtFRwZuPspC+jGXWJoSS2NPIrkj3M=;
	b=sg2TKwILA6ZVDCeT3amLmrVzfMuiCAWLerQ+hO2bvaYCc3P/UrLwH7wL5wxa6PAMNk4JPz
	+QxniPlgkPvuSBBQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767539320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UeaNNK2EDaip86XtFRwZuPspC+jGXWJoSS2NPIrkj3M=;
	b=TnwTOr1JGnAt+FWfVeK3Uqs+Y9yoOi36ZiRutR7j+QZPa4AN+z4FsED0lkTLSrnAnCdDA7
	zusWS6n+9utshDLNK5gmI6di/EvQXpfYTFqR7nMjh3yiioC1ztKWIejaLF6OgDv79RTMmZ
	sG4zgccXOWk0zUv3O+bhTfM1JoQ8UTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767539320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UeaNNK2EDaip86XtFRwZuPspC+jGXWJoSS2NPIrkj3M=;
	b=bONho37o1V2PErI1a5u/0DxwGHkoobIZxowvBAxfQXZIYeTiENtbMbInpjJLYS9DgeSPo8
	Iv429di4y8l5idAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B2BD13735;
	Sun,  4 Jan 2026 15:08:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vPHHFniCWmkkBwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sun, 04 Jan 2026 15:08:40 +0000
Message-ID: <70d635b0-b5ca-44fe-90b1-da2303ff09ec@suse.de>
Date: Sun, 4 Jan 2026 16:08:34 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/6] netfilter: updates for net
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <20260102114128.7007-1-fw@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260102114128.7007-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.962];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid]

On 1/2/26 12:41 PM, Florian Westphal wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for *net*:
> 
> 1) Fix overlap detection for nf_tables with concatenated ranges.
>     There are cases where element could not be added due to a conflict
>     with existing range, while kernel reports success to userspace.
> 2) update selftest to cover this bug.
> 3) synproxy update path should use READ/WRITE once as we replace
>     config struct while packet path might read it in parallel.
>     This relies on said config struct to fit sizeof(long).
>     From Fernando Fernandez Mancera.
> 4) Don't return -EEXIST from xtables in module load path, a pending
>     patch to module infra will spot a warning if this happens.
>     From Daniel Gomez.
> 5) Fix a memory leak in nf_tables when chain hits 2**32 users
>     and rule is to be hw-offloaded, from Zilin Guan.
> 6) Avoid infinite list growth when insert rate is high in nf_conncount,
>     also from Fernando.

Hi Florian,

FWIW, infinite list growth is still possible when insert rate is high in 
nf_conncount as I noticed that the commit "netfilter: nf_conncount: 
increase the connection clean up limit to 64" was not included in the 
pull request.

It is not a big deal. I am fine delaying the fix but just wanted to clarify.

Thanks,
Fernando.


> Please, pull these changes from:
> The following changes since commit dbf8fe85a16a33d6b6bd01f2bc606fc017771465:
> 
>    Merge tag 'net-6.19-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2025-12-30 08:45:58 -0800)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-26-01-02
> 
> for you to fetch changes up to 7811ba452402d58628e68faedf38745b3d485e3c:
> 
>    netfilter: nf_conncount: update last_gc only when GC has been performed (2026-01-02 10:44:28 +0100)
> 
> ----------------------------------------------------------------
> netfilter pull request nf-26-01-02
> 
> ----------------------------------------------------------------
> Daniel Gomez (1):
>        netfilter: replace -EEXIST with -EBUSY
> 
> Fernando Fernandez Mancera (2):
>        netfilter: nft_synproxy: avoid possible data-race on update operation
>        netfilter: nf_conncount: update last_gc only when GC has been performed
> 
> Florian Westphal (2):
>        netfilter: nft_set_pipapo: fix range overlap detection
>        selftests: netfilter: nft_concat_range.sh: add check for overlap detection bug
> 
> Zilin Guan (1):
>        netfilter: nf_tables: fix memory leak in nf_tables_newrule()
> 
>   net/bridge/netfilter/ebtables.c                    |  2 +-
>   net/netfilter/nf_conncount.c                       |  2 +-
>   net/netfilter/nf_log.c                             |  4 +-
>   net/netfilter/nf_tables_api.c                      |  3 +-
>   net/netfilter/nft_set_pipapo.c                     |  4 +-
>   net/netfilter/nft_synproxy.c                       |  6 +--
>   net/netfilter/x_tables.c                           |  2 +-
>   .../selftests/net/netfilter/nft_concat_range.sh    | 45 +++++++++++++++++++++-
>   8 files changed, 56 insertions(+), 12 deletions(-)
> # WARNING: 0000-cover-letter.patch lacks signed-off-by tag!
> # WARNING: skip 0000-cover-letter.patch, no "Fixes" tag!
> # INFO: 0001-netfilter-nft_set_pipapo-fix-range-overlap-detection.patch fixes commit from v5.6~21^2~5^2~5
> # WARNING: skip 0002-selftests-netfilter-nft_concat_range.sh-add-check-fo.patch, no "Fixes" tag!
> # INFO: 0003-netfilter-nft_synproxy-avoid-possible-data-race-on-u.patch fixes commit from v5.4-rc1~131^2~26^2~23
> # WARNING: skip 0004-netfilter-replace-EEXIST-with-EBUSY.patch, no "Fixes" tag!
> # INFO: 0005-netfilter-nf_tables-fix-memory-leak-in-nf_tables_new.patch fixes commit from v6.5-rc2~22^2~39^2~5
> # INFO: 0006-netfilter-nf_conncount-update-last_gc-only-when-GC-h.patch fixes commit from v5.19-rc1~159^2~45^2~2
> 

