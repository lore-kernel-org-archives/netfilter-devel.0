Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794922504;
	b=pTGKeVOT84BrRgE+W0FRhVd70qoPbB5pf0UvqkTJ0Pn6PkDV82d+0mY0bQIE6zKHt7LN
	 k5vJTaRNO1al8oYYZOA2zC0c9oHkyKK5WqlRnh7Us6Yf65+jI1n3bf1BcPvs870vynctr
	 YuuO/lmufaFEdqaKua4WHZ/9GZGKNnbqjpwSrQkXetRXIrueyS+W44a6Vmx+nXcpPbetD
	 UWmA2yy0K+dgXMtgJMrIw7MN9Jdt+iNQgc+7J4mXopUdaL5jAWpVbqLnJ6lrp2FloOsCR
	 mi+AL5hbAqzlm0gdTKUwFTDZK6nch8lRBeazG97Hwju1D1ov4C4C88llBBVbwv1l/ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794922504;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=km13M/R7MtWwUTRfoPj3IOtgS+WhJstvma3kfUvt5g0=;
	b=aqsbUq2gwnEs80pFd9C24VHETN7EDJ0GVTn8AOI8NJDXuxoMbV2+sVQOqkc2suhrNG0Y
	 vOMk8K1fI4XM+zR5XxsNBDi+c8j/Es8Avx0SBM5aJvBdr12CMgl7FTRnHhsqDI1p3YMT7
	 XYwxTyHRBgQnfpx1kB6vh+UDN/VsdBEPMsh3+MfkpHQBMXR27KrUcc+dc2sYiSQITjZCg
	 ocT+XHovoADPK4jn/oCYT5tz/pGwb0UJNfwUhlRXyVWusj51i4GQgkUdXXwKp4qeQIOrg
	 mgl5t0pfMfxjE7txHxpNIBCjYtfPMtnsH8z62CcEd7JEVoSDgNVT/uIwT2u7Q9pNSTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=hDxobDHF;
	arc=none smtp.remote-ip=113.46.200.225
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5741A606A31C;
	Tue, 17 Nov 2026 13:35:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5741A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=hDxobDHF
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=km13M/R7MtWwUTRfoPj3IOtgS+WhJstvma3kfUvt5g0=;
	b=hDxobDHFEtCP4tvrJnX8VNTk1aTNP5hPXrTGuFqIF4WB9mp+vmzYua3yhTbr8c14Z45yLsIdp
	n+4dLz2fh3BG2id+KeJoMCmULG9Hx0xEyuwHPqOiypHzlVS8WyFN4Jdu4sAf+HaUpG3pZL4nUaV
	bs2+uw99pBZf9A+SU1Lpeu4=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4jTQh44MK1z1K98f;
	Tue, 17 Nov 2026 21:34:44 +0800 (CST)
Received: from whupemp200008.china.huawei.com (unknown [7.152.184.21])
	by mail.maildlp.com (Postfix) with ESMTPS id B4CA440563;
	Tue, 17 Nov 2026 21:34:57 +0800 (CST)
