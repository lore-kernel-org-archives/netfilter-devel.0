From: Tobias DiPasquale <cbcgtt@gmail.com>
Subject: ip_conntrack memory leak?
Date: Fri, 28 May 2004 18:38:01 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <9e3aacf404052815384498ae20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: linux-net <linux-net@vger.kernel.org>,
	netfilter <netfilter@lists.netfilter.org>,
	nf-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I am noticing what appears to be a memory leak in conntrack on one of
my boxes. The machine is a single 2.4GHz P4 1U rackmount with software
RAID 1 on 2 40GB IDE HDDs and an onboard e1000 (eth0) and e100 (eth1).
The kernel is 2.4.26 from kernel.org with ip_conntrack compiled
statically into the kernel.

The conntrack slab (/proc/slabinfo) grows without bound and the
machine needs to be rebooted every few days in order to prevent it
from running out of memory. This machine is the most heavily loaded
box I have; it is a stateful firewall and pseudo-bridge for a
high-traffic subnet. The important thing to note here is that the
number of active objects reported by /proc/slabinfo is far below the
number that is reported by a cat /proc/net/ip_conntrack. There are
~70K entries in /proc/net/ip_conntrack, whereas /proc/slabinfo reports
several times that many active objects in the slab. As well, the
number of active objects keeps going up over time while the number of
objects reported by /proc/net/ip_conntrack stays relatively the same.

Has anyone experienced a similar memory leak in this area?

P.S. No need to reply to me personally; I am on all the lists I
submitted this message to.

--
Tobias DiPasquale
[ 0x63626367545440676d61696c2e636f6d ]
