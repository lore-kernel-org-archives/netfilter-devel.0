From: quadong@users.sf.net
Subject: iptables.8 -i
Date: Fri, 5 Mar 2004 09:47:12 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0403050940260.21790@dsl093-017-216.msp1.dsl.speakeasy.net>
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

iptable's man page currently reads:

-i, --in-interface [!] name
         Name of an interface via which a packet is going to be received

I think this would be a lot clearer if it read:

-i, --in-interface [!] name
         Name of an interface via which a packet was received

Because Netfilter doesn't match packets that it is going to receive, it
matches ones it has received.

If psuedo-trivial documentation changes are seen as annoyances on this
list, let me know and I'll shut up. :-)

-matthew
