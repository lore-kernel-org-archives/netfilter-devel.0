From: Michael Gundlach <gundlach@cs.uga.edu>
Subject: Re: PREROUTING doesn't catch all packets?
Date: Wed, 19 Feb 2003 17:50:49 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030219175049.B8641@cs.uga.edu>
References: <20030219141830.A8641@cs.uga.edu> <20030219201931.GA16304@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030219201931.GA16304@oknodo.bof.de>; from bof@bof.de on Wed, Feb 19, 2003 at 09:19:31PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yep, that did the trick.  thanks a lot.

michael

On Wed Feb 19, 2003 at 09:19PM, Patrick Schaaf wrote:

> > iptables -t nat
> 
> The NAT table NEVER sees any packet belonging to already existing
> conntrack entries. The sole purpose of the NAT table is to select
> NAT actions for NEW conntrack entries.
> 
> Thus, the behaviour you see, is the desired mode of operation,
> regardless of bridging. It is the way the NAT table is intended
> to operate.
> 
> > I need to use PREROUTING for an application that is modifying
> the destination IP of incoming packets, so "use the FORWARDING chain
> instead" isn't a sufficient answer.
> 
> The answer may be "use the PREROUTING chain of the '-t mangle' table".
> 
> best regards
>   Patrick
