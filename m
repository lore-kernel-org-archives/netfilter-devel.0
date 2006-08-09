From: =?ISO-8859-1?Q?Samuel_D=EDaz_Garc=EDa?= <samueldg@arcoscom.com>
Subject: [Fwd: [Bug 499] ipp2p error. ip_tables: ipp2p match: invalid size
 0 != 8]
Date: Thu, 10 Aug 2006 01:41:12 +0200
Message-ID: <44DA7298.9070805@arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ipp2p@ipp2p.org
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

Sorry for the inconvenence, but I don't know where to look for help 
about this problem.

I have this problem, appears to be "x tables" related and somebody put 
the patch below into bugzilla and it don't works for me.

I'm using 2.6.17.8 kernel and 1.3.5 iptables. The /var/log/messages 
repeats the error in subject every time I try to load "ipp2p" rules.

Can anybody help with the patch?
Perhaps do I need to restart the box to allow changes to take efect?

Thanks

-------- Mensaje original --------

https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=499


x12345@email.ro changed:

            What    |Removed                     |Added
----------------------------------------------------------------------------
              Status|NEW                         |RESOLVED
          Resolution|                            |FIXED




------- Additional Comments From x12345@email.ro  2006-08-06 14:36 MET 
-------

diff -c ipp2p-0.8.1_rc1/Makefile ipp2p-0.8.1_rc1-ok/Makefile
*** ipp2p-0.8.1_rc1/Makefile    2006-01-04 18:34:14.000000000 +0200
--- ipp2p-0.8.1_rc1-ok/Makefile 2006-08-05 04:02:17.000000000 +0300
***************
*** 33,39 ****
   endif

   ifeq ($(IPTABLES_SRC),)
! IPTABLES_SRC = /usr/src/iptables-1.2.9
   endif

   IPTABLES_INCLUDE = -I$(IPTABLES_SRC)/include
--- 33,39 ----
   endif

   ifeq ($(IPTABLES_SRC),)
! IPTABLES_SRC = /usr/src/iptables-1.3.5
   endif

   IPTABLES_INCLUDE = -I$(IPTABLES_SRC)/include
Only in ipp2p-0.8.1_rc1-ok/: Modules.symvers
diff -c ipp2p-0.8.1_rc1/ipt_ipp2p.c ipp2p-0.8.1_rc1-ok/ipt_ipp2p.c
*** ipp2p-0.8.1_rc1/ipt_ipp2p.c 2006-01-04 18:00:49.000000000 +0200
--- ipp2p-0.8.1_rc1-ok/ipt_ipp2p.c      2006-08-06 15:29:13.000000000 +0300
***************
*** 729,734 ****
--- 729,735 ----
   match(const struct sk_buff *skb,
         const struct net_device *in,
         const struct net_device *out,
+       const struct xt_match *match,
         const void *matchinfo,
         int offset,

***************
*** 818,823 ****
--- 819,825 ----
   static int
   checkentry(const char *tablename,
               const struct ipt_ip *ip,
+           const struct xt_match *match,
             void *matchinfo,
             unsigned int matchsize,
             unsigned int hook_mask)
***************
*** 846,851 ****
--- 848,854 ----
         .name           = "ipp2p",
         .match          = &match,
         .checkentry     = &checkentry,
+         .matchsize    = sizeof(struct ipt_p2p_info),
         .me             = THIS_MODULE,
   #endif
   };

-- 
Configure bugmail: 
https://bugzilla.netfilter.org/bugzilla/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.



-- 
    Samuel Díaz García
     Director Gerente
ArcosCom Wireless, S.L.L.

CIF: B11828068
c/ Romero Gago, 19
Arcos de la Frontera
11630 - Cadiz

http://www.arcoscom.com

mailto:samueldg@arcoscom.com
msn: samueldg@arcoscom.com

Móvil: 651 93 72 48
Tlfn.: 956 70 13 15
Fax:   956 70 34 83
