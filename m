From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrackd 0.9.0 released
Date: Mon, 18 Sep 2006 15:22:28 +0200
Message-ID: <450E9D94.1010301@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-ha@lists.netfilter.org
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

Overview:

Conntrackd is the userspace daemon for the Connection Tracking System.
This daemon maintains a copy of the Connection Tracking System in
userspace. It is entirely written in C and is highly configurable and
easily extensible. Currently it covers the specific aspects of Stateful
Linux firewalls to enable high availability solutions and can be used as
statistics collector of the firewall use.

Status:

This project is under development, people feeling brave are encouraged
to test a send nice reports ;)

Future Plans:
- Support for TCP window tracking (still on discussion)
- Improve integration with keepalived (preemption issues)
- Test yet implemented IPv6 code
- Merge the conntrack tool and conntrackd packages: the conntrack tool
will be able to dump the conntrack table not only from the kernel but
also from conntrackd via UNIX sockets that, for example, can be used to
implement wildcards to dump and delete entries and monitor the current
traffic processed reducing the performance drop that suppose polling
from /proc/net/ip_conntrack
- Improve statistics info

More information available at:

http://people.netfilter.org/pablo/conntrackd/

Enjoy,

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
