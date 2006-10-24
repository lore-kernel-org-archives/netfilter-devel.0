From: Krzysztof Oledzki <olenf@ans.pl>
Subject: connbytes & 64bit counters
Date: Wed, 25 Oct 2006 00:53:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1441110585-1161730382=:23937"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

---187430788-1441110585-1161730382=:23937
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

It seems there is something wrong with connbytes and 64bit conters.

The "iptables" manual mention that counters are 64bit, so there should be=
=20
no problem with overflows, but it seems it might not be true. My firewall=
=20
puts long living ftp & http connections to a different TC class when they=
=20
reach 256MB, but aftear they reach 4GB (probably) they go back to the=20
default class, with no speed limit.

After some researches I found that ip_conntrack_counter structure defined=
=20
in nf_conntrack_common.h uses u_int32_t. I always thought that netfilter=20
has 64bit counters, hasn't it? And I'm quite sure it used to work when I=20
set up my firewall, about 1 year ago. Stange...

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki

---187430788-1441110585-1161730382=:23937--
