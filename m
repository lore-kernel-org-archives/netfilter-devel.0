From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TARPIT (was: ipt_account / iptables 1.3.8)
Date: Mon, 09 Jul 2007 17:04:20 +0200
Message-ID: <46924E74.1060706@trash.net>
References: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>
	<469239FE.3020904@trash.net>
	<Pine.LNX.4.64.0707091555210.32335@fbirervta.pbzchgretzou.qr>
	<469242F2.6080505@trash.net>
	<Pine.LNX.4.64.0707091654180.32335@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kadlec@blackhole.kfki.hu
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707091654180.32335@fbirervta.pbzchgretzou.qr>
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
> On Jul 9 2007 16:15, Patrick McHardy wrote:
> 
>>>>No, I couldn't come up with a good way to remove the xrlim abuse yet.
>>>>
> 
> 
> If you ask me, just remove the xrlim call, and replace it by
> some sort of 'last' timestamp, e.g.
> 
> time_t last;
> 
> static int target()
> {
> 	if (!otcph->syn && otcph->ack)
> 		if (!(last <= now() + 5))
> 			return; /* rate limit */
> 	last = now();
> }

The difference is that this is a global ratelimit, while xrlim_allow
is a per dst_entry ratelimit.

> As far as I can see, that xrlim call is there for at least one case:
> 
> tarpit sends ACKs with window=0, but client ignores the RFC-given delay for
> window=0 packets.


I think its more to prevent flooding your upstream, especially with
asynchronous bandwidth. Same reason you would usually rate-limit
the REJECT target on a DSL line.
