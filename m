From: Wang Jian <lark@linux.net.cn>
Subject: Re[2]: Iptables 1.3.1 still not very fast.
Date: Sat, 02 Apr 2005 14:06:12 +0800
Message-ID: <20050402135425.0210.LARK@linux.net.cn>
References: <424E2E78.9010800@ufh.se> <20050402054112.GA20287@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050402054112.GA20287@oknodo.bof.de>
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

Hi Patrick Schaaf,

The best general practice here may be always using subnets. IP is IP/32,
iprange is IPs + Subnets + IPs then IP/32's + Subnets + IP/32's.

But best general practice is not best practice for special case. You not
dumb "add each address in the range" answer is a special case for small
set. 'set' match has ip hash to support this. If your sets are in the
same B class subnet, you'd better go this way for fastest lookup.

On Sat, 2 Apr 2005 07:41:12 +0200, Patrick Schaaf <bof@bof.de> wrote:

> > Maybe a dumb question. But how do you hash on a range?
> 
> Not a dumb question at all, but here's a dumb answer: you add each address
> in the range. This is wholly practical for small ranges, and half way
> practical for larger ranges which need to be configured only now and then.
> 
> Alternatively, in the context of ipset, you could implement a range or
> set-of-ranges subtype of ipset, using suitable data structures,
> which would be some kind of tree. For fully general set-of-ip-nets
> matching, the data structure would most likely resemble what's used
> in routing table implementations.
> 
> best regards
>   Partick



-- 
  lark
