From: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Subject: pptp-conntrack-nat: ip_nat_proto_gre.c:gre_manip_pkt: can't nat GRE
	w/o key
Date: Sun, 3 Apr 2005 13:56:47 +0200
Message-ID: <222203005.20050403135647@stud.tue.nl>
Reply-To: Sander Eikelenboom <S.Eikelenboom@stud.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

It seems pptp code is working now with 2.6.10, now the gre code needs some
tweaks. 
In ip_nat_proto_gre.c:gre_manip_pkt it seems hdroff, greh and pgreh don't get 
the right values for their attributes. (should here skb_header_pointer be used 
too ?). In ip_conntrack_proto_gre.c:gre_pkt_to_tuple it seems to go right, 
protocol has the right value, and key and version also.

I think this could probably be the last hurdle to a working pptp-conntrack (at 
least under <= 2.6.10

As attachments I included  the kern.log (with extra debug info i put in 
ip_nat_proto_gre.c and ip_conntrack_proto_gre.c), and tcpdumps with whole 
packets on eth0 and eth1 in the bugzilla report

Regards,

Sander Eikelenboom
