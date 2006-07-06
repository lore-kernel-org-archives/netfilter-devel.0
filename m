From: "Hung Lin" <hlin@nextone.com>
Subject: does ipset conflict with ipsec SuSE kernel patch?
Date: Thu, 6 Jul 2006 17:05:51 -0400
Message-ID: <8812D8156467224C9E9739E513037EF1F3FD47@moe.nextone.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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


I tried to install ipsets (http://ipset.netfilter.org/install.html) on
my SuSE 10.0 OS.  I could apply the kernel patches and rebuild the
kernel (Step 1 to 4 on ipsets installation webpage.)  But when I tried
to build iptables (Step 5,) it showed the error message:


/usr/src/linux/include/linux/ipv6.h:19: error: redefinition of `struct
in6_pktinfo'

In file included from /usr/src/linux/include/linux/netfilter_ipv4.h:11,

                 from
/usr/src/linux/include/linux/netfilter_ipv4/ip_tables.h:26,

                 from include/libiptc/libiptc.h:6,

                 from include/iptables.h:5,

                 from extensions/libipt_ah.c:8:

/usr/src/linux/include/net/protocol.h:38: warning: `struct sk_buff'
declared inside parameter list

/usr/src/linux/include/net/protocol.h:38: warning: its scope is only
this definition or declaration, which is probably not what you want

/usr/src/linux/include/net/protocol.h:39: error: syntax error before
"u32"

/usr/src/linux/include/net/protocol.h:39: warning: `struct sk_buff'
declared inside parameter list

/usr/src/linux/include/net/protocol.h:47: warning: `struct sk_buff'
declared inside parameter list

/usr/src/linux/include/net/protocol.h:52: warning: `struct
inet6_skb_parm' declared inside parameter list

/usr/src/linux/include/net/protocol.h:52: warning: `struct sk_buff'
declared inside parameter list

/usr/src/linux/include/net/protocol.h:62: error: field `list' has
incomplete type

make: *** [extensions/libipt_ah_sh.o] Error 1

=20

=20

Since I could build ipsets on the kernel of kernel.org, I checked SuSE
kernel patches.  There's a set of SuSE kernel patches (for IPsec) that
conflicts with ipset patches:

=20
(from series.conf in SuSE kernel source)

        # These patches are from the netfilter team, and
        # are required to tag IPsec packets for packet
        # filtering purposes.

-       patches.suse/netfilter-02-output-hooks
-       patches.suse/netfilter-03-input-hooks
-       patches.suse/netfilter-04-policy-lookup
-       patches.suse/netfilter-05-policy-checks
-       patches.suse/netfilter-06-policy-match

=20

I removed the above patches and tried to build ipset again, it worked.

Does this mean IPsec conflicts with ipsets?  The comment of SuSE kernel
patch said the patches are from netfilter team, and the ipsets are also
from netfilter.org.  Since they are both belong to netfilter team, is
there any way to resolve the conflict?

Please let me know if you need more information.  Thanks for your time.

P.S.  Please CC to hlin@nextone.com because I didn't subscribe to the
mailing list.

=20

=20

=20
Best


Hung Lin
