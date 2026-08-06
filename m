Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3E530FF08;
	Thu,  6 Aug 2026 09:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007063; cv=none; b=ey2393YqGVP9uv5ue0rTF+cYCrRX84puVXYJwRBLWA9kLAYOxK1vqAYFbLqOcQIkKbnMHJ9bnCdYa3/cnVveeaaW0CSPa5Jt+JdZ+KL3I0sF5emkrFjOBMBoi11t7moPgOjY11ZeyByxxrDsspGocOESNJh93EUj4H8tMJy++ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007063; c=relaxed/simple;
	bh=B8/69GPoQft63t6vKlmcovoad80jxzWLlb9yEv7T9EA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=OA/uvEaAscChgmDKQZJK/slV4WDpo0OrSnDf0f9FyuXMSsoAhvDAf8cJw1fXlJVyMZ0fHTgYYL0fLvN6paazCfxTMXVUP0N36XKrTwn885QlK/yjgUgvVr8ql9d2+KXknoCy9y6+kZbE0v6VaIs8AurQOTkoleT0K75ffGoaWFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nh9PJo5o; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=7kp901Ur; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=BMg3Ql8P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HQLL07cb; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nh9PJo5o";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="7kp901Ur";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="BMg3Ql8P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HQLL07cb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A34C3E06;
	Thu,  6 Aug 2026 09:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786007056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DGKz2qvrhIfucCzgjxp4vh+wLFIgfMjvUPxJjhY5uTE=;
	b=nh9PJo5o72OxkQ9un2g4QDr+IH1NwGWzZfDkawZbyKtI7IPjm9rwjifKy5fTtNOWtxE7iI
	wzGaz9+SlV4BVGovqo1UcfcFApHnjoF/GvGudPfQ+/+pdRLvhrpiQJk/Yi8M5Nl4egI1/R
	tF5uY8dg9yOVVQqtCC4FNALjVJkUVqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786007056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DGKz2qvrhIfucCzgjxp4vh+wLFIgfMjvUPxJjhY5uTE=;
	b=7kp901UrG6p3eGeAJTLSYehdICbVGCjWTVWTuQJycaYvSXSwTkSb/p9em1Eg2KEfYEVEYW
	EU1McX+E8u45R5Dg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BMg3Ql8P;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HQLL07cb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786007052; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DGKz2qvrhIfucCzgjxp4vh+wLFIgfMjvUPxJjhY5uTE=;
	b=BMg3Ql8PrACdUEHQ4Cmq/m01lcTz26vwsaQtFXA2/FOzgI6s2Fg2ygyUj6mFOmEdKYych6
	KNo9R6GL3G95KnxehoFS9yorjySBJ2MFalrPJyRxPVuIche/ObljIAU6siiRe/hXtjMM1S
	MnFZ8tT4lwpCdDI5kWCYOnEsh5B42Ho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786007052;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DGKz2qvrhIfucCzgjxp4vh+wLFIgfMjvUPxJjhY5uTE=;
	b=HQLL07cbuvXZsf1Dl0SwWZdTwt3kJkU+vH1/BR30s27rNuuvCp1nNsFm1jitA7XDaHHtqN
	zdtN/57EprDXu8BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50382779B6;
	Thu,  6 Aug 2026 09:04:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pkKaEAtOdGpHEwAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 06 Aug 2026 09:04:11 +0000
Message-ID: <a0c1a965-37d6-4cb9-b21a-1afc3b162e03@suse.de>
Date: Thu, 6 Aug 2026 11:03:57 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: netfilter: Remove unused variables in
 conntrack_dump_flush
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: Qingshuang Fu <fffsqian@163.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, davem@davemloft.net,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
References: <20260806075052.1934904-1-fffsqian@163.com>
 <824bc2e7-5ee7-441b-949d-817817f32fd0@suse.de>
Content-Language: en-US
In-Reply-To: <824bc2e7-5ee7-441b-949d-817817f32fd0@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.51
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1A34C3E06
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FREEMAIL_ENVRCPT(0.00)[163.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[163.com,netfilter.org,strlen.de,davemloft.net,google.com,kernel.org,redhat.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,suse.de:dkim,kylinos.cn:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

On 8/6/26 10:45 AM, Fernando Fernandez Mancera wrote:
> On 8/6/26 9:50 AM, Qingshuang Fu wrote:
>> From: Qingshuang Fu <fuqingshuang@kylinos.cn>
>>
>> The variables 'rplnlh' in conntrack_data_insert() and 'rplnlh' together
>> with 'nest' in conntracK_count_zone() and conntrack_flush_zone() were
>> declared but never used since they were introduced.
>>
>> Similarly, commit 76342e842587 ("selftests: netfilter: remove unused
>> parameter") removed the unused 'err' variable from these functions but
>> overlooked the remaining unused 'rplnlh' and 'nest' variables.  Remove
>> them to clean up the code.
>>
>> Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")
>> Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
>> ---
> 
> Thanks for patch, it looks good to me but could we avoid the fixes tag 
> here?
> 
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>

Actually, since you are at it.. could you also include the following 
diff? Thanks!

--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -216,7 +216,7 @@ static int count_entries(const struct nlmsghdr *nlh, 
void *data)
         return MNL_CB_OK;
  }

-static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
+static int conntrack_count_zone(struct mnl_socket *sock, uint16_t zone)
  {
         char buf[MNL_SOCKET_BUFFER_SIZE];
         struct nlmsghdr *nlh;
