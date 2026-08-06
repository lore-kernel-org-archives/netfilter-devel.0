Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE83841D626;
	Thu,  6 Aug 2026 08:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786005937; cv=none; b=KQyiUofFbP+Z36r79gFiujt+MRv1vn4OMbiOLgvQJ1fK7XZXCeheihldzxUivDuTa3ry47zyDlNuDXn3dADwL4GpVKd3cQ5R9E5k4R8Tfm2dHIt9kfzOQZhpgihaqm/merFqB++wcbzmbcpQXgpCqqOMUvhDeJ0/cSlZo08t+E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786005937; c=relaxed/simple;
	bh=tQOGWflLxgUlJiz0YryMhWdMd5Sc9MHtenKd52ltzzc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OB/onFBBpn25FfW8Rx7+FMzbxyT+RrhrXTVK8UcfjsNYDjZGRWcADnAeBAEYUkdChCBhJUTX+LRsbYeO5XZNqNRQeEYnQR8ZR/ybTaUdHWilGeWz0/YecTNgjeND6IIFHvyGHWXX8W/usNykfu8+A9pXqsXQra1zq04ccUt8HqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KhNCGvV3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=LzMNa21Q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=r+Zz4bJ5; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Fn14qJ4O; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KhNCGvV3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="LzMNa21Q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="r+Zz4bJ5";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Fn14qJ4O"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 59F387FF47;
	Thu,  6 Aug 2026 08:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786005929; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjRNSC6HwrsT5cr6zNghK1KCOASTQbMMQP6CzvGJHPE=;
	b=KhNCGvV30uDGfuv0mBxpkcNtJRuib1G1AIZEinlV5c+2UPuTBNODyv8sGeAdhvzB9SdkS8
	zw4Rsm5z4/1fhFNrAWvbcYCZDHJD5tnY4Rbu5GJH8atbeFY/IqDra22aqqUXRb8572b0/q
	eQY+otRYnJ96TwLkDEq94slU82xeW+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786005929;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjRNSC6HwrsT5cr6zNghK1KCOASTQbMMQP6CzvGJHPE=;
	b=LzMNa21Q+WmTW3YlKZ8BMvKdCK1BHjIXeKPzfHcyi8vslUhAYn5ca/KclcqsDUPdp/StEk
	XnzohW2yY4xKQ9Dg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r+Zz4bJ5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fn14qJ4O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786005925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjRNSC6HwrsT5cr6zNghK1KCOASTQbMMQP6CzvGJHPE=;
	b=r+Zz4bJ57b2hmXhgnECwSdxpl8TV8yykfAVsv53UiyYpe0MVBH7HKFhQNPlhukIEjWN5zZ
	x2w2N7vOs+5mTFW3k1FhFEKwPyYNwWicVK6n29K3hGxfgsZKUSnvbR7uV7n/p+5Oznu+mW
	yN6nc0cZFIvvBeUhyktMCf3yUmWfInc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786005925;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GjRNSC6HwrsT5cr6zNghK1KCOASTQbMMQP6CzvGJHPE=;
	b=Fn14qJ4O/Yq1pM33Ps/mgiYPiRX+Wl+sPn9CWTFNfuo/gBDErCgbTprEiIGLnp8jwnW09e
	9d6qsM7HavA6bDBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8C974779B6;
	Thu,  6 Aug 2026 08:45:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eASGH6RJdGorfgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 06 Aug 2026 08:45:24 +0000
Message-ID: <824bc2e7-5ee7-441b-949d-817817f32fd0@suse.de>
Date: Thu, 6 Aug 2026 10:45:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: netfilter: Remove unused variables in
 conntrack_dump_flush
To: Qingshuang Fu <fffsqian@163.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, davem@davemloft.net,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
References: <20260806075052.1934904-1-fffsqian@163.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20260806075052.1934904-1-fffsqian@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_TO(0.00)[163.com,netfilter.org,strlen.de,davemloft.net,google.com,kernel.org,redhat.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[163.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,kylinos.cn:email];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Queue-Id: 59F387FF47
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action

On 8/6/26 9:50 AM, Qingshuang Fu wrote:
> From: Qingshuang Fu <fuqingshuang@kylinos.cn>
> 
> The variables 'rplnlh' in conntrack_data_insert() and 'rplnlh' together
> with 'nest' in conntracK_count_zone() and conntrack_flush_zone() were
> declared but never used since they were introduced.
> 
> Similarly, commit 76342e842587 ("selftests: netfilter: remove unused
> parameter") removed the unused 'err' variable from these functions but
> overlooked the remaining unused 'rplnlh' and 'nest' variables.  Remove
> them to clean up the code.
> 
> Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")
> Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
> ---

Thanks for patch, it looks good to me but could we avoid the fixes tag here?

Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
