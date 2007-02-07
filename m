From: Andrew Beverley <andy@andybev.com>
Subject: Unable to use MARK target with iptables-1.3.7
Date: Wed, 07 Feb 2007 15:48:46 +0000
Message-ID: <1170863326.4250.20.camel@andybev.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Blake Covarrubias <blake@ekalb.net>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

I have sent this to the users list and had no replies, so am sending to
this list. I know of at least one other person having the same problem.

When I try to use the MARK target with iptables 1.3.7:

iptables -t mangle -A POSTROUTING -p tcp --dport 22 -j MARK \
--set-mark 10

I get:

FATAL: Module ip_tables not found.

- ip_tables is compiled into the kernel
- if I change the target to LOG it works okay
- if I drop back to 1.3.6 it works okay
- I have tried kernels 2.6.17.4 and 2.6.18.2

Is this a bug with 1.3.7 or am I doing something wrong?

Andy Beverley
