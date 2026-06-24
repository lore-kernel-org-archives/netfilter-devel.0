Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0768A3B776D
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 09:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782293221; cv=none; b=VTRve5Wg1Xpl8naA5P7G1ZEMcVwNbW/SVJurioW2ssNKc/Sre0RVwGiaVgLPD5xBXXswjJ0IqUE+GCIyUH7/Cpjm9aF8iBGzrnTZP1/KIf5vZO/u3/6YYUOxl9h2rwL5c//y7JQwIH2k09ANU1XyjsfoR1kzWDymnNeleTHFe0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782293221; c=relaxed/simple;
	bh=ECYkSCWgWvJI7G5tGyG5pSnuf9RPqs6WovGHuzFxX1w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QjO1pscp9DIQKNl26sZmCC3P5ny5sTzvaxQJfxlx3YiXSCVa4r5uqwdHHQAGPLv/fWgZVxdOXpeYtERL6Gq7lEydMT5T3fXZ3ZKBzuxVKKzz8pAnakSMqeFMjJOOF9TnDQ5ZbElT4F1AeVMmV4AX1vNB69y97UeFapbark07VRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H+288ZHg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Dy1aTWxw; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Fc2XaD24; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=aUiXBPj/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H+288ZHg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Dy1aTWxw";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Fc2XaD24";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="aUiXBPj/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E44E27627B;
	Wed, 24 Jun 2026 09:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782293198; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8laax3Ycc7ZvnYrczhRXlxx6M+rKUzwaW9w3EY/x/8=;
	b=H+288ZHgQryFOCffBCgJiNSZSlqNBt08LOP7w5k1jBfkvLLTiexwXMm/rGz/92DhV/NFMI
	oIYZLHnUSuTiOIH9ecxgNm8ZP3RSs8lhUsOoLADdtViA3jmZaSz/OcEnXkVFJrdQUZM53B
	wJ/L+oMVLcoX9n0f3wjWjT4QbdieLo4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782293198;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8laax3Ycc7ZvnYrczhRXlxx6M+rKUzwaW9w3EY/x/8=;
	b=Dy1aTWxwdkJM0n2k8gp8YOEF6NCIdc5M0R/hc7jv+6yCke9yxrWAe6CQrEEJ+q2Y1SsH6U
	517RAFkgNZqpJ0Bg==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Fc2XaD24;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="aUiXBPj/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782293197; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8laax3Ycc7ZvnYrczhRXlxx6M+rKUzwaW9w3EY/x/8=;
	b=Fc2XaD24m28yzxZLfrn5LvfdQUpCdDARMHF5gk7hlaKfOw84EjtaB/TkRA0zBDvSWCHCjH
	ERk7omgj4x+Vkq2ye0D7yY3vTGLurcuzdcvW5XvFUsxKeIFYPMXjq3bXV02oynrl0/d5lj
	3SKvopXn/BwW3UbIGqDkhb1uKnMYgr0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782293197;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F8laax3Ycc7ZvnYrczhRXlxx6M+rKUzwaW9w3EY/x/8=;
	b=aUiXBPj/6aolsncw+KhXBKq8ce7lCxM4+SQ0oDet/FM8+qdhQGdGAeaPz+mtsVtQWZ8oKp
	mFeC27xXDTK9GBAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EF7B779A8;
	Wed, 24 Jun 2026 09:26:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WEXBH82iO2ohCQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 24 Jun 2026 09:26:37 +0000
Message-ID: <f9c9cbea-e72e-49a3-897b-9c2f6c0e2f88@suse.de>
Date: Wed, 24 Jun 2026 11:26:28 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7 nft v3] src: add tunnel statement and expression
 support
