From: SZALAY Attila <sasa@balabit.hu>
Subject: Possible deadlock
Date: Tue, 12 Aug 2003 17:21:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030812152144.GB27237@mochrul.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

Hi All!

We have found a possible deadlock situation in netfilter in 2.4.21 kernel.

If a function what gets a lock may be called from user thread and interrupt
handler too, there may be a deadlock.

For example:

ip_conntrack_find_get function locks ip_conntrack_lock.

It may be called from icmp_error_track what can be triggered by an icmp
package and getorigdst what may be called from userspace.

We call getorigdst - then ip_conntrack_find_get gets the lock - and an
icmp package triggered icmp_error_track calls ip_conntrack_find_get
again, deadlock is arised.

The solution is - as we think - is a local_bh_disable around the
problematic call. For example in this situation:

--- ip_conntrack_core.c~        Tue Aug 12 14:25:41 2003
+++ ip_conntrack_core.c Tue Aug 12 14:28:05 2003
@@ -1326,6 +1326,7 @@
                return -EINVAL;
        }
 
+       local_dh_disable();
        h = ip_conntrack_find_get(&tuple, NULL);
        if (h) {
                struct sockaddr_in sin;
@@ -1340,11 +1341,13 @@
                DEBUGP("SO_ORIGINAL_DST: %u.%u.%u.%u %u\n",
                       NIPQUAD(sin.sin_addr.s_addr), ntohs(sin.sin_port));
                ip_conntrack_put(h->ctrack);
+               local_dh_enable();
                if (copy_to_user(user, &sin, sizeof(sin)) != 0)
                        return -EFAULT;
                else
                        return 0;
        }
+       local_dh_enable();
        DEBUGP("SO_ORIGINAL_DST: Can't find %u.%u.%u.%u/%u-%u.%u.%u.%u/%u.\n",
               NIPQUAD(tuple.src.ip), ntohs(tuple.src.u.tcp.port),
               NIPQUAD(tuple.dst.ip), ntohs(tuple.dst.u.tcp.port));


This problem may occur in other functions too.

-- 
Szalay Attila                     BalaBit IT Biztonságtechnikai Kft.
tel:(36-1)-371-05-40              1116 Bp. Csurgoi ut 20/b
fax:(36-1)-208-08-75              http://www.balabit.hu/
