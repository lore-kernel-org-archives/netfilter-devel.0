Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A361D2D9EF9
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 07:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760341732; cv=none; b=cGSfo95Hh9pPSfZxBwtQqKPem0mWN0+p/Ew2zTcO38zIQxZpq4+ss8LAwyi77UqfGuadV5/KZ3tqfi7zHjK47WRSFoFtrmHrhgakbX8QO03MlD7WD8n8G67UGNnwYSDRJUo8ayicUAoi5uw3ehCNQXdGIAmKAFism75xUrdeN6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760341732; c=relaxed/simple;
	bh=fj3ZNR8XwTowUEMTFPUcUggNlkUDFSqoLF5j12F1LhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pFGXKGPuLUjMSmPEizUsLVkZthGY1cMkID8nE3X2tm1qF66pm1ff/uQM2uDvr0O/R5ntXTRFCPw1apZTKHOo9WmSR9sQcKQ9me3jOAVb6masSYWkuNlVMHIRzqckChOvsGZ4LkbCWl76Psmp6uhNPw4BGX24TmlBZG7duQyAG5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AR0h7jSc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F/WYvwqk; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AR0h7jSc; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=F/WYvwqk; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AR0h7jSc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F/WYvwqk";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AR0h7jSc";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="F/WYvwqk"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A56EB21255;
	Mon, 13 Oct 2025 07:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760341727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=74a2OVLoFnRkd8u0qihbB4FCB3TXLOI2uZs+LvMlNO4=;
	b=AR0h7jScYQzbnmVG5EAyVrVryXRrAFjL8EHajAbu4M27mokNL2So2BrnrUGfV8fz+K80fi
	6QWNM1M+v+p9X+mdMMJ5Vzpj71+BwkTT3PSPMXBl56XcQAwl+dCeIhh3v4gyi8c4V1uY6D
	JN+mNgulkD31JkR87nRVlqP4VoXkz5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760341727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=74a2OVLoFnRkd8u0qihbB4FCB3TXLOI2uZs+LvMlNO4=;
	b=F/WYvwqk6VcSt4feLf6WzKvsKMyR92CHni2trJaz9n+KRM5EMzng6kBah53KYQUsIVvjnb
	hiJ0pYf78M/StECQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760341727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=74a2OVLoFnRkd8u0qihbB4FCB3TXLOI2uZs+LvMlNO4=;
	b=AR0h7jScYQzbnmVG5EAyVrVryXRrAFjL8EHajAbu4M27mokNL2So2BrnrUGfV8fz+K80fi
	6QWNM1M+v+p9X+mdMMJ5Vzpj71+BwkTT3PSPMXBl56XcQAwl+dCeIhh3v4gyi8c4V1uY6D
	JN+mNgulkD31JkR87nRVlqP4VoXkz5s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760341727;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=74a2OVLoFnRkd8u0qihbB4FCB3TXLOI2uZs+LvMlNO4=;
	b=F/WYvwqk6VcSt4feLf6WzKvsKMyR92CHni2trJaz9n+KRM5EMzng6kBah53KYQUsIVvjnb
	hiJ0pYf78M/StECQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D50213874;
	Mon, 13 Oct 2025 07:48:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id euowF9+u7Gg0BgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 13 Oct 2025 07:48:47 +0000
Message-ID: <8ccb4e9a-d8f1-4c70-b289-ef2ad3f02f2e@suse.de>
Date: Mon, 13 Oct 2025 09:48:36 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nft] tests: shell: add packetpath test for meta ibrhwdr
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20251009162439.4232-1-fmancera@suse.de>
 <aOkAQFrmZzKs_2X2@strlen.de>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <aOkAQFrmZzKs_2X2@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 



On 10/10/25 2:46 PM, Florian Westphal wrote:
> Fernando Fernandez Mancera <fmancera@suse.de> wrote:
>> The test checks that the packets are processed by the bridge device and
>> not forwarded.
> 
> OK, I think it would make sense to also check that we can do something
> useful with the packet.
> 
>> +
>> +ip -net "$ns1" link set veth0 up
>> +ip -net "$ns2" link set veth0 up
>> +ip -net "$ns3" link set veth1 up
>> +ip -net "$ns2" link set veth1 up
>> +ip -net "$ns2" link set br0 up
>> +
>> +ip -net "$ns1" addr add 10.1.1.10/24 dev veth0
>> +ip -net "$ns3" addr add 10.1.1.20/24 dev veth1
>> +
>> +ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
>> +table bridge nat {
>> +	chain PREROUTING {
>> +		type filter hook prerouting priority 0; policy accept;
>> +		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr
> 
> While this indeed is enough to check the bridge 'redirect to input'
> maybe it would make sense to also check that we can do something useful
> with it?
> 
> The bridge has no ip address, so I don't really see the point why anyone
> would redirect the packet locally to begin with.
> 

Thanks for explaining Florian, right I was trying to keep the test as 
simple as possible, of course this situation is not useful at all 
user-case wise.

>> +table bridge donotprocess {
>> +	chain FORWARD {
>> +		type filter hook forward priority 0; policy accept;
>> +		ip protocol icmp ether saddr da:d3:00:01:02:03 counter
>> +	}
>> +}
>> +EOF
>> +
>> +ip netns exec "$ns1" ping -c 1 10.1.1.20 || true
>> +
>> +set +e
>> +
>> +ip netns exec "$ns2" $NFT list table bridge process | grep 'counter packets 0'
>> +if [ $? -eq 0 ]
>> +then
>> +	exit 1
> 
> I think it would be nice to display WHERE its failing so that someone
> looking at testout.log doesn't have to re-run with added "set -x" or "echo
> failed at".
> 
> To give some ideas (this isn't fleshed out):
> 
> diff --git a/tests/shell/testcases/packetpath/bridge_pass_up b/tests/shell/testcases/packetpath/bridge_pass_up
> --- a/tests/shell/testcases/packetpath/bridge_pass_up
> +++ b/tests/shell/testcases/packetpath/bridge_pass_up
> @@ -38,14 +38,18 @@ ip -net "$ns3" link set veth1 up
>   ip -net "$ns2" link set veth1 up
>   ip -net "$ns2" link set br0 up
>   
> +ip netns exec "$ns2" sysctl -q net.ipv4.ip_forward=1
> +
>   ip -net "$ns1" addr add 10.1.1.10/24 dev veth0
>   ip -net "$ns3" addr add 10.1.1.20/24 dev veth1
> +ip -net "$ns2" addr add 10.1.1.1/24 dev br0
>   
>   ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
>   table bridge nat {
>   	chain PREROUTING {
>   		type filter hook prerouting priority 0; policy accept;
> -		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr
> +		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr meta mark set 1
>   	}
>   }
>   
> @@ -62,9 +66,19 @@ table bridge donotprocess {
>   		ip protocol icmp ether saddr da:d3:00:01:02:03 counter
>   	}
>   }
> +
> +table ip process {
> +	chain FORWARD {
> +		type filter hook forward priority 0; policy accept;
> +		ip protocol icmp mark 1 counter
> +	}
> +
> +}
>   EOF

This changes looks good to me, let me add them to the patch and test 
them. Thank you!