To: Florian Westphal <fw@strlen.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 Phil Sutter <phil@nwl.cc>, Eric Garver <egarver@redhat.com>
References: <20250821091302.9032-1-fmancera@suse.de>
 <20250821091302.9032-3-fmancera@suse.de>
 <CAJsUoE2uoZJH2VA6E+J+SK=G1W06JE2+0v-NmgGyGWBNRKFgng@mail.gmail.com>
 <0f9b3772-0b38-40ae-ad3f-e2e790695054@suse.de> <ajsKozU_JZ3PQLhF@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <ajsKozU_JZ3PQLhF@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E44E27627B
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/24/26 12:37 AM, Florian Westphal wrote:
> Hi Fernando
> 
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> On 12/29/25 2:51 PM, Yi Chen wrote:
>>> Hello Pablo and Fernando,
>>> I have started working on a test script (attached) to exercise this
>>> feature, using a geneve tunnel with an egress hook.
>>> Please let me know if egress is the correct hook to use in this context.
>>>
>>> However, the behavior is not what I expected: the tunnel template does
>>> not appear to be attached, and even ARP packets are not being
>>> encapsulated.
>>> I would appreciate any guidance on what I might be missing, or
>>> suggestions on how this test could be improved.
>>> Thank you for your time and help.
>>>
>>
>> As my patch is taking longer than expected because I am polishing all the
>> details related to the tunnel object let me explain it here briefly to
>> unblock you.
>>
>> The tunnel expression/object is used to attach tunnel metadata into a packet
>> so in essence support Lightweight Tunneling (LWT) using Nftables. The LWT
>> support is useful on virtualization environments where the users need to
>> created a lot of tunnels to interconnect containers that are inside
>> different VMs. Instead of creating one interface per container, the idea is
>> that the user can create a single one and then attach the metadata as
>> needed. Imagine the topology described below.
> 
> I'm trying to get Yi's test script to work but I am failing as well.
> AFAICS the entire feature doesn't work *by design*.
> 

It does? The idea is to be able to use a single tunnel encapsulate 
traffic from different endpoints. Let me write a script this week and 
will share it with you here.

>> +------------------------+                   +------------------------+
>> |--------+          VM A |                   | VM B          +--------|
>> |Box     | +------+ +---+|(192.168.124.49)   +----+ +------+ |Box     |
>> |10.0.0.1|-|vxlan0|-|eth0|-------------------|eth0|-|vxlan0|-|10.0.0.2|
>> |--------+ +------+ +---+|  (192.168.124.134)+----+ +------+ +--------|
>> |                        |                   |                        |
>> |                        |                   |                        |
>> +------------------------+                   +------------------------+
> 
> How do I read this diagram?
> Are these 4 computers or 2?
> What is "Box" ? Is that a container inside of VM A / B ?
> And if so, how does it connect to VM A?  veth?  The diagram reads like
> its a container connected to VM A via a vxlan tunnel...
> 
> Which makes no sense to me.
> 

Yeah that diagram could get some improvement. That is not accurate.

>> We want to reach 10.0.0.2 from 10.0.0.1, the nftables ruleset on VM A will
>> look like this:
>>
>> ```
>> table netdev filter_tunnel {
>> 	tunnel vxlan_tmpl {
>> 		id 100
>> 		ip saddr 192.168.124.49
>> 		ip daddr 192.168.124.134
>> 		dport 8472
>> 		ttl 255
>> 		vxlan {
>> 			gbp 100
>> 		}
>> 	}
>>
>> 	chain redirect_to_tunnel {
>> 		type filter hook ingress device "veth_host" priority filter; policy
>> accept;
>> 		ip daddr 10.0.0.2 tunnel name "vxlan_tmpl" fwd to "vxlan0"
>> 	}
>>
>> 	chain redirect_from_tunnel {
>> 		type filter hook ingress device "vxlan0" priority filter; policy accept;
>> 		ip daddr 10.0.0.1 fwd to "veth_host"
> 
> How can this work?  I tried to get this to run but *ingress* sees no
> packets.  Which is not surprising to me, as packets are *egressing* from
> VM A, not coming in.
> 
> The only way that I can get it to work is via normal tunnel device +
> routes, no nftables rules needed.
> 
> Can you make a test script for packetpath?
> Or add documentation that explains how to use this feature?
> 

Yes. Let me prepare some scripts and documentation. Sorry about that.

> Thanks.

