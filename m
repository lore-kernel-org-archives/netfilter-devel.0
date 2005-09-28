From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [ANNOUNCE] Release of nf-HiPAC 0.9.0
Date: Wed, 28 Sep 2005 15:05:02 +0100
Message-ID: <433AA30E.7060709@ufomechanic.net>
References: <200509260441.42483.mbellion@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200509260441.42483.mbellion@hipac.org>
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

This auto-factorization of rules seems cool.

> Dynamic rule sets:
> nf-HiPAC offers fast dynamic rules et updates without stalling packet
>classification in contrast to iptables which yields bad update performance
> along with stalled packet processing during updates.

Does it also remove the "upload rules in bulk" issue of iptables and
make use of links lists (or trees) to upload small changes singly? I
recall someone released a re-write a while ago that took care of this,
but this seems to do rule-factoring too to reduce the number of check
operations.

Speaking under fear of blasphemy I'm wondering what stops this becoming
iptables proper? (ipv4 anyway)?  OK, it would want linking to
nf_conntrack instead of ip_conntrack and a v6 version doing type stuff,
but it seems the biz.

Azez
