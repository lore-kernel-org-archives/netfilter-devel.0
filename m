From: Patrick Schaaf <bof@bof.de>
Subject: Re: Raw Sockets and Netfiter
Date: Tue, 25 Mar 2003 08:25:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030325072544.GI18652@oknodo.bof.de>
References: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ethan Dameron <efd@duke.edu>
Content-Disposition: inline
In-Reply-To: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Mar 25, 2003 at 02:06:59AM -0500, Ethan Dameron wrote:
> If I have a an IP datagram in userspace and I send it via a raw socket
> created with socket(PF_INET, SOCK_RAW, IPPROTO_RAW) using the send()
> system call, will this packet traverse the netfilter chains?

No. Raw sockets bypass the TCP/IP stack. Netfilter hooks, and
consequently iptables, sit inside the IP stack.

Another effect of the same occurrence is that, even if your iptables
rules drop packets, you can still see them with tcpdump / ethereal.

> If it does not traverse the firewall, how can I make it do so?

The same way arptables and ebtables did it for ARP and bridging:
Make a clone of iptables (e.g rawtables), kernel and userspace.
Implement the neccessary hooks in the raw socket path, and implement
a new table for each of those hooks, into your new rawtables code.

That's not a weekend project.

You MAY get away with just calling the existing iptables hook functions
from additional places (in the raw socket processing path). That may save
you from making yet another copy of the iptables code. However, I don't
know how many normal iptables modules (especially in the NAT pathes)
will be completely confused that way - consider the case where you
tcpdump, and each dumped packet then passes the hooks TWICE, once per
normal IP processing, and once for the RAW packet copy.

That's still not a weekend project.

all the best
  Patrick
