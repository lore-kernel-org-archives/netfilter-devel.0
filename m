From: Marcel Pol <mpol@gmx.net>
Subject: linux-2.6 and iptables compiled against 2.4 problems
Date: Sun, 31 Aug 2003 15:04:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030831150403.3472842d.mpol@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello,
When I run iptables on a 2.6 kernel, I get an invalid argument with SNAT, and
a target problem with REDIRECT. 
The userspace tools are built against linux-2.4. When compiled against
linux-2.6, it runs fine. 
This happens with 1.2.8, and with cvs from 20030813 (i couldn't get 20030825
compiled).
I run this on a kernel from Mandrake, 2.4.22-1mdk or 2.6.-test3-1mdk.

The problem is that when a distribution like Mandrake ships both a 2.4 and a
2.6 kernel, it will have a broken iptables for linux-2.6. Linux-2.4 is still
the main kernel, and that's the one which is used to compile iptables, while
the latest 1.2.8 release doesn't compile against linux-2.6.
The workaround for this would be to have a seperate iptables package compiled
from cvs against linux-2.6, but that's really no ideal situation.

I'm aware of the fact that linux-2.6 is ready yet for production, especially a
firewall. But for people who want to for whatever reason, it would be good to
have it working right. At the time that linux-2.6 is fully supported by
distro's, together with linux-2.4, it's really needed to have this working
right.
So I'm wondering if this incompatibility is (sort of) on purpose, or can I ask
and expect a fix for it?

Just for information, these rules break for example:
# iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source 127.0.0.1
iptables: Invalid argument
#  /sbin/iptables  -t nat -I PREROUTING -i eth0 -p tcp --dport 53 -j REDIRECT
#  --to-ports 22
iptables: Target problem

--
Marcel Pol
