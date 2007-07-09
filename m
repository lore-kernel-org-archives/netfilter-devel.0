From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TARPIT (was: ipt_account / iptables 1.3.8)
Date: Mon, 9 Jul 2007 17:09:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707091706380.2887@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>
	<469239FE.3020904@trash.net>
	<Pine.LNX.4.64.0707091555210.32335@fbirervta.pbzchgretzou.qr>
	<469242F2.6080505@trash.net>
	<Pine.LNX.4.64.0707091654180.32335@fbirervta.pbzchgretzou.qr>
	<46924E74.1060706@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kadlec@blackhole.kfki.hu
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46924E74.1060706@trash.net>
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


On Jul 9 2007 17:04, Patrick McHardy wrote:
>
>The difference is that this is a global ratelimit, while xrlim_allow
>is a per dst_entry ratelimit.
>
>> As far as I can see, that xrlim call is there for at least one case:
>> 
>> tarpit sends ACKs with window=0, but client ignores the RFC-given delay for
>> window=0 packets.
>
>I think its more to prevent flooding your upstream, especially with
>asynchronous bandwidth. Same reason you would usually rate-limit
>the REJECT target on a DSL line.
>
REJECT is for rejecting. People who use it _do_ want that the RST/ICMP
is sent out immediately; otherwise they could just use DROP IMO.

A user can combine REJECT with hashlimit if he desires so.
I do not have any objection to remove all ratelimiting in TARPIT,
and instead put the user in charge of combining TARPIT with hashlimit.



	Jan
-- 
