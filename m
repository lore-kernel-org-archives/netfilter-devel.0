From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3][CONNTRACK] Introduce flag facilities to take over
 TCP connections
Date: Wed, 29 Nov 2006 15:27:17 +0100
Message-ID: <456D98C5.7030604@netfilter.org>
References: <456C6D3C.9060909@netfilter.org> <456CB6F7.6010909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <456CB6F7.6010909@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>> Hi Patrick,
>>
>> I reworked the previous patch based on some of your suggestions. Let me
>> know what you think.
> 
> We're almost there :)
> 
>> +	/* skip window scale and flags dump if hard tracking is by passed */
> 
> minor nitpick: bypassed

OK ;)

>> +	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_ORIGINAL, sizeof(u_int8_t),
>> +		&ct->proto.tcp.seen[0].flags);
>> +	
>> +	NFA_PUT(skb, CTA_PROTOINFO_TCP_FLAGS_REPLY, sizeof(u_int8_t),
>> +		&ct->proto.tcp.seen[1].flags);
> 
> The attributes should contain the same data type in both directions,
> the receive side expects a structure.

how could the mask field make sense for the dumping?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
