From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bridge netfilter MTU discovery
Date: Thu, 08 Jun 2006 09:17:57 +0200
Message-ID: <4487CF25.5020407@trash.net>
References: <20060602111511.7d08f33c@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20060602111511.7d08f33c@localhost.localdomain>
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

Stephen Hemminger wrote:
> Is there an easy way to force bridge packets to cause an ICMP frag needed
> if the MTU of the destination is too small. Normal bridging will just drop
> the packet, but a rule to send ICMP would allow PMTU to work. Maybe even
> having a module to fragment would be good.

Conntrack breaks PMTU discovery by always defragmenting/refragmenting
packets, regardless of IP_DF. But there is no way to generate ICMP
frag required messages using iptables.
