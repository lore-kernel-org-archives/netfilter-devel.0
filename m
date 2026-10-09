Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA2A4E50C3
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Oct 2026 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556940; cv=none; b=UWDWSrTwhH7vIG37ET1RxsBXLqSHnz/BMbUt6F0ZqQ7fOv1gQOC1eqLZsSbVvwjFgQHylvHVEg0YUiuWeUpCRGRj84a4/aTwGbu2mgRJ/a+Pr90NG6/9UuJycyvpPvLn15K2X/QNh92uq2cjc9gSFQv7U4vt24sRE4I0PJ1W0gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556940; c=relaxed/simple;
	bh=L0ZY1yQv5GNt88TQoZPHqYzEbRRQTSkYQMEBVi/3ppk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VNzC6MgT2zNnVAVIH3jAnDDYUtnR64hjHsP/anKQp8XDbH5fMA/Jbid2Z2fkBoDjKWRGtk7O5ABNggTfDJTa67DA8qZJSDLcslzujz2/bxz/ikzqwIwF4isruPM2uNteXoILDVl0jF3brVQzW/HS/2/BV8Up5U9d7Jqrth3khoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 608591F7CB;
	Fri,  9 Oct 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42B9E1368B;
	Fri,  9 Oct 2026 14:42:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YSBwBUD9yGoQMgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Fri, 09 Oct 2026 14:42:08 +0000
Message-ID: <027f7f3a-1b33-40f9-bc39-ed9ef4986ed8@suse.de>
Date: Fri, 9 Oct 2026 16:41:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH nf] netfilter: ip6t_SYNPROXY: check TCP header before
 verifying checksum
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: Palla Raghunath <raghunathpalla.0209@gmail.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, Patrick McHardy <kaber@trash.net>
Cc: Shuah Khan <shuah@kernel.org>, Brigham Campbell <me@brighamcampbell.com>,
 linux-kernel-mentees@lists.linux.dev, linux-kernel@vger.kernel.org,
 syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com,
 Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org
References: <20260926204519.43402-1-raghunathpalla.0209@gmail.com>
 <e2beb9bc-7b92-4ae4-8190-c99bee8de1ca@suse.de>
Content-Language: en-US
In-Reply-To: <e2beb9bc-7b92-4ae4-8190-c99bee8de1ca@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Result: default: False [0.00 / 50.00];
	TAGGED_RCPT(0.00)[5a8667f002726fc59f88]
X-Spam-Score: 0.00

On 10/9/26 4:28 PM, Fernando Fernandez Mancera wrote:
> On 9/26/26 10:45 PM, Palla Raghunath wrote:
>> synproxy_tg6() passes par->thoff to nf_ip6_checksum() before it has
>> checked that a TCP header is actually present at that offset.
>>
>> par->thoff comes from ipv6_find_hdr(), called by ip6_packet_match()
>> with target -1. ipv6_find_hdr() only checks that each extension header's
>> first two bytes are in the skb. It then adds that header's declared
>> length to the offset and stops at the first non-extension header, so it
>> can return an offset past the end of the packet. With
>> CHECKSUM_NONE, nf_ip6_checksum() calls skb_checksum(skb, 0, thoff, 0).
>> When thoff is larger than skb->len, the BUG_ON(len) in skb_checksum()
>> fires:
>>
>>    kernel BUG at net/core/skbuff.c:3606!
>>    RIP: 0010:skb_checksum+0x8b2/0x8c0
>>    Call Trace:
>>     nf_ip6_checksum+0x1bd/0x320 net/netfilter/utils.c:89
>>     synproxy_tg6+0x1a4/0x6e0 net/ipv6/netfilter/ip6t_SYNPROXY.c:21
>>     ip6t_do_table+0xd37/0x15b0 net/ipv6/netfilter/ip6_tables.c:366
>>     ...
>>
>> In the syzbot reproducer, a 60-byte packet carries an AH header, then two
>> hop-by-hop headers. The last hop-by-hop header has nexthdr TCP and
>> hdrlen 167, so thoff is 1400.
>>
>> Fetch the TCP header with skb_header_pointer() first, as
>> nf_reject_ip6_tcphdr_get() already does. This drops packets that do not
>> contain a full TCP header at thoff before the checksum is computed.
>>
>> Fixes: 4ad362282cb4 ("netfilter: add IPv6 SYNPROXY target")
>> Reported-by: syzbot+5a8667f002726fc59f88@syzkaller.appspotmail.com
>> Closes: https://syzkaller.appspot.com/bug?extid=5a8667f002726fc59f88
>> Signed-off-by: Palla Raghunath <raghunathpalla.0209@gmail.com>
>> ---
> 
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> The nftables synproxy eval path is also affected but I think it would be 
> better to keep it in a separate patch in order to facilitate 
> backporting. The issue were introduced at different times and nftables 
> synproxy expression is "recent" compared to the iptables target.
> 
> I am sending a patch for the nftables expression and will CC you in case 
> you can test it too.
> 
> Thanks!

Actually, I thought twice about this. Could you please include the 
following diff in a v2? In addition, I think the comment is a bit 
redundant/not necessary. Could you just strip it?

Please use also the following fixes tag too.

Fixes: a311a8981727 ("netfilter: nft_synproxy: use the family-aware 
checksum helper")

Thanks,
Fernando.

diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 554a96a000f4..6b290a89886d 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -118,12 +118,6 @@ static void nft_synproxy_do_eval(const struct 
nft_synproxy *priv,
  		return;
  	}

-	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
-			nft_pf(pkt))) {
-		regs->verdict.code = NF_DROP;
-		return;
-	}
-
  	tcp = skb_header_pointer(skb, thoff,
  				 sizeof(struct tcphdr),
  				 &_tcph);
@@ -132,6 +126,12 @@ static void nft_synproxy_do_eval(const struct 
nft_synproxy *priv,
  		return;
  	}

+	if (nf_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP,
+			nft_pf(pkt))) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
  	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
  		regs->verdict.code = NF_DROP;
  		return;


> 
>>   net/ipv6/netfilter/ip6t_SYNPROXY.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/ipv6/netfilter/ip6t_SYNPROXY.c b/net/ipv6/netfilter/ 
>> ip6t_SYNPROXY.c
>> index d51d0c3e5fe9..04db1f82420b 100644
>> --- a/net/ipv6/netfilter/ip6t_SYNPROXY.c
>> +++ b/net/ipv6/netfilter/ip6t_SYNPROXY.c
>> @@ -18,13 +18,16 @@ synproxy_tg6(struct sk_buff *skb, const struct 
>> xt_action_param *par)
>>       struct synproxy_options opts = {};
>>       struct tcphdr *th, _th;
>> -    if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
>> -        return NF_DROP;
>> -
>> +    /* par->thoff may point past the end of the packet; make sure a
>> +     * full TCP header is present before checksumming up to it.
>> +     */
>>       th = skb_header_pointer(skb, par->thoff, sizeof(_th), &_th);
>>       if (th == NULL)
>>           return NF_DROP;
>> +    if (nf_ip6_checksum(skb, xt_hooknum(par), par->thoff, IPPROTO_TCP))
>> +        return NF_DROP;
>> +
>>       if (!synproxy_parse_options(skb, par->thoff, th, &opts))
>>           return NF_DROP;
> 

