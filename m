From: Eicke Friedrich <tady@gmx.net>
Subject: pom-ng include question
Date: Fri, 25 Jun 2004 12:27:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40DBFE13.6080700@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Dear list,

I've developed an iptables/netfilter extension to detect P2P traffic
called IPP2P.  It can be used to prohibit P2P traffic (by dropping
matches) or combined with connection tracking, CONNMARK and a packet
scheduler for traffic shaping of P2P traffic. I did a lot of testing
and also got much positive feedback of users. So it can be considered
as stable. The official homepage is located at:
http://rnvs.informatik.uni-leipzig.de/ipp2p/index_en.html

As an example for traffic shaping look at the following picture. I
used an eDonkey client and gave it as much upload bandwidth as
possible. After a while I used IPP2P on a bridge for traffic shaping
to 2MBits/sec without changing the client setting. The result looked
like this:
http://rnvs.informatik.uni-leipzig.de/ipp2p/delay/color_tp_60e_5p_p2p_src-1.png

So if you believe there could be a benefit of such an extension I'll
create a patch for pom-ng.

Best regards,
Eicke.
