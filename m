From: Sadin Nurkic <sadin.nurkic@gmail.com>
Subject: [PATCH 2/2] [NETFILTER] PPTP helper: Fix endianness bug in GRE key
Date: Fri, 4 Nov 2005 21:49:51 +1100
Message-ID: <b857c6de0511040249h38a00abfg529a2a09ce48e7f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This patch doesn't seem to fix the issue - the e-mail I sent earlier
had erroneously call-id from server side being as non 0 and failing,
but as you mention it is actually client side call-id that is in
question. After applying this patch the issue still seems to be there.

What can be done to track this one down further? I'm having a load of
issues enabling printk's but hopefully once I get that working I'll
provide some more info here as I'm really keen to get this one
working.

Regards,
Sadin Nurkic



_____________________________________
Hi Acme!

Please merge this to both 2.6.15 mainline and 2.6.14.x stable series,
thanks.

[NETFILTER] PPTP helper: Fix endianness bug in GRE key / CallID NAT

This endianness bug slipped through while changing the 'gre.key' field in t=
he
conntrack tuple from 32bit to 16bit.

None of my tests caught the problem, since the linux pptp client always has
'0' as call id / gre key.  Only windows clients actually trigger the bug.
