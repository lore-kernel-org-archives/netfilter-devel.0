Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B75C33F594
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Mar 2026 19:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773514827; cv=none; b=b8Cc8kN48k/U4VMWIbVANVnlkSVRgpGFHGPncB1e72+QpehWGOuBIlmVfbragFF/SdC8YP4z5y4T+/spYczIE7wRdjEQ0soM+7qsxGQqoO95rcDlz+/eDESt9N4g0zg1ulb10CBfNxZOkgKeIUUfHFaATgWh9yQA/F1Az4kQzbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773514827; c=relaxed/simple;
	bh=ArjkbCM0Y/lfRBU7SDRZIWp0W5IXT40445X24YYfOEs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=sWNKWpHRrgIBsbj2yf+tEbF5IjA16YXHhU5x/lrkAAifjd9ADGN6HGfYXkpOj9EKQjkzH2RjPziFaA7T9VoHRxW/3ix+gGC2OhXs8DpN9RhBjBiDdGQqD9niKX++kcxf2HFgjiqtHrYnTk8bAcZblDNqm2bE4cku4FBUWm5eL4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=tFQuekLB; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nj7U/0Co; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=HWuILskf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=XZG8rned; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="tFQuekLB";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nj7U/0Co";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="HWuILskf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="XZG8rned"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 924844D21E;
	Sat, 14 Mar 2026 19:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773514817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XEWchb6WRyKBLUByVsivq0ybYKF5A+Iuz2L5Gl1dkmM=;
	b=tFQuekLBpBgTJ2UeQbiYdPDML6pGieLA/XvrogAHg/+kt5tNA6cHl0Lo2oohgPoXKWvZLU
	+Wpeu2vozwfDzctNfDJd77vxnW9GNo7CjD9WaACAlQEM4aSCSCJ+dWfz7EaCfpJv/Sp3cE
	qf4fRz89FYxAWnH+PZXhcMU8axVX7ZU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773514817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XEWchb6WRyKBLUByVsivq0ybYKF5A+Iuz2L5Gl1dkmM=;
	b=nj7U/0CoPE4u9qeJfB23YlxA0Cn715pMlErX1QmOQ0wLJuD6m9JAFMIF/glhXJa9mi2Vs+
	Qw4ai2ZDa6n/VIDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773514816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XEWchb6WRyKBLUByVsivq0ybYKF5A+Iuz2L5Gl1dkmM=;
	b=HWuILskf/QIgrpDs9eOUDtg5vSqxRSRJH57VozcoaVdAFLhbWEvvHoDIu9A1PvgKle0emf
	IzhmIIgXEPojdx8wo2CmMokQ+MLnhwHzT/UVTWL0Tb1LTf5kPn2i+vAgF440lUigJQodwb
	XmKLwK9JLraPpKMVOAcT2+B7ama0H+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773514816;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XEWchb6WRyKBLUByVsivq0ybYKF5A+Iuz2L5Gl1dkmM=;
	b=XZG8rnedE5D9UhxxuxVafVWEiIrGDHTRZnyUmmOlLwwNXa5+Oe+Uh0ZeA25YDSJo0ch/CQ
	wwDdYfgSXNPu6rAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 878DD42724;
	Sat, 14 Mar 2026 19:00:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9H2yHT+wtWn4SgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Sat, 14 Mar 2026 19:00:15 +0000
