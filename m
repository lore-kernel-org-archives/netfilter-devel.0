From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] TCPMSS: dont drop packets
Date: Wed, 24 May 2006 18:16:58 +0200
Message-ID: <447486FA.8010206@trash.net>
References: <20060524040441.111049000@snapgear.com>
	<20060524040950.838105000@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: philipc@snapgear.com
In-Reply-To: <20060524040950.838105000@snapgear.com>
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

philipc@snapgear.com wrote:
> MSS clamping should be best effort, since we are doing the clamping
> to avoid dropped packets.  If we can't clamp, then forward it anyway
> and hope PMTU discovery works.
> 
> The test case that caused problems was syn packet containing data.

That seems to be an invalid testcase.

> Related questions:
> This patch changes the behaviour when setting the MSS too, is this
> acceptable?
> 
> Should skb_make_writable() and skb_checksum_help() cause dropped packets
> if they fail?
> 
> Which mangle targets should drop packets if they fail?
> MARK should, since the mark may be used in filter rules.
> What about DSCP, ECN, TOS, TTL?

I don't think its a good idea to change this long standing behaviour.
The next incarnation of iptables will support user-supplied verdicts
for non-terminal targets, but until then it seems reasonable to say
"user said do x, can't do it, so drop".

It should be noted that most of these conditions can't be true anyway,
I have a half-finished patch to remove most of them.
