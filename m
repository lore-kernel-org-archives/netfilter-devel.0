Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3EA175A62
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 07:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788249314; cv=none; b=Pa4gcOWrsg5zjic3jjJe8c2Fl2TXOGEMqgVaC7J73VU0jwxSEJZP8B54jrhhXHNuR/mJEvMM5Mw95Gsbkyal+5vWJRwq70L7dPYPOCLq1i/0TKRl9Wp1C3YTIBpPJxYecxOZhkg/mmA2+5ynrOQE2VP7w6vCePYjlo/hoLgp2Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788249314; c=relaxed/simple;
	bh=QalSucg5gNjn3xbrobi5W0npUNneac13bfJmDZgtEMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0GlKaynVRa9qDpqmoQZDGVJy5p6Hqz81e9uahO3vRf/v5MnKE1H/8iYqAq48pLtfb+2Gc6JzxPPt6bP5oQnrSbnzaF0e378GFheZZj/euJ0hiJyxR316bf+iTddHlrcdzRO+qEvGKru8WbpnY5xEX9AmYaxRkqx+M0vmkqsDD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=aZ8z4ivS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W8Abu1yW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=W0sxOWTc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=8J7NQRNg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="aZ8z4ivS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W8Abu1yW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="W0sxOWTc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="8J7NQRNg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52E591FDD8;
	Tue,  1 Sep 2026 07:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788249306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kS3wNiJTsYHkuakJ5f1luPKPKo/jHUGcdVTS/7rkrzA=;
	b=aZ8z4ivS61WfAhGSkk0ofcjIOG7GPlrsKnlQ6Ft0cBglmjp4dws3xeITrmKuuUVOhP/37x
	Rd9Yv58+MOfOdSOfIYMu5AvmYJoBRpgd9+0o4VqNhW041vFmGXeCcRK8hqpwhssybM3asB
	K0TDKDRs+jXbbATOuYq2ic0TMwCehXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788249306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kS3wNiJTsYHkuakJ5f1luPKPKo/jHUGcdVTS/7rkrzA=;
	b=W8Abu1yWCCp8V7872tvq49YKcbyGKhzbY1ceClmtZZbcCibebT6rlwy8BzH3nLdZiw2DIu
	0SRJYXBzJ6J71bAw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1788249302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kS3wNiJTsYHkuakJ5f1luPKPKo/jHUGcdVTS/7rkrzA=;
	b=W0sxOWTcQS6MTQSXt5laB1F+cr0jco1AMnc3KlNtsJSHy126kzz6RQtJjf0Dd0AsEGYsLU
	1d74JaXdLdhTqSHItcemeaajDXWEkF/zBt4fm4EIF2ZQvlV+Q2za/xikmyGtn1J5IbDMon
	nVrwUcbvQ3AIT8ZnYCnt4z1cZmiRl5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1788249302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kS3wNiJTsYHkuakJ5f1luPKPKo/jHUGcdVTS/7rkrzA=;
	b=8J7NQRNgtgO61t+2MkUNt4PkidFfwFRBOgRXufnRkOrvvjPR3LkMdbLwpmCig6iKjT4D/k
	h4RvXXBfhuz2CjBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0950013515;
	Tue,  1 Sep 2026 07:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id miYQO9WElmoBYwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 01 Sep 2026 07:55:01 +0000
Message-ID: <2fa302ed-71bc-4136-8955-cddb234b5e24@suse.de>
Date: Tue, 1 Sep 2026 09:54:27 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [nft PATCH] tests: shell: Test odd netdev hook updates
To: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <20260827204255.274666-1-phil@nwl.cc>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260827204255.274666-1-phil@nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo,nwl.cc:email]

On 8/27/26 10:42 PM, Phil Sutter wrote:
> These should cover what Fernando fixes in his kernel patch "netfilter:
> nf_tables: fix device name and prefix match in hook lookup" as well as
> some bonus cases I came up with.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Thanks Phil! These tests cover a lot of different cases.

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

