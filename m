From: Samuele Giovanni Tonon <samu@mclink.it>
Subject: a question about ipv4 multicast and NAT
Date: Mon, 25 Aug 2003 10:21:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825082134.GB23526@linuxasylum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi,
after some research on iptables and how to make work igmp through 
nat i came to the conclusion that there isn't still an implementation
of how to NAT multicast connection from private networks to multicast
sessions.
that's because there isn't a way (or simply i couldn't find one) 
with iptables to nat igmp request (e.g. ADD_MEMBERSHIP) and to 
keep track on received data packets .
I would like to know if you are planning to do add this feature , 
because i think that many people could be happy to have this.

regards
Samuele 


-- 
While various networks have become deeply rooted, and thoughts have been sent
out as light and electrons in a singular direction, this era has yet to 
digitize/computerize to the degree necessary for individuals to become 
a singular complex entity.
  KOUKAKU KIDOUTAI Stand Alone Complex
