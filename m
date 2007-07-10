From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TARPIT (was: ipt_account / iptables 1.3.8)
Date: Tue, 10 Jul 2007 11:17:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707101116150.11053@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>
	<469239FE.3020904@trash.net>
	<Pine.LNX.4.64.0707091555210.32335@fbirervta.pbzchgretzou.qr>
	<469242F2.6080505@trash.net>
	<Pine.LNX.4.64.0707091654180.32335@fbirervta.pbzchgretzou.qr>
	<46924E74.1060706@trash.net>
	<Pine.LNX.4.64.0707091706380.2887@fbirervta.pbzchgretzou.qr>
	<46925134.1090401@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kadlec@blackhole.kfki.hu
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46925134.1090401@trash.net>
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


On Jul 9 2007 17:16, Patrick McHardy wrote:
>> A user can combine REJECT with hashlimit if he desires so.
>> I do not have any objection to remove all ratelimiting in TARPIT,
>> and instead put the user in charge of combining TARPIT with hashlimit.
>
>Yes, thats what I would prefer as well, but currently it only
>ratelimits replies to ACKs, not to SYNs, so this would change
>how it works. If that doesn't matter, I'm all in favour of this
>change.
>
Since it is not in-tree, it is not as much a "standard" as if it was in,
so I'd assume you are free to do so. I'd speculate that everyone who did
not read the code does not even know about the ratelimiting (unless it is
mentioned in some textfile AND the user read that too).
In fact, I did not know about it until I started to make TARPIT compile
with 2.6.22...


	Jan
-- 
