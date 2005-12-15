From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: problem with conntrack utility and kernel 2.6.14 - still with
 2.6.14.4
Date: Thu, 15 Dec 2005 18:21:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0512151817400.12541@bizon.gios.gov.pl>
References: <43627A8F.9060307@eurodev.net> <436281BB.2010100@fliegl.de>
	<4392510A.3030400@eurodev.net>
	<200512041710.jB4HA40F021665@toshiba.co.jp>
	<4393390C.4080301@fliegl.de> <43A16669.6080307@fliegl.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-222805137-1134667272=:12541"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <43A16669.6080307@fliegl.de>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-222805137-1134667272=:12541
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 15 Dec 2005, Deti Fliegl wrote:

> ... it seems that somehow the same old conntrack bug still occures with=
=20
> kernel 2.6.14.4 released today. I thought the patches would go into the=
=20
> release trunk? Did I miss something?

You may use my private patch-set for 2.6.14.4=20
(ftp://ftp.ans.pl/pub/patches/patch-ole-2.6.14.4-o1.gz):

+ 0020: iptables-PreroutingFilter-2611
+ 0030: IPv6-OptionalSIT-26
+ 0050: VGACanDo64KB-Option-26
+ 0060: 3c59x-ShowEthID-26
+ 0061: tulip-8021q-2.6.13.2-szpajder
+ 0070: 2.6.14-libata-passthru
+ 0101: proto_find
+ 0102: ctnetlink-fix-unbalancedread_unlock_bh
+ 0103: CTA_PROTO_NUM-u_int8_t
+ 0120: workaround-for-pnp-device-interrupt
+ 0130: vlan-CHECKSUM_HW
+ 0140: ip_gre-csum

Patches 0101, 0102 and 0103 have the most critical fixes for the=20
nf_netlink/conntrack.

Best regards,


 =09=09=09Krzysztof Ol=EAdzki
---187430788-222805137-1134667272=:12541--
