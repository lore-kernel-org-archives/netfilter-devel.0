From: Patrick McHardy <kaber@trash.net>
Subject: Re: Answers to broadcast ICMP pings
Date: Wed, 11 May 2005 22:13:44 +0200
Message-ID: <42826778.1000902@trash.net>
References: <1115781511.6028.17.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pascal.news@plouf.fr.eu.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1115781511.6028.17.camel@anduril.intranet.cartel-securite.net>
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

Cedric Blancher wrote:
> Is there a particular reason for which answers to broadcast ICMP pings
> to local network are flaged as INVALID, as pointed out Pascal (Cced) ?
> 
> If I do :
> 
> 	ping 192.168.1.255
> 
> Where 192.168.1.0/24 is my local network, then answers sent by this
> network to me are flaged INVALID, as they don't match according entry in
> conntrack table :

conntrack tracks both broadcast and multicast similar to unicast,
so it expects the reply to come from the destination IP of the packet.
A reply from a different address is treated as new connection. It is
marked as INVALID because conntrack hasn't seen an echo-request before
the echo-reply.

Regards
patrick
