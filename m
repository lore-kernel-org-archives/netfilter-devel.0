From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ip_conntrack mixed with nf_conntrack and nf_conntrack_ipv6
Date: Tue, 13 Sep 2005 21:54:16 +0900 (JST)
Message-ID: <200509131254.j8DCsGPZ000626@toshiba.co.jp>
References: <4326C11B.6060607@ufomechanic.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net
In-Reply-To: <4326C11B.6060607@ufomechanic.net>
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


Hi,

From: Amin Azez <azez@ufomechanic.net>
Date: Tue, 13 Sep 2005 13:07:55 +0100

> I'm just checking, I believe it is safe to mix ip_conntrack with
> nf_conntrack and nf_conntrack_ipv6 as long as I don't load
> nf_conntrack_ipv4 at the same time as ip_conntrack?

Maybe it's safe, as a result of the patches I suggested to solve
compatibility issue (at Sep 01).

But I don't assume this requirement as discussion on this issue.
I'm not sure that we'll never add changes which make impossible to load 
nf_conntrack and ip_conntrack.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
