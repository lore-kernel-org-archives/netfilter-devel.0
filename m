Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686064FB9B5
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 20:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790629038; cv=none; b=H2WP/hMb9lnCDI/fVKqU7WBIjdjPGt0JaMxeaE5yjYlKP+bZwuavenFDjPt3XBjhE1zm6DD9PbvhgPd7ngFE5mgmeexkfDKGaJwRSRCGxSXT7vDDjo85be92P5CgFm1uM/5LZRki0bKdB5bh6knfoaiuRQ63yFT9sZDNoACxC5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790629038; c=relaxed/simple;
	bh=iKwykomEQPrKVl2BUE0YGO2i7nnrwBu2/wNVVftx8xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gm2rYJHzrlTjrqoCZ+HxhL/lFHNArKZsborQlI7zzIU16cGdGjThh8RVCJuaWiidh9zIjKV1QYca3zCoPMvqvD6Yw4QMfwiGRJhMoL0OK74OT2WIDFz3K1zPkQr3nZBJgFf/9sdxfBTbbexk56+bnXVeOXI0whYXgip00scqAcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bfzFCK7i; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=bJX+IZyY; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Ydp+GVny; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Vu8XWKe9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bfzFCK7i";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="bJX+IZyY";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Ydp+GVny";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Vu8XWKe9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 289A521B5A;
	Mon, 28 Sep 2026 20:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790629031; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRvXS1rXoc9BlBW+0YDOb1ulcYfTesGKVCurxi2gi/4=;
	b=bfzFCK7ieMvNnWi7NhcMI+OnWyzn/zqTA/6L0W7WSA5pN/ZClHwIEutTOpke0xQRBZs3pH
	JySxZNGRSRfS5h3lSFRoiyyjT/BWNLVxuuNc2ln2NOi8UBEJqyDxJgNOQwoVDYpgkX/k6W
	90kNpGVixzbStvCEiV5DhdyZHmtqWY4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790629031;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRvXS1rXoc9BlBW+0YDOb1ulcYfTesGKVCurxi2gi/4=;
	b=bJX+IZyY2fjHj6uZOzgbXGmulteWkYyeFT61PsJjouwfIAQMzmIMd79K/ecPzdfeGxJho9
	6mmu96PnBS+uB1CQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ydp+GVny;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Vu8XWKe9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790629027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRvXS1rXoc9BlBW+0YDOb1ulcYfTesGKVCurxi2gi/4=;
	b=Ydp+GVnyNie1HaD6aPVBTk6qWD0UATrKOgBMtFG9HRBORkiEBW1x8MpNUaw5YPzHswH4jv
	qAGoIstFWEQCt7rq+mZQxgwzxsms5w5KQdDy3xAXd2Yz2eZjo8o8OI1zGycalppyula3Zq
	EJ7xGXD6Z01qtGOrFvbTegi3gJTVmFY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790629027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRvXS1rXoc9BlBW+0YDOb1ulcYfTesGKVCurxi2gi/4=;
	b=Vu8XWKe9F3T2Lrgz3yXX7sEtYyP9fYhXy+SaX2hZ+I1BnYE/IJq3WxaxYJKquqCoAltbFd
	FRhgRgrSfYlER+BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB492133F3;
	Mon, 28 Sep 2026 20:57:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ULD9IqLUumoCEAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 28 Sep 2026 20:57:06 +0000
Message-ID: <f62b8394-9ead-45fe-bf26-998c0c822dcd@suse.de>
Date: Mon, 28 Sep 2026 22:56:19 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Netfilter: match "tcp option" with the same type present multiple
 times
To: Florian Westphal <fw@strlen.de>, Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
 Netfilter Coreteam <coreteam@netfilter.org>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arpn7_v8156iSc85@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <arpn7_v8156iSc85@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 289A521B5A
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -4.51

On 9/28/26 3:13 PM, Florian Westphal wrote:
> Matthieu Baerts <matttbe@kernel.org> wrote:
>> Hello Netfilter devs,
>>
>> First, thank you for maintaining Netfilter in the kernel and the
>> userspace tools.
>>
>> The MPTCP selftests are switching from IPTables to NFTables, and
>> Clashiko reported that this part of a rule wouldn't match anything:
>>
>>    tcp option mptcp subtype remove-addr drop
>>
>> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
>> added to the TCP options, it is added after an MPTCP DSS option (type
>> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
>> (type 30) options in the TCP options. It looks like Netfilter doesn't
>> handle that, because it stops processing other TCP options when the
>> expected type is found:
> 
> Yes, this won't work. 'tcp option X' extracts the
> option X.
> 
> I don't see how this could be fixed within the limitations of the
> architecture.  Just use bpf.
> 
>> It looks like it shouldn't stop if the wrong subtype is found, but the
>> subtype is not compared there if I'm not mistaken. Should there be a fix
>> to support this case?
> 
> I don't know how, unless one would extend the kernel to make it aware of
> mptcp, which also requires userspace to pass the suboption type to look
> for in addition to 'mptcp option'.
> 

This won't be easy neither fast but I added this to my TODO list. It 
sounds fun. Unless someone else does it first, I will take it.

>> BTW, I'm probably missing something, but adding the following doesn't
>> seem to have any effect on my side:
>>
>>    nft add table ip filter
>>    nft add chain ip filter OUTPUT \
>>      { type filter hook output priority filter; policy accept; }
>>    nft insert rule ip filter OUTPUT tcp option mptcp exists counter drop
>>
>> Same with "mptcp subtype mp-capable", other subtypes or other types like
>> "timestamp". But if I use ...
>>
>>    nft insert rule ip filter OUTPUT meta l4proto tcp counter drop
>>
>> ... then the drop is effective. Any idea what I'm missing here? :)
> 
> No idea.
> cd git/netfilter.org/nftables/tests/shell; ./run-tests.sh -k testcases/packetpath/tcp_options
> 
> passes here.
> Even tried adding 'tcp option timestamp exists...' to the test, also
> passes.
> 
> nft --debug=netlink list ruleset displays the rule like this:
> 
> inet t c 15 14
>    [ exthdr load tcpopt 1b @ 8 + 0 present => reg 1 ]
>    [ cmp eq reg 1 0x01 ]
>    [ objref type 1 name tsc ]
> 
> Linux 7.3.0-rc3+
> nftables v1.1.6 (Commodore Bullmoose #7)