Message-ID: <b3cbfd15-acd1-4500-ba30-eac6f48523fb@suse.de>
Date: Sat, 14 Mar 2026 20:00:06 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [regression] Network failure beyond first connection after
 69894e5b4c5e ("netfilter: nft_connlimit: update the count if add was
 skipped")
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: Salvatore Bonaccorso <carnil@debian.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Alejandro Olivan Alvarez <alejandro.olivan.alvarez@gmail.com>
Cc: 1130336@bugs.debian.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
 stable@vger.kernel.org
References: <177349610461.3071718.4083978280323144323@eldamar.lan>
 <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
Content-Language: en-US
In-Reply-To: <c72a56ab-a16c-4866-9a44-a03393f074db@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TAGGED_RCPT(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_TO(0.00)[debian.org,netfilter.org,strlen.de,nwl.cc,davemloft.net,google.com,kernel.org,redhat.com,gmail.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:mid]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

On 3/14/26 5:13 PM, Fernando Fernandez Mancera wrote:
> Hi,
> 
> On 3/14/26 3:03 PM, Salvatore Bonaccorso wrote:
>> Control: forwarded -1 https://lore.kernel.org/ 
>> regressions/177349610461.3071718.4083978280323144323@eldamar.lan
>> Control: tags -1 + upstream
>>
>> Hi
>>
>> In Debian, in https://bugs.debian.org/1130336, Alejandro reported that
>> after updates including 69894e5b4c5e ("netfilter: nft_connlimit:
>> update the count if add was skipped"), when the following rule is set
>>
>>     iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j 
>> REJECT --reject-with tcp-reset
>>
>> connections get stuck accordingly, it can be easily reproduced by:
>>
>> # iptables -A INPUT -p tcp -m connlimit --connlimit-above 111 -j 
>> REJECT --reject-with tcp-reset
>> # nft list ruleset
>> # Warning: table ip filter is managed by iptables-nft, do not touch!
>> table ip filter {
>>          chain INPUT {
>>                  type filter hook input priority filter; policy accept;
>>                  ip protocol tcp xt match "connlimit" counter packets 
>> 0 bytes 0 reject with tcp reset
>>          }
>> }
>> # wget -O /dev/null https://git.kernel.org/torvalds/t/linux-7.0- 
>> rc3.tar.gz
>> --2026-03-14 14:53:51--  https://git.kernel.org/torvalds/t/linux-7.0- 
>> rc3.tar.gz
>> Resolving git.kernel.org (git.kernel.org)... 172.105.64.184, 
>> 2a01:7e01:e001:937:0:1991:8:25
>> Connecting to git.kernel.org (git.kernel.org)|172.105.64.184|:443... 
>> connected.
>> HTTP request sent, awaiting response... 301 Moved Permanently
>> Location: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/ 
>> linux.git/snapshot/linux-7.0-rc3.tar.gz [following]
>> --2026-03-14 14:53:51--  https://git.kernel.org/pub/scm/linux/kernel/ 
>> git/torvalds/linux.git/snapshot/linux-7.0-rc3.tar.gz
>> Reusing existing connection to git.kernel.org:443.
>> HTTP request sent, awaiting response... 200 OK
>> Length: unspecified [application/x-gzip]
>> Saving to: ‘/dev/null’
>>
>> /dev/null                         [                         
>> <=>                    ] 248.03M  51.9MB/s    in 5.0s
>>
>> 2026-03-14 14:53:56 (49.3 MB/s) - ‘/dev/null’ saved [260080129]
>>
>> # wget -O /dev/null https://git.kernel.org/torvalds/t/linux-7.0- 
>> rc3.tar.gz
>> --2026-03-14 14:53:58--  https://git.kernel.org/torvalds/t/linux-7.0- 
>> rc3.tar.gz
>> Resolving git.kernel.org (git.kernel.org)... 172.105.64.184, 
>> 2a01:7e01:e001:937:0:1991:8:25
>> Connecting to git.kernel.org (git.kernel.org)|172.105.64.184|:443... 
>> failed: Connection timed out.
>> Connecting to git.kernel.org (git.kernel.org)| 
>> 2a01:7e01:e001:937:0:1991:8:25|:443... failed: Network is unreachable.
>>
>> Before the 69894e5b4c5e ("netfilter: nft_connlimit: update the count
>> if add was skipped") commit this worked.
>>
> 
> Thanks for the report. I have reproduced this on upstream kernel. I am 
> working on it.
> 

This is what is happening:

1. The first connection is established and tracked, all good. When it 
finishes, it goes to TIME_WAIT state
2. The second connection is established, ct is confirmed since the 
beginning, skipping the tracking and calling a GC.
3. The previously tracked connection is cleaned up during GC as 
TIME_WAIT is considered closed.
4. count is therefore 0 and xt performs a drop.

There are two different approaches to fix this IMHO.

The first one would be to stop considering TIME_WAIT as closed. But that 
would artificially solve the issue.

The second one is to check what is the TCP status inside the 
nf_ct_is_confirmed() check and if it is SENT or RECV but confirmed there 
are two options - ore it is a retransmission or the ct was confirmed 
even before we tracked it. In both situations, perform an insert with a 
GC. Then we make sure no duplicate tracking is happening and the 
connection is tracked properly. The following diff fixes it, what do you 
think? I can send a formal patch if this solution is considered acceptable.

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 00eed5b4d1b1..ae94e5d7e00b 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -78,6 +78,15 @@ static inline bool already_closed(const struct 
nf_conn *conn)
  		return false;
  }

+static inline bool tcp_syn_sent_or_recv(const struct nf_conn *conn)
+{
+	if (nf_ct_protonum(conn) == IPPROTO_TCP)
+		return conn->proto.tcp.state == TCP_CONNTRACK_SYN_SENT ||
+		       conn->proto.tcp.state == TCP_CONNTRACK_SYN_RECV;
+	else
+		return false;
+}
+
  static int key_diff(const u32 *a, const u32 *b, unsigned int klen)
  {
  	return memcmp(a, b, klen * sizeof(u32));
@@ -183,6 +192,9 @@ static int __nf_conncount_add(struct net *net,
  		 * might have happened before hitting connlimit
  		 */
  		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+			if (tcp_syn_sent_or_recv(ct))
+				goto check_connections;
+
  			err = -EEXIST;
  			goto out_put;
  		}

> Thanks,
> Fernando.
