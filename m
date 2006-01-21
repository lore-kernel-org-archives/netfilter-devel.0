From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Sun, 22 Jan 2006 05:01:07 +0900 (JST)
Message-ID: <200601212001.k0LK18V1009570@toshiba.co.jp>
References: <20060120112126.GB4603@sunbeam.de.gnumonks.org>
	<200601201150.k0KBoKM4002074@toshiba.co.jp>
	<20060120130744.GH4603@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060120130744.GH4603@sunbeam.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Fri, 20 Jan 2006 14:07:44 +0100

> On Fri, Jan 20, 2006 at 08:50:19PM +0900, Yasuyuki KOZAKAI wrote:
> 
> > Well, I don't want to do it. Only ESP header is special because it cannot be
> > skipped. On the other hand, AH is normal IPv6 extension header and can be
> > skipped like others. Then 'ip6tables -p tcp -m ah ...' makes sense,
> > for example.
> 
> ok, so the only thing 'missing' is the spi matching - a feature that
> sounds cool but I doubt anyone is using anyway.

Other example is MIPv6 packet. It may include Destination Options header
and  Routing header. I cannot see future. Then I want to take some time
on this to avoid ping-pong change.

BTW, if we are allowed to do that, we can change ip6_packet_match() so that
"ip6tables -p 'ext'" matches IPv6 extension header - 'ext'. This will make it
possible to unify ip{6}t_ah. And we can also remove the code to skip headers
from hbh, dst, and so on.

-- Yasuyuki Kozakai
