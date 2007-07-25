From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Wed, 25 Jul 2007 17:19:42 +0200
Message-ID: <46A76A0E.8050100@trash.net>
References: <56054.81.207.0.53.1185319467.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Indan Zupancic <indan@nul.nu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <56054.81.207.0.53.1185319467.squirrel@secure.samage.net>
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

Indan Zupancic wrote:
> Hello,
> 
> After reading the "Never happen" comment in the code, I thought it
> wasn't too silly to mention that it apparently does happen. Never saw
> the message before, hence this mail. This happened on a machine
> doing SNAT for another pc, so conntrack may be involved.
> 
> The three errors happen within 1.5 seconds of each other:
> 
> [17834.377955] ipv4_get_l4proto: Frag of proto 17
> [17835.358985] ipv4_get_l4proto: Frag of proto 17
> [17835.872457] ipv4_get_l4proto: Frag of proto 17
> 
> As this seems to be an incident, I've no idea how to debug it, nor
> whether it's worth debugging. If this can be caused by a peer
> sending a bad packet I'd ignore this report.
> 
> If this is serious enough to be reported, perhaps it should be a BUG?

It should not be serious, the packets are simply dropped.

Did it perhaps happen directly after nf_conntrack_ipv4 module load?
Otherwise I think it might happen on loopback if you manually send
to large packets or possibly with NOTRACK. Any chance you're doing
anything of that?
