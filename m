From: Peter Kundrat <kundrat@kundrat.sk>
Subject: priority of MANGLE and NAT tables
Date: Wed, 10 Jul 2002 10:00:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020710080036.GA9220@napri.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

Basically i have the following problem: shaping together with SNAT works
only in one direction (incoming) .. but i am writing here since i
believe it is implementation problem .. not configuration one (but i
might have overlooked something).

If i shape using u32 .. the packet gets classified with real addresses,
which is too late for outgoing traffic (since the source address is
allready rewritten).

So the only chance is using fwmark and classify for that. Fine .. but 
the problem remains, since there is no hook for mangle table, where the
the src addr/port (and dst parts in reply packets) would correspond 
to the internal (translated addr/ports) = in PREROUTING .. mangle is before nat (so
before rewriting dst addr/port), and there is no mangle hook in POSTROUTING
(which would help, since it would be before SNAT).

So my questions are (since any of those would save me):
- what is the reason there is no hook for mangle table in POSTROUTING ?
- is there any reason why NAT is after MANGLE (i.e. has higher numerical
  priority) ?

I can live with my local change reverting order for MANGLE/SNAT or 
adding MANGLE hook to the POSTROUTING .. but i would still be interested
in your opinion and why it was done this way.

Thanks for any info. Regards,

	peter

PS: please CC me, since i am not subscribed


-- 
Peter Kundrat
peter@kundrat.sk
