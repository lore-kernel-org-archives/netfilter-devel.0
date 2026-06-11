Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6955036E494
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Jun 2026 08:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781165770; cv=none; b=Tf63mPxOaEbuWOqGj1V5zWHNDKe19Y4yDum33biiPD7nk+0uDp1KeqJLL3J+yVgFOlKltaXR/IPu5RWpPLvQYKZifPx/54Oyd57eM1hW5xGfDxI+IRGinrESSip+2r51gPvwMx/ao5K5O7niWGREJhVQKJ0CREFLokgbH36qE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781165770; c=relaxed/simple;
	bh=GsAsWH7Obyh0geglZxdMwxsQoAaOAICrWVm/HuGFqXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m8PludFdYZQi5z+q4dA0O4Wlq3dG0wwd94gLAsFMDRlotJetMaP5524o0QN6FehheoPuxqBdpqiRORhnivMOaE9Fcvju73m3PJCp8YdjJ6LmIXE8JmTDB5q/nCIvZ6UXNNzQ5QpG/Ga9hFif4ikx18ceM5UeHHCjb88jU4/Th1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b3PCSOT+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I009MTCc; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b3PCSOT+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I009MTCc; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b3PCSOT+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I009MTCc";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b3PCSOT+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I009MTCc"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 890A5759C6;
	Thu, 11 Jun 2026 08:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781165767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/YB2hfZCVNELaWXKYsnHKv8h0J4pz/MGzEWfST5VSEc=;
	b=b3PCSOT+XQZcd+AS7CfXm/xYlEpTNp5kTWlC14T/PQans/tIknDT3+MqVpJuiCkKS+w8+t
	ICwE+w7RuKdlXe+irT9qpx1va0RV6x1gLoVph6pQ/T8cN2l3fp3MqGOlFy/fdNEyQTFAam
	Eyz5iA2Rz7q0zzoea/UFghc7tUYwZCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781165767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/YB2hfZCVNELaWXKYsnHKv8h0J4pz/MGzEWfST5VSEc=;
	b=I009MTCcDvYP/TVlr3fP+WG8Jj0k/HLlozFie54XadXQkCVZ4gyPP3Jn8NFrbdVle65oRv
	5YzL2urUTER7EpCA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781165767; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/YB2hfZCVNELaWXKYsnHKv8h0J4pz/MGzEWfST5VSEc=;
	b=b3PCSOT+XQZcd+AS7CfXm/xYlEpTNp5kTWlC14T/PQans/tIknDT3+MqVpJuiCkKS+w8+t
	ICwE+w7RuKdlXe+irT9qpx1va0RV6x1gLoVph6pQ/T8cN2l3fp3MqGOlFy/fdNEyQTFAam
	Eyz5iA2Rz7q0zzoea/UFghc7tUYwZCo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781165767;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/YB2hfZCVNELaWXKYsnHKv8h0J4pz/MGzEWfST5VSEc=;
	b=I009MTCcDvYP/TVlr3fP+WG8Jj0k/HLlozFie54XadXQkCVZ4gyPP3Jn8NFrbdVle65oRv
	5YzL2urUTER7EpCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53636779A7;
	Thu, 11 Jun 2026 08:16:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 02LYE8duKmrEXAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 11 Jun 2026 08:16:07 +0000
Message-ID: <7e1453b1-09bb-4590-8dda-ed0647e4da77@suse.de>
Date: Thu, 11 Jun 2026 10:15:53 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] netfilter: nft_synproxy: stop bypassing the
 priv->info snapshot
To: Runyu Xiao <runyu.xiao@seu.edu.cn>, pablo@netfilter.org, fw@strlen.de,
 netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org, phil@nwl.cc, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 ffmancera@riseup.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, jianhao.xu@seu.edu.cn
References: <20260611042120.1462249-1-runyu.xiao@seu.edu.cn>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260611042120.1462249-1-runyu.xiao@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 

On 6/11/26 6:21 AM, Runyu Xiao wrote:
> nft_synproxy_eval_v4() and nft_synproxy_eval_v6() already take a
> whole-object READ_ONCE() snapshot of the shared priv->info state before
> building the SYNACK reply, but nft_synproxy_tcp_options() still masks
> opts->options with priv->info.options from the live shared object.
> 
> When a named synproxy object is updated concurrently with SYN traffic,
> the eval path can then mix mss and timestamp handling from the local
> snapshot with an options mask taken from a newer configuration, so one
> SYNACK no longer reflects a coherent synproxy configuration.
> 
> Use info->options so nft_synproxy_tcp_options() stays on the same local
> snapshot that the eval path already copied from priv->info.
> 
> Fixes: ee394f96ad75 ("netfilter: nft_synproxy: add synproxy stateful object support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks!
