From: Martijn Lievaart <netfilter-devel@rtij.nl>
Subject: trivial patch for /etc/init.d/ip6tables
Date: Wed, 07 May 2003 00:57:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EB83DD1.4000005@rtij.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_ma.rtij.nl-3136-1052261841-0001-2"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bero@redhat.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_ma.rtij.nl-3136-1052261841-0001-2
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I think this is RedHat specific, so I send this to the author. CC to the 
netfilter-devel-list just FYI.

There is a little bug in /etc/init.d/ip6tables, it uses the ipv4 
tablenames for flushing and clearing. See attached patch.

HTH,
Martijn Lievaart


--=_ma.rtij.nl-3136-1052261841-0001-2
Content-Type: text/plain; name="ip6tables.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip6tables.patch"

[root@ma init.d]# diff -u ip6tables*
--- ip6tables   Wed May  7 00:46:21 2003
+++ ip6tables~  Wed Oct 23 21:47:29 2002
@@ -51,7 +51,7 @@
        if [ -f $IPTABLES_CONFIG ]; then
            # If we don't clear these first, we might be adding to
            #  pre-existing rules.
-           chains=`cat /proc/net/ip6_tables_names 2>/dev/null`
+           chains=`cat /proc/net/ip_tables_names 2>/dev/null`
            echo -n $"Flushing all current rules and user defined chains:"
             let ret=0
             for i in $chains; do ip6tables -t $i -F; let ret+=$?; done
[root@ma init.d]#

--=_ma.rtij.nl-3136-1052261841-0001-2--
