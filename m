From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Orphaned expectations
Date: Mon, 19 Apr 2004 13:37:44 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040419203744.GA1328@linuxace.com>
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

In trying to track down the cause of the oops on read of /proc/net/ip_conntrack
I stumbled upon a larger issue which may be responsible for the livelocks I 
have seen on a few heavily used firewalls.

For reference, the relevant bug report is:

https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=131

The oops is actually caused by a mangled expect which has lost its helper. So
when print_expect hits this expect and tries to dereference like so:

	if (expect->expectant->helper->timeout)

The oops occurs.  Simply making this change prevents the oops:

	if (expect->expectant->helper && expect->expectant->helper->timeout)

But doesn't fix the underlying problem of how the expect lost its helper.

The problem is the TFTP helper can create orphaned expectations.  Consider the
following testcase:

on a:
  iptables -I INPUT -p udp --dport 69 -j DROP

on b:
  tftp -c get a:foo

The expect is setup by the tftp helper, but the master conntrack is not
confirmed.  Instead, the master is immediately sent to destroy_conntrack.
Whoops!  We've now got an orphaned expectation which will not go away (ever!).
This makes for a nice DOS btw, if it was known the TFTP helper was loaded one
could trivially fill up the conntrack table with expects.

Further, now that we have this orphaned expectation, we can Oops the kernel
without even reading /proc/net/ip_conntrack by:

on a:
  iptables -D INPUT 1

on b:
  tftp -c get a:foo   (assuming we get the same udp port as before)

This time, the kernel will oops in init_conntrack.

So we need to make sure that expectations don't get orphaned in this way, which
I believe the below patch will ensure.  Of course it will also stop the
oops on read of /proc/net/ip_conntrack.

Let me know if anyone sees problems with it.


Phil Oester




diff -ru linux-2.4.26/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.26-po/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.26/net/ipv4/netfilter/ip_conntrack_core.c 2004-02-18 08:36:32.000000000 -0500
+++ linux-2.4.26-po/net/ipv4/netfilter/ip_conntrack_core.c      2004-04-17 15:27:50.884612424 -0400
@@ -326,6 +322,11 @@
                ip_conntrack_destroyed(ct);
 
        WRITE_LOCK(&ip_conntrack_lock);
+
+       /* Make sure we don't leave any orphaned expectations lying around */
+       if (ct->expecting)
+               remove_expectations(ct,1);
+
        /* Delete us from our own list to prevent corruption later */
        list_del(&ct->sibling_list);
 
