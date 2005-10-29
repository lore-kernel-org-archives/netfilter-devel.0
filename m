From: Carlo Comin <vl4d@spine-group.org>
Subject: [IPSET] help on netlink connector
Date: Sat, 29 Oct 2005 09:58:52 +0200
Message-ID: <1130572732.11256.17.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain
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

i'm trying to rewrite the userspace<--->kernel communication using the
new netlink connector... but i need some hints...

as far as i understood from the code you add a SO_IP_SET option to ip
and manage the whole userspace->kernel process with a {get|set}sockopt:
should i add a nc_add_callback at kernel level and send messages to it
from ipset?

please be patient :D

Regards
