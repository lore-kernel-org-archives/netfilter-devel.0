From: Joakim Axelsson <gozem@gozem.se>
Subject: default value of nf_conntrack_tcp_timeout_close_wait
Date: Wed, 4 Apr 2007 14:23:14 +0200
Message-ID: <20070404122314.GP657@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi,

I've notices that the default value of
/proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait (atleast in
kernel 2.6.20.4) is only set to 60 seconds. CLOSE_WAIT is the state where
one side has sent a FIN but not the other. Meaning we can still send data in
one direction. This is a state which can live a long time. Much longer than
just 60 seconds.

I did some googling on the issue to find previous discussions on netfilter
on the subject, and i can see that an old patch was sent in 2003 to kernel
to fix this problem. I can only guess that the newer conntrack code brought
the bug back:
http://www.linuxarkivet.se/mlists/netfilter-devel/0310/msg00016.html

It says there that the timeout is raised to 3 days. Sound more correct to
me.

To easy reproduce this you can use the command line tools "dict" where the
server closes the conntion up on answer directly but the client (you?) only
sends the FIN when closing the PAGER of dict (normally more or less).

Any thoughts on this?

/Joakim Axelsson
