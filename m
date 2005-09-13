From: Amin Azez <azez@ufomechanic.net>
Subject: fix: nf_conntrack on 2.6.11.7
Date: Tue, 13 Sep 2005 10:37:34 +0100
Message-ID: <43269DDE.5060901@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

For operational reasons I am currently constrained to 2.6.11.7 and close
derivatives.

I am trying nf_conntrack from the latest pom-ng, and I had to insert
this line:

#include <linux/ipv6.h>


to:
net/netfilter/nf_conntrack_proto_udp.c

in order to get it to compile.

Perhaps linux/ipv6 should have been included somewhere further up the
include chain, but attempts to do so resulted in various problems
related to includes BY ipv6.h

Anyway, I'll see how well it works on 2.6.11.7 but thought I would log
this change I had to make.

Sam
