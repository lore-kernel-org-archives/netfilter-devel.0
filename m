From: "Markus" <listuser@sally.epygi.de>
Subject: pptp patch breaks nat-reservation patch (on ppc-machines)
Date: Fri, 9 Jul 2004 09:54:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BDEHJGPIKNLKJJBCCFPLOEIOCOAA.listuser@sally.epygi.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

HiHo!

Playing with pptp and nat-reservation patches I
stumbled upon the following phenomena:
(viewed on PPC, not entirely sure if same goes
for Intel machines)

A)
The pptp-patch changes the union ip_conntrack_manip_proto
in ip_conntrack_tuple.h (including but not limited to):
  u_int16_t all -> u_int32_t all
	(see end of mail for complete struct)

I understand the reason for this, but isn't it dangerous?
  1. Anyone who is using this struct as a memory map
     (say somewhere fill it with .udp.port but access it
     with .all) will get an alignment problem (at least
     on PPC-architecture). Well actually this is
     what breaks the nat-reservation-patch.
	Is this the only patch that uses .all?

  2. Filling the union with one of the structs 
     should lead to uninitilized parts. say:
	  ip_conntrack_manip_proto x;
	  x.tcp.port = 0;
        x.all == 0 -> need not be true!
     Or am I missing something?

Same problem with struct ip_conntrack_tuple.
 
B) 
Now i was wondering why this conflict doesn't occur more often:
A quick grep for .u.all showed that there are only
three kinds of usage (at least for the patches i use):
    1) used by the pptp patch
    2) used by the nat-reservation patch
    3) used by means of hashing
          ( alignment is not a problem here. Put in something wrong
            and you will find the exact wrong structure again, it is
		still unique. Initialization should be a problem though ;)


I may be overlooking something, but i would assume that the
pptp-patch as it is right now, potentially disturbs other patches, at least
those that use a mixture of access (.all and .tcp/.udp..).
Right now it seems that only nat-reservation is concerned.

ciao
  markus

P.S. I am using linux 2.4.18 with netfilter 1.2.8 on a PPC.
     but i looked into recent versions, no changes there.

====================================
union ip_conntrack_manip_proto
{
	/* Add other protocols here. */
- 	u_int16_t all;
+	u_int32_t all;

	struct {
		u_int16_t port;
	} tcp;
	struct {
		u_int16_t port;
	} udp;
	struct {
		u_int16_t id;
	} icmp;
+	struct {
+        gre stuff....
+	} gre;
};
