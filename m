From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: limiting connection rate
Date: Fri, 23 Apr 2004 09:44:22 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404230940060.16668-100000@filer.marasystems.com>
References: <20040422201732.60347.qmail@web41906.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Null Device <nulldevice83@yahoo.com>
In-Reply-To: <20040422201732.60347.qmail@web41906.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 22 Apr 2004, Null Device wrote:

> i am using netfilter hooks only.
> is there a way i can limit the no of connections per
> second per ip using certail iptable or netfilter
> modules.

There is the connlimit match which limits the number of concurrent 
connections a single IP may be involved in.  See 
patch-o-matic-ng/connlimit,

Obviously depends on conntrack, and so will your firewall if you want to 
use a similar technique.

Note: conntrack is independent of iptables. There is no problem for your
firewall implementation to reuse conntrack.  If you also want to reuse the
NAT code outside of iptables then a little work is needed to separate the
NAT engine from iptables, but not much.


Regards
Henrik
