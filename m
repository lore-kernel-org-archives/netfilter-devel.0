Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793781529;
	b=4rE/ZWuasHocKXBk89g/3DanhChJ0we8MXj/snlpsBOWbCKQU4OScg7j/+gsJ3IxIJSz
	 8GWc70f5OYx8PuORa1iX9GOIe03sSoIzdKn9W0wgZcfGHby+wsEbjX9JhpbBB3r1hAiI+
	 R5CXxcyW2TbAIPGyDDd0gv6dIe00ccWT1ExpUUGB8GUrIpzZksXWpoDH1tFPQ0xHHBB/N
	 ihO8vYJA0YybGB8vNaECMFdOT3x/lguy7kQ27/akcvMcPELsT9M5Bo+zGR8Wimbuhb96k
	 v4t6FGKGAq9/DWfeNPM5ranC56mvE21IYkXBGMns23e3Q+ona3UqQPOU9KHmmZtmdww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793781529;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:
	 X-Spamd-Result:X-Spam-Score;
	bh=fn9pOwl2J0XG5BgCYcngjb7A66uzF2y3ZoLghzGOkZA=;
	b=frw/2jRP+6bhW8uiAQ3ZQbPVqsqYBEjQPfmBPTIWH+AfLmFgFxid8GRUP5pV43jLUPxI
	 7EGdkXr02Vk7Q4HvyZ2Y+Fir8QJflu1bo3c6poCCKa4ceRKdcTuxpB5BnnI+jmpaGpnwy
	 4bNbs0zTVNsbXxUMXPR7At+c10bE2dNLu+ZRIKzkw4IFN+AycKmsJRCm7TULBk14bqN3m
	 cDISxxNLJlGE/KGdYSUScRgrXHMqDyqfltXpesqOOfUkUBw5SzGPhFR//yFejZonPgiSW
	 7y5XIFZYamG/cimeAoRu64541QXZdq7KjJsztgl4HADbn/3yZ5mtbG/l6gL99dPPQxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fA3O9gy4;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gFBk0IZx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fA3O9gy4;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gFBk0IZx;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7A3606A329;
	Wed,  4 Nov 2026 08:38:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B7A3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fA3O9gy4;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gFBk0IZx;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fA3O9gy4;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gFBk0IZx
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 476E02009B;
	Wed,  4 Nov 2026 08:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793781527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fn9pOwl2J0XG5BgCYcngjb7A66uzF2y3ZoLghzGOkZA=;
	b=fA3O9gy4OyDPyMVktW0BsXoQkkG8Ai0tQSL7cP1inKZRftggtBP7MlNcC4ja2mvjL8v9QK
	aqG0ZpzF3Y5K2Nn3gqqtiAE7AtaQt89X2AzicwKipGYF02r++U8PuzybIptC4JdsCvUHz+
	ROw6LIfzWHmC2noeLap+toYBI3Gl+gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793781527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fn9pOwl2J0XG5BgCYcngjb7A66uzF2y3ZoLghzGOkZA=;
	b=gFBk0IZxHinMUg91qFZV9JlDpfMF8eZdv2uNLvZXZs1e9BatBaO+XwNhIKFUz79BDkJcPM
	0gypWuzwiVk6mOCg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793781527; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fn9pOwl2J0XG5BgCYcngjb7A66uzF2y3ZoLghzGOkZA=;
	b=fA3O9gy4OyDPyMVktW0BsXoQkkG8Ai0tQSL7cP1inKZRftggtBP7MlNcC4ja2mvjL8v9QK
	aqG0ZpzF3Y5K2Nn3gqqtiAE7AtaQt89X2AzicwKipGYF02r++U8PuzybIptC4JdsCvUHz+
	ROw6LIfzWHmC2noeLap+toYBI3Gl+gY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793781527;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fn9pOwl2J0XG5BgCYcngjb7A66uzF2y3ZoLghzGOkZA=;
	b=gFBk0IZxHinMUg91qFZV9JlDpfMF8eZdv2uNLvZXZs1e9BatBaO+XwNhIKFUz79BDkJcPM
	0gypWuzwiVk6mOCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B41B134F0;
	Wed,  4 Nov 2026 08:38:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id A64HBRbv6mq1AgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 04 Nov 2026 08:38:46 +0000
Message-ID: <6abf56cc-d3df-4ca8-9f6d-fe9fa3462837@suse.de>
Date: Wed, 4 Nov 2026 09:37:22 +0100
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
Subject: Re: [PATCH nf-next] selftests: netfilter: nf_queue: drop the no-op
 loop initializer
To: Sasha Levin <sashal@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20261103165419.687806-1-sashal@kernel.org>
 <20261103165419.687806-5-sashal@kernel.org>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261103165419.687806-5-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-13.29 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -13.29

On 11/3/26 5:54 PM, Sasha Levin wrote:
> The out-of-order verdict loop starts with "for (ooo_count; ...", and
> clang warns about the unused expression:
> 
>    nf_queue.c:354:10: warning: expression result unused [-Wunused-value]
> 
> Leave the initializer empty.
> 
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> KernelCI's clang builds show this warning.
> 
>   tools/testing/selftests/net/netfilter/nf_queue.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
> index cca6c3cfa9e46..bc0b2f601a0a4 100644
> --- a/tools/testing/selftests/net/netfilter/nf_queue.c
> +++ b/tools/testing/selftests/net/netfilter/nf_queue.c
> @@ -351,7 +351,7 @@ static int mainloop(void)
>   		if (opts.out_of_order) {
>   			ooo_ids[ooo_count] = id;
>   			if (ooo_count >= 15) {
> -				for (ooo_count; ooo_count >= 0; ooo_count--) {
> +				for (; ooo_count >= 0; ooo_count--) {
>   					nlh = nfq_build_verdict(buf, ooo_ids[ooo_count],
>   								opts.queue_num, opts.verdict);
>   					if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
