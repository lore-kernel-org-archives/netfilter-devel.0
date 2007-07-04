From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070628 kernel
Date: Wed, 04 Jul 2007 16:52:17 +0200
Message-ID: <468BB421.3090801@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
	<468410A9.70309@trash.net>
	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>
	<4684ECB5.9070402@trash.net>
	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
	<4688EF45.7020200@trash.net>
	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
	<46891C50.1020904@trash.net>
	<Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>
	<468A2F91.3040002@trash.net>
	<Pine.LNX.4.64.0707031319000.1536@fbirervta.pbzchgretzou.qr>
	<468A3446.9050505@trash.net>
	<Pine.LNX.4.64.0707041254530.1536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707041254530.1536@fbirervta.pbzchgretzou.qr>
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
> On Jul 3 2007 13:34, Patrick McHardy wrote:
> 
>>>>Use the conntrack tuple if one is available, otherwise use
>>>>nf_ct_get_tuple().
>>>
>>>So you are saying I should use...
>>>
>>>  nf_ct_get_tuple(skb, 0, 0, match->family, match->proto, &tuple,
>>>                  what_l3, what_l4);
>>>
>>>at the top of count_them() and get rid of the nf_ct_get() in connlimit_match?
>>
>>
>>You could do both, if the tuple is already derived there is no need
>>to repeat that work.
> 
> 
> So the netfilter connection tracking system itself does nf_ct_get_tuple() at
> some point?


Right, when the packet hits connection tracking.