Received: from [10.174.176.113] (10.174.176.113) by
 whupemp200008.china.huawei.com (7.152.184.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 21:34:56 +0800
Message-ID: <b15eb6b1-6b6e-44f4-b2ac-e348a8aa5121@huawei.com>
Date: Tue, 17 Nov 2026 21:34:29 +0800
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
Subject: Re: [PATCH] audit: fix incomplete NETFILTER_PKT records and return
 void
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: Paul Moore <paul@paul-moore.com>, <audit@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>, Ricardo
 Robaina <rrobaina@redhat.com>, Florian Westphal <fw@strlen.de>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<zhangchangzhong@huawei.com>
References: <20261110122939.45373-1-jiangjiehua1@huawei.com>
 <avMXzjF9hIcTVc9c@chamomile>
Content-Language: en-US
From: "jiangjiehua (A)" <jiangjiehua1@huawei.com>
In-Reply-To: <avMXzjF9hIcTVc9c@chamomile>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemp200008.china.huawei.com (7.152.184.21)

Thanks for the review.

On 11/10/2026 9:10 PM, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Tue, Nov 10, 2026 at 08:29:39PM +0800, JiangJieHua wrote:
>> Commit f19590b07cb6 ("audit: add audit_log_nf_skb helper function") and
>> commit 15b0c43aa621 ("audit: include source and destination ports to
>> NETFILTER_PKT") introduced audit_log_nf_skb() and its transport header
>> parsing.
> 
> I guess conntrack is not enough in your scenario. How does your
> ruleset look like?
> 

The main scenario is conntrack not being enabled. The ruleset is:

     Bridge table: nat
     Bridge chain: PREROUTING, entries: 1, policy: ACCEPT
     -j AUDIT

     table inet filter {
             chain output {
                  type filter hook output priority filter; policy accept;
                  log level audit
             }
     }

Even with conntrack enabled, two cases are still affected:
- The bridge nat PREROUTING hook runs at priority -300, before conntrack 
    at -200.AUDIT sees the packet before conntrack has validated, 
trimmed, or defragged it.
- Normal IPv6 packets with extension headers. ip6_rcv_core() sets 
transport_header to the first extension header, and conntrack does not 
update it. This makes skb_transport_offset() incorrect, so we read ports 
from the wrong location.

> More comments below.
> 
>> The helper returned early with -ENOMEM when skb_header_pointer() failed for
>> the network header, and the later port parsing did the same for the
>> transport header.  Such an early return skips the remaining fields, so the
>> NETFILTER_PKT record is emitted with only "mark=" and without the address
>> and protocol fields.
>> 
>> Log the address and protocol once the network header is available, and
>> route the error paths through placeholder logging: a missing network header
>> logs "saddr=? daddr=? proto=-1", as the pre-refactoring callers did, and a
>> transport header that cannot be read where one is expected logs
>> "sport=? dport=?".  The same "proto=-1" placeholder is used for an
>> unknown bridge ethertype and an unknown nfproto, which previously printed
>> "proto=?".
>> 
>> Validate the IP version and the IPv4 header length, since bridge packets
>> can reach the audit hook without the receive path validating them.  Locate
>> the transport header from the network header instead of relying on
>> skb_transport_offset(), which is not guaranteed to point at the transport
>> header.  For IPv4, a non-first fragment or an unreadable transport header
>> logs unknown ports; protocols without ports are unaffected.  For IPv6, a
>> non-first fragment leaves proto at IPPROTO_FRAGMENT (44) and a negative
>> offset from ipv6_skip_exthdr() means the extension header chain cannot be
>> parsed; in both cases the transport header is not available, so keep the
>> addresses and protocol and do not log ports.
>> 
>> Both callers ignore the return value (net/netfilter/nft_log.c and
>> net/netfilter/xt_AUDIT.c), so make the helper return void instead of
>> inventing error codes for a value nobody consumes.
>> 
>> A packet whose network header cannot be read now logs:
>> 
>>   before: mark=0x0
>>   after:  mark=0x0 saddr=? daddr=? proto=-1
> [...]
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 631d6d4a23cf..c5997077a46b 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -2511,8 +2511,8 @@ void audit_log_path_denied(int type, const char *operation)
>>  	audit_log_end(ab);
>>  }
>>  
>> -int audit_log_nf_skb(struct audit_buffer *ab,
>> -		     const struct sk_buff *skb, u8 nfproto)
>> +void audit_log_nf_skb(struct audit_buffer *ab,
>> +		      const struct sk_buff *skb, u8 nfproto)
>>  {
>>  	/* find the IP protocol in the case of NFPROTO_BRIDGE */
>>  	if (nfproto == NFPROTO_BRIDGE) {
>> @@ -2532,24 +2532,32 @@ int audit_log_nf_skb(struct audit_buffer *ab,
>>  	case NFPROTO_IPV4: {
>>  		struct iphdr iph;
>>  		const struct iphdr *ih;
>> +		int thoff;
>> +		bool frag;
>>  
>>  		ih = skb_header_pointer(skb, skb_network_offset(skb),
>>  					sizeof(iph), &iph);
>>  		if (!ih)
>> -			return -ENOMEM;
>> +			goto unknown_proto;
>> +		if (ih->version != 4 || ih->ihl < 5)
>> +			goto unknown_proto;
>> +
>> +		thoff = skb_network_offset(skb) + ih->ihl * 4;
>> +		frag = ntohs(ih->frag_off) & IP_OFFSET;
> 
> Are we going to add all these validations everywhere in the code?
> 
> So we will have to validate that the IPv4 header is well-formed over
> and over again?

The version/ihl checks were added to handle malformed headers seen by 
bridge hooks. Should we drop these checks, or move the validation into a 
common helper as Florian suggested?

For normal packets, I think we should keep the fixes for non-first 
fragments and transport offset calculation, since those are unrelated to 
malformed headers.

Separately, I changed the unknown protocol placeholder from "?" to "-1" 
because ausearch parses proto=? as proto=ip (strtoul("?") returns 0, and 
protocol 0 is "ip").

Thanks,
JiangJieHua
