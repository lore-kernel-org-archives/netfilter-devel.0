From: Andy Loukes <andy@navaho.co.uk>
Subject: memory leak related to bridging, conntrack and frags in 2.6.0
Date: Fri, 12 Dec 2003 10:10:33 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0312121001360.14007@picea.navaho>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

2.6.0-test11-bk8
eepro100 driver

I'm getting a major memory leak across a bridge. It goes away if I remove 
the conntrack module or I use packets < MTU.

With this:
ttcp -tus 172.16.0.12 -n 25000 -b 5000
(25000 x 5000 byte udp packets)

I see size-64 in slabinfo go up by 8472kB

Some colleagues and I are trying to figure out where the problem is but I 
thought I'd post to see if anyone has any debugging tips (we are just 
starting to get our heads round NF!) or whether this is a known problem.

regds,

-- 
Andy Loukes
http://www.navaho.co.uk						Complete Appliance Technology
