From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter connection tracking and GRE/IPSec
Date: Sun, 04 Dec 2005 17:15:18 +0100
Message-ID: <43931616.8050705@trash.net>
References: <20051202104046.v6z10kbwn40k4440@www.milivojevic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Aleksandar Milivojevic <alex@milivojevic.org>
In-Reply-To: <20051202104046.v6z10kbwn40k4440@www.milivojevic.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Aleksandar Milivojevic wrote:
> I've just submitted bug report on Red Hat's bugzilla, and felt like discussing
> on Netfilter list too.
> 
> What happens is, for connections that go through GRE tunnel (wich is in turn
> encapsulated into IPSec tunnel), ip_conntrack is loosing connection tracking
> information.  The connection is sucessfully established, works for some period
> of time (random, I observed anywhere from several minutes to up to one hour). 
> I can see entry for it in /proc/net/ip_conntrack.  Then all the sudden
> Netfilter starts dropping packets belonging to this TCP connection.  When I
> check /proc/net/ip_conntrack on remote side (always happens on remote side of
> the tunnel, although both sides are the same), the entry for this TCP
> connection is no longer there.

The problem is the handling of IPsec packets, not GRE. I'm working on
a couple of patches to resolve this, hopefully I'll finish them in time
for 2.6.16.
