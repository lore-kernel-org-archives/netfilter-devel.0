From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] chaostables
Date: Thu, 08 Mar 2007 18:15:12 +0100
Message-ID: <45F044A0.50001@trash.net>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
	<20070308131412.08d9973e@lxorguk.ukuu.org.uk>
	<Line.LNX.4.64.0703080955060.8029@d.namei>
	<Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	James Morris <jmorris@namei.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr>
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
>>>Index: linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
>>>+	/* Equivalent to:
>>>+	 * -A chaos -m statistic --mode random --probability \
>>>+	 *         $reject_percentage -j REJECT --reject-with host-unreach;
>>>+	 * -A chaos -m statistic --mode random --probability \
>>>+	 *         $delude_percentage -j DELUDE;
>>>+	 * -A chaos -j DROP;
>>>+	 */
>>
>>What does this do that can't be done by simply adding those individual 
>>rules?
> 
> 
> It "wraps it all up", reducing the overall number of rules and user 
> chains required in the filtering tables to implement the wanted logic. 
> Reducing the number of filtering rules also reduces the time process a 
> packet. These two are, in my opinion, a good thing.


By that argument we could just codify every ruleset and put it in the
kernel. Its three simple rules. There is no chance I'm going to take
this part.

> Take xt_portscan as an example, which would require a minimum of 23 
> filtering rules (which cannot reproduce the module's action in its 
> fullest). 23 rules means we will be looping a bit in ipt_do_table() for 
> a single packet, repeatedly checking for "-p tcp", i.e. calling into 
> xt_tcpudp, checking for port ranges and perhaps other TCP fields that 
> are never examined in xt_portscan.


I'm guessing xt_portscan tries to detect and match on portscans, but
its not obvious why it looks at and changes skb->mark and nfct->ctmark,
so I suggest you start by explaining what it really does.

>>>+++ linux-2.6.21-rc3/net/netfilter/xt_DELUDE.c
>>
>>Looks like a copy of the REJECT target. What does it do,
>>why can't you use REJECT?
> 
> 
> Looking only at TCP,
> REJECT sends a RST for any packet (if requested), or ICMP otherwise.
> DELUDE sends a SYN-ACK on SYN, otherwise RST.
> (And TARPIT, for reference, keeps the connection open anytime. Its code
> is also quite a replication of REJECT.)
> 
> If you think it is better to merge the respond-with-SYNACK into REJECT 
> rather than having DELUDE, say so.


I'd rather not add hacks to mildly annoy people anywhere.

>>We already have the psd match for years, but decided against merging it.
> 
> 
> On what basis? As far as I flew over psd's code, it uses a heuristic 
> like "how often did that client recently connect" for match decision. 
> (P2P clients randomly port knocking, anyone?) I would not think of that 
> as a reliable way to tell portscans either. However, half-open TCP 
> connect for example is a more clear action to define a portscan.


The question is what we gain by being able to detect portscans.
So far my opinion is thats its close to nothing. Besides that,
it should be possible to do this by using the recent match.