>   .../chains/netdev_chain_update_wildcard_hook  | 45 +++++++++++++++++++
>   .../testcases/flowtable/update_wildcard_hook  | 45 +++++++++++++++++++
>   2 files changed, 90 insertions(+)
>   create mode 100755 tests/shell/testcases/chains/netdev_chain_update_wildcard_hook
>   create mode 100755 tests/shell/testcases/flowtable/update_wildcard_hook
> 
> diff --git a/tests/shell/testcases/chains/netdev_chain_update_wildcard_hook b/tests/shell/testcases/chains/netdev_chain_update_wildcard_hook
> new file mode 100755
> index 0000000000000..1381f4be2a5f1
> --- /dev/null
> +++ b/tests/shell/testcases/chains/netdev_chain_update_wildcard_hook
> @@ -0,0 +1,45 @@
> +#!/bin/bash
> +
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ifname_based_hooks)
> +
> +RC=0
> +
> +die() {
> +	echo "FAIL: $@"
> +	((RC++))
> +	$NFT list ruleset
> +}
> +
> +$NFT add table netdev t || die "add table failed"
> +
> +do_chain() { # (cmd, devspec, thp)
> +	$NFT $1 chain netdev t c "{ $3 devices = { $2 }; }"
> +}
> +
> +thp='type filter hook ingress priority 0;'
> +
> +do_chain add foo* "$thp" || die "initial add chain failed"
> +do_chain create foo* "$thp" && die "duplicated create initial chain allowed"
> +do_chain add foo* || die "duplicated hook add failed"
> +
> +do_chain add "bar*, bar*" && die "duplicate wildcard add allowed"
> +do_chain add "bar, bar" && die "duplicate device add allowed"
> +
> +do_chain add foo && die "update with non-wildcard allowed"
> +do_chain add fo* && die "update with shorter wildcard allowed"
> +do_chain add fooo* && die "update with longer wildcard allowed"
> +
> +# add after testing delete in case deletion is allowed when it should not
> +
> +do_chain delete foo && die "delete non-wildcard hook allowed"
> +do_chain add foo* || die "duplicated hook add failed"
> +
> +do_chain delete fo* && die "delete shorter wildcard allowed"
> +do_chain add foo* || die "duplicated hook add failed"
> +
> +do_chain delete fooo* && die "delete longer wildcard allowed"
> +do_chain add foo* || die "duplicated hook add failed"
> +
> +do_chain delete foo* || die "delete initial chain hook failed"
> +
> +exit $RC
> diff --git a/tests/shell/testcases/flowtable/update_wildcard_hook b/tests/shell/testcases/flowtable/update_wildcard_hook
> new file mode 100755
> index 0000000000000..a67c8bffe0687
> --- /dev/null
> +++ b/tests/shell/testcases/flowtable/update_wildcard_hook
> @@ -0,0 +1,45 @@
> +#!/bin/bash
> +
> +# NFT_TEST_REQUIRES(NFT_TEST_HAVE_ifname_based_hooks)
> +
> +RC=0
> +
> +die() {
> +	echo "FAIL: $@"
> +	((RC++))
> +	$NFT list ruleset
> +}
> +
> +$NFT add table t || die "add table failed"
> +
> +do_ft() { # (cmd, devspec, thp)
> +	$NFT $1 flowtable t ft "{ $3 devices = { $2 }; }"
> +}
> +
> +thp='hook ingress priority 0;'
> +
> +do_ft add foo* "$thp" || die "initial add flowtable failed"
> +do_ft create foo* "$thp" && die "duplicated create initial flowtable allowed"
> +do_ft add foo* || die "duplicated hook add failed"
> +
> +do_ft add "bar*, bar*" && die "duplicate wildcard add allowed"
> +do_ft add "bar, bar" && die "duplicate device add allowed"
> +
> +do_ft add foo && die "update with non-wildcard allowed"
> +do_ft add fo* && die "update with shorter wildcard allowed"
> +do_ft add fooo* && die "update with longer wildcard allowed"
> +
> +# add after testing delete in case deletion is allowed when it should not
> +
> +do_ft delete foo && die "delete non-wildcard hook allowed"
> +do_ft add foo* || die "duplicated hook add failed"
> +
> +do_ft delete fo* && die "delete shorter wildcard allowed"
> +do_ft add foo* || die "duplicated hook add failed"
> +
> +do_ft delete fooo* && die "delete longer wildcard allowed"
> +do_ft add foo* || die "duplicated hook add failed"
> +
> +do_ft delete foo* || die "delete initial flowtable hook failed"
> +
> +exit $RC

