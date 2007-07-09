From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TARPIT (was: ipt_account / iptables 1.3.8)
Date: Mon, 09 Jul 2007 17:16:04 +0200
Message-ID: <46925134.1090401@trash.net>
References: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>	<469239FE.3020904@trash.net>	<Pine.LNX.4.64.0707091555210.32335@fbirervta.pbzchgretzou.qr>	<469242F2.6080505@trash.net>	<Pine.LNX.4.64.0707091654180.32335@fbirervta.pbzchgretzou.qr>	<46924E74.1060706@trash.net>
	<Pine.LNX.4.64.0707091706380.2887@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kadlec@blackhole.kfki.hu
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707091706380.2887@fbirervta.pbzchgretzou.qr>
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
> On Jul 9 2007 17:04, Patrick McHardy wrote:
> 
>>The difference is that this is a global ratelimit, while xrlim_allow
>>is a per dst_entry ratelimit.
>>
>>
>>>As far as I can see, that xrlim call is there for at least one case:
>>>
>>>tarpit sends ACKs with window=0, but client ignores the RFC-given delay for
>>>window=0 packets.
>>
>>I think its more to prevent flooding your upstream, especially with
>>asynchronous bandwidth. Same reason you would usually rate-limit
>>the REJECT target on a DSL line.
>>
> 
> REJECT is for rejecting. People who use it _do_ want that the RST/ICMP
> is sent out immediately; otherwise they could just use DROP IMO.


Speaking as "people", no. I want to reject packets since its a lot
nicer than silently dropping, but I don't want anyone to be able
to flood my upstream by sending lots of packets down my a lot faster
downstream to closed ports. So I ratelimit REJECTs using the limit
match.

> A user can combine REJECT with hashlimit if he desires so.
> I do not have any objection to remove all ratelimiting in TARPIT,
> and instead put the user in charge of combining TARPIT with hashlimit.


Yes, thats what I would prefer as well, but currently it only
ratelimits replies to ACKs, not to SYNs, so this would change
how it works. If that doesn't matter, I'm all in favour of this
change.
