From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Need some clarification or help
Date: Thu, 22 Apr 2004 02:38:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404220231510.27078-100000@filer.marasystems.com>
References: <20040420182205.GA2948@rie.rie.priv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>,
   <mail@criechmann.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Riechmann <riechmann@fgan.de>
In-Reply-To: <20040420182205.GA2948@rie.rie.priv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Apr 2004, Christian Riechmann wrote:

> is it possible to read - via ipq_read/ipq_get_packet - a UDP packetr
> and after some changes to accept - via ipq_set_verdict with NF_ACCEPT and
> shorter length - it as a TCP packet?

Should be possible.

> Here is what I wish to do:
> For the transmission of IP packets (UDP, ICMP, TCP) between two hosts
> I want to send these packets through a UDP tunnel.

This is best accomplished using a virtual tunnel device for the packet
transformations. This way the packet flow gets natural to netfilter with
no risk of confusing conntrack, and MTU processing etc gets more
natural...  If you want to do the transformations in userspace then use a
tun device.

If you rewrite packets "in the middle of everything" then conntrack will 
get somewaht confused as the packets will look differently depending on 
the direction (conntrack will see forward traffic original, return traffic 
tunneled).  Also, firewalling gets a bit odd. So I would not recommend 
using QUEUE for what you describe.

Regards
Henrik
