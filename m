From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070707 kernel
Date: Wed, 11 Jul 2007 20:04:25 +0200
Message-ID: <46951BA9.4010809@trash.net>
References: <Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>
	<468E3E06.3080305@trash.net>
	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
	<200707100630.l6A6UB8Q000847@toshiba.co.jp>
	<Pine.LNX.4.64.0707111933530.11053@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707111933530.11053@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jul 10 2007 15:30, Yasuyuki KOZAKAI wrote:
> 
>>>+		if (nf_ct_get_tuple(skb, 0, 0, match->family, match->proto,
>>>+		    &tuple, NULL, NULL) != 0)
>>>+			goto hotdrop;
>>
>>The second argument is the offset to network protocol header,
>>skb_network_offset(skb) (it is 0 in most cases, but it is more logical).
>>
>>IIRC nf_conntrack_proto_icmp[v6].c do same things. If I have any time
>>at late night today, I'll write a generic function for them.
> 
> 
> I have applied your three patches to receive the nf_ct_get_tuplepr() 
> function, and connlimit now reads:
> 
> [...]
> 
> But, nf_ct_get_tuplepr() returns with 1, and I am not sure why.


Thats expected I guess, 1 is usually "success" for the tuple parsing
functions.
