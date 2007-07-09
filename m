From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TARPIT (was: ipt_account / iptables 1.3.8)
Date: Mon, 9 Jul 2007 16:58:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707091654180.32335@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>
	<469239FE.3020904@trash.net>
	<Pine.LNX.4.64.0707091555210.32335@fbirervta.pbzchgretzou.qr>
	<469242F2.6080505@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kadlec@blackhole.kfki.hu
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <469242F2.6080505@trash.net>
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


On Jul 9 2007 16:15, Patrick McHardy wrote:
>>>
>>>No, I couldn't come up with a good way to remove the xrlim abuse yet.
>>>

If you ask me, just remove the xrlim call, and replace it by
some sort of 'last' timestamp, e.g.

time_t last;

static int target()
{
	if (!otcph->syn && otcph->ack)
		if (!(last <= now() + 5))
			return; /* rate limit */
	last = now();
}

As far as I can see, that xrlim call is there for at least one case:

tarpit sends ACKs with window=0, but client ignores the RFC-given delay for
window=0 packets.


	Jan
-- 
