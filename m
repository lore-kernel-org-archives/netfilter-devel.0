From: Ryan Veety <ryan@ryanspc.com>
Subject: QUEUE on Alpha not working?
Date: Thu, 4 Sep 2003 13:17:56 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.55.0309041224060.27499@ryanspc.com>
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

My DEC Alpha Multia is running debian unstable with kernel 2.4.21.  All code
that uses libipq fails.  ipq_message_type returns NLMSG_ERROR for every
packet.  Even the intercept tool from the netfilter testsuite (CVS) fails:

# ./intercept FORWARD ACCEPT 10 10
EEEEEEEEEEEEEEEEE<snip>
Received error message 2

The ip_queue and netlink_dev modules are loaded.  I get the same result with
kernel 2.4.18, iptables 1.2.8, and iptables from CVS.  The same code
(testsuite and my own) works fine on x86 machines.  Any ideas?

Thanks
Ryan
     __________________________________________________________
   .'  Ryan Veety <ryan@ryanspc.com> - http://www.ryanspc.com  `.
   |          PGP Key: http://www.ryanspc.com/pgp.txt           |
    `----------------------------------------------------------'
