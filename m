From: "raskovic@interfree.it" <raskovic@interfree.it>
Subject: [PATCH] typo in netfilter-hacking-HOWTO
Date: Tue, 2 Mar 2004 16:13:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040302161319.6227b7c5.raskovic@interfree.it>
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

fix typo in netfilter-hacking-HOWTO.sgml


--- netfilter-hacking-HOWTO.sgml.old  2002-07-02 06:07:19 +0200
+++ netfilter-hacking-HOWTO.sgml      2004-03-02 16:10:13 +0100
@@ -288,7 +288,7 @@
 that registers a function must specify the priority of the function
 within the hook; then when that netfilter hook is called from the core
 networking code, each module registered at that point is called in the
-order of priorites, and is free to manipulate the packet.  The
+order of priorities, and is free to manipulate the packet.  The
 module can then tell netfilter to do one of five things:

 <enum>
@@ -310,7 +310,7 @@
 <sect1>Packet Selection: IP Tables
 <p>
 A packet selection system called IP Tables has been built over the
-netfilter framework.  It is a direct descendent of ipchains (that came
+netfilter framework.  It is a direct descendant of ipchains (that came
 from ipfwadm, that came from BSD's ipfw IIRC), with extensibility.
 Kernel modules can register a new table, and ask for a packet to
 traverse a given table.  This packet selection method is used for
@@ -649,7 +649,7 @@
 <p>If your target alters the packet (ie. the headers or the body), it
 must call skb_unshare() to copy the packet in case it is cloned:
 otherwise any raw sockets which have a clone of the skbuff will see
-the alterations (ie. people will see wierd stuff happening in
+the alterations (ie. people will see weird stuff happening in
 tcpdump).

 <p>New targets are also usually written as a standalone module.  The
@@ -1240,7 +1240,7 @@
 `max_expected` below) is reached.
 </itemize>

-<tag>me</tag>A pointer to the module structure of the helper.  Intitialize this with  the `THIS_MODULE' macro.
+<tag>me</tag>A pointer to the module structure of the helper.  Initialize this with  the `THIS_MODULE' macro.

 <tag>max_expected</tag>Maximum number of unconfirmed (outstanding) expectations.

@@ -1412,6 +1412,7 @@
                ct      information about this (the related) connection
                info    &amp;ct->nat.info
    return value: Verdict (NF_ACCEPT, ...)
+*/
 {
        /* Change ip/port of the packet to the masqueraded
           values (read from master->tuplehash), to map it the same way,
