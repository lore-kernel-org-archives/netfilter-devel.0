From: Patrick McHardy <kaber@trash.net>
Subject: NFNL_NFA_NEST
Date: Wed, 21 Mar 2007 06:08:11 +0100
Message-ID: <4600BDBB.8020205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

One of the worst mistakes in nfnetlink in my opinion was the
introduction of the NFNL_NFA_NEST bit. It prevents us from
using a large part of the generic netlink stuff, since that
just interprets it as a really huge attribute type. Since
its not used even for anything, this is really annoying.

Unfortunately there is no easy way to get rid of it, current
userspace code sends it to the kernel, so even if we stop
including it in the kernel, we need to deal with it for
compatibilty.

What I want to propose is to stop sending it on both kernel
and userspace side immediately, but continue to accept it
for another year or two. After this time, we switch to use
the generic netlink stuff, which would break using old
libnfnetlink users. Since we just introduced a new API and
are fading out the old one anyway, this doesn't seem too
bad.

Any comments?
