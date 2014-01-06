From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH nf] netfilter: nf_nat: fix buffer overflow in IRC NAT
 helper
Date: Mon, 06 Jan 2014 14:09:53 +0100
Message-ID: <52CAAB21.1080703@redhat.com>
References: <1388503719-17766-1-git-send-email-dborkman@redhat.com> <20140106130444.GA8155@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Harald Welte <laforge@gnumonks.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbaAFNKK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:10:10 -0500
In-Reply-To: <20140106130444.GA8155@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/06/2014 02:04 PM, Pablo Neira Ayuso wrote:
> Hi Daniel,
>
> On Tue, Dec 31, 2013 at 04:28:39PM +0100, Daniel Borkmann wrote:
>> diff --git a/net/netfilter/nf_nat_irc.c b/net/netfilter/nf_nat_irc.c
>> index f02b360..fbbb1e6 100644
>> --- a/net/netfilter/nf_nat_irc.c
>> +++ b/net/netfilter/nf_nat_irc.c
>> @@ -34,10 +34,14 @@ static unsigned int help(struct sk_buff *skb,
>>   			 struct nf_conntrack_expect *exp)
>>   {
>>   	char buffer[sizeof("4294967296 65635")];
>> +	struct nf_conn *ct = exp->master;
>> +	union nf_inet_addr newaddr;
>>   	u_int16_t port;
>>   	unsigned int ret;
>>
>>   	/* Reply comes from server. */
>> +	newaddr = ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3;
>> +
>>   	exp->saved_proto.tcp.port = exp->tuple.dst.u.tcp.port;
>>   	exp->dir = IP_CT_DIR_REPLY;
>>   	exp->expectfn = nf_nat_follow_master;
>> @@ -57,17 +61,41 @@ static unsigned int help(struct sk_buff *skb,
>>   	}
>>
>>   	if (port == 0) {
>> -		nf_ct_helper_log(skb, exp->master, "all ports in use");
>> +		nf_ct_helper_log(skb, ct, "all ports in use");
>>   		return NF_DROP;
>>   	}
>>
>> -	ret = nf_nat_mangle_tcp_packet(skb, exp->master, ctinfo,
>> -				       protoff, matchoff, matchlen, buffer,
>> -				       strlen(buffer));
>> +	/* strlen("\1DCC CHAT chat AAAAAAAA P\1\n")=27
>> +	 * strlen("\1DCC SCHAT chat AAAAAAAA P\1\n")=28
>> +	 * strlen("\1DCC SEND F AAAAAAAA P S\1\n")=26
>> +	 * strlen("\1DCC MOVE F AAAAAAAA P S\1\n")=26
>> +	 * strlen("\1DCC TSEND F AAAAAAAA P S\1\n")=27
>> +	 *
>> +	 * AAAAAAAAA: bound addr (1.0.0.0==16777216, min 8 digits,
>> +	 *                        255.255.255.255==4294967296, 10 digits)
>> +	 * P:         bound port (min 1 d, max 5d (65635))
>> +	 * F:         filename   (min 1 d )
>> +	 * S:         size       (min 1 d )
>> +	 * 0x01, \n:  terminators
>> +	 */
>> +	/* AAA = "us", ie. where server normally talks to. */
>> +	if (nf_ct_l3num(ct) == NFPROTO_IPV4) {
>> +		snprintf(buffer, sizeof(buffer), "%u %u",
>> +			 ntohl(newaddr.ip), port);
>> +		pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
>> +			 buffer, &newaddr.ip, port);
>> +	} else {
>> +		nf_ct_helper_log(skb, ct, "IPv6 DCC unsupported for now");
>> +		return NF_DROP;
>> +	}
>
> I have mangled your patch (see attachment) to remove this branch since
> there is real IPv6 support for IRC yet in master. We'll need to
> revisit this anyway when finishing IPv6 support to the IRC helper. Let
> me know if you have any concern with this. Thanks.

Thanks, that's fine.

+	 * 0x01, \n:  terminators
+	 */
+	/* AAA = "us", ie. where server normally talks to. */
+	snprintf(buffer, sizeof(buffer), "%u %u", ntohl(newaddr.ip), port);
+	pr_debug("nf_nat_irc: inserting '%s' == %pI4, port %u\n",
+		 buffer, &newaddr.ip, port);

That should be good for now. The thing I've noticed so far is that for
DCC and IPv6 there doesn't seem to be a standard and clients try to
parse "%u %u" and expect IPv4 here.

But anyway, that fixes the bug, feel free to apply, thanks.

+	ret = nf_nat_mangle_tcp_packet(skb, ct, ctinfo, protoff, matchoff,
+				       matchlen, buffer, strlen(buffer));

