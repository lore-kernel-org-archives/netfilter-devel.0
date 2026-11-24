Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514982;
	b=Wi4lZr6+kJ4wifSQrRo0y7Y8Q6bIlY/l11eQ+FUsFCkdyGLTh+dRVFP/TQ/XaJF4Cyyz
	 Ooq8kbtuyHhtDgEBAC/sovM62rHjoseQ48kJPEelIOd3cc7cN2F5ny1QGfAU58K3Gv3tk
	 L8fgl2ZRDBMAg1jeZSnqEYuOhBH6s6yGynnSBnwD0mVby2p9gvlFdVDGPDRUTAdThwC/D
	 kbn78Iy7SclspTInwAmAaPwlLI14jNCCpgm1PHqnT6E2xFbNqWwPLSrwD0wNI0WQLRNR3
	 gJkW8nYUs4UecAGx4YEK/6YpL8s3Nx7LuhZv1Tqb195YnLozJP5hVY/7BvB8h2QDyYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514982;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=FoH+HnMKY1OyhcxViZQNcp66Y4tDpPSKEgZ8SD+Muo8=;
	b=DP1nnnlxg/PkgpY//+cxbyn5Tc/WgnswAtHlQZREsSg8yULVmaETJFa7JsKmqjqPEj6f
	 y/WnTiTPDMzXuXwt95yyzMwngGU11NQ6S4WLNBxkjrZi6Obj/uanmsl9UHgXGTGeBNhof
	 AbarT0cRZPKbOwmz7kg7FF6g5KPnH6KLjth2tYNo8xqlgPYCE1OajjtBCP4IbM6sfWlRN
	 36UfrK/AC9uTPCatbapZ3tK57dlFbTFkRwNpJivqja6sxi7Vc7TFCki+c5Qj/Sd4w1LWi
	 ldFB0QbGVQPcMKf4gqoPYOopfGrbXl5ngFZWi8MJfGDPaO2dTXmrXKu1gmpriFmkv0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fhP8ddEB;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="9Kr6M/Mc";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fhP8ddEB;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="9Kr6M/Mc";
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2BF606A31E;
	Tue, 24 Nov 2026 10:09:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F2BF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fhP8ddEB;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9Kr6M/Mc;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fhP8ddEB;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9Kr6M/Mc
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2B6291F388;
	Tue, 24 Nov 2026 10:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795514974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FoH+HnMKY1OyhcxViZQNcp66Y4tDpPSKEgZ8SD+Muo8=;
	b=fhP8ddEBhmpvsSVU29zqCyS7ocOLUWM/r3cqwbMCAa2oolWLNS2yHX3MaEh6m2tyfWIAge
	L9bGN0FH0+5yLsaf+OXTmJbRpJSiv7kkKfi7iQ0/qNgrnN9+CJyXh2AawAE4o+PpTrHys0
	qlazJz/764U5IAo53ndRN9isJZh7+uc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795514974;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FoH+HnMKY1OyhcxViZQNcp66Y4tDpPSKEgZ8SD+Muo8=;
	b=9Kr6M/Mc1uklFdTIVjQsf5tQ2M4if+BlMj1/GYZ1+lnJRBZiPzD7e6yhpsMp/ctmqvfqUc
	bEehWeG8IlUro3Cg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fhP8ddEB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9Kr6M/Mc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795514974; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FoH+HnMKY1OyhcxViZQNcp66Y4tDpPSKEgZ8SD+Muo8=;
	b=fhP8ddEBhmpvsSVU29zqCyS7ocOLUWM/r3cqwbMCAa2oolWLNS2yHX3MaEh6m2tyfWIAge
	L9bGN0FH0+5yLsaf+OXTmJbRpJSiv7kkKfi7iQ0/qNgrnN9+CJyXh2AawAE4o+PpTrHys0
	qlazJz/764U5IAo53ndRN9isJZh7+uc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795514974;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FoH+HnMKY1OyhcxViZQNcp66Y4tDpPSKEgZ8SD+Muo8=;
	b=9Kr6M/Mc1uklFdTIVjQsf5tQ2M4if+BlMj1/GYZ1+lnJRBZiPzD7e6yhpsMp/ctmqvfqUc
	bEehWeG8IlUro3Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 93E871339F;
	Tue, 24 Nov 2026 10:09:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gOqUGV1iBWsLcgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 24 Nov 2026 10:09:33 +0000
Message-ID: <79156f22-a378-487e-8a52-0013367ef293@suse.de>
Date: Tue, 24 Nov 2026 11:08:07 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: bpf: reject a repeated
 bpf_ct_set_nat_info()
To: Andrey Misiurov <amisiurov@cloudlinux.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org
References: <20261120171325.2721546-1-amisiurov@cloudlinux.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261120171325.2721546-1-amisiurov@cloudlinux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2B6291F388
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-13.50 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:dkim,suse.de:email]
X-Spam-Score: -13.50

On 11/20/26 6:13 PM, Andrey Misiurov wrote:
> bpf_ct_set_nat_info() checks the l3 protocol and the manip type and then
> calls nf_nat_setup_info(). It does not check whether NAT for that manip was
> already set up.
> 
> A BPF program holding an unconfirmed nf_conn___init can call it twice with
> the same manip. The first call sets IPS_SRC_NAT_DONE (or IPS_DST_NAT_DONE).
> On the second call nf_nat_setup_info() hits WARN_ON(nf_nat_initialized()):
> 
>    WARNING: CPU: 1 PID: 21673 at net/netfilter/nf_nat_core.c:674 nf_nat_setup_info+0x251/0x2b0 [nf_nat]
>    CPU: 1 PID: 21673 Comm: loader
>    RIP: 0010:nf_nat_setup_info+0x251/0x2b0 [nf_nat]
>    Call Trace:
>     bpf_ct_set_nat_info+0x81/0xb0 [nf_nat]
>     bpf_prog_e4b00ba35d2f7a6b_nf_skb_ct_nat_twice+0x110/0x13f
>     bpf_test_run+0x172/0x2e0
>     bpf_prog_test_run_skb+0x2e5/0x4f0
>     __sys_bpf+0x7f8/0xe90
>     __x64_sys_bpf+0x1a/0x30
>     do_syscall_64+0x5f/0xe0
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> With panic_on_warn this is a DoS.
> 
> Reject the call with -EEXIST when NAT for that manip is already initialised,
> before nf_nat_setup_info() is reached.
> 
> Fixes: 0fabd2aa199f ("net: netfilter: add bpf_ct_set_nat_info kfunc helper")
> Signed-off-by: Andrey Misiurov <amisiurov@cloudlinux.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
