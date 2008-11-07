From: Greg KH <gregkh@suse.de>
Subject: [patch 15/16] netfilter: snmp nat leaks memory in case of failure
Date: Fri, 7 Nov 2008 15:26:29 -0800
Message-ID: <20081107232629.GP4282@kroah.com>
References: <20081107231848.995297975@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net,
	Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:47661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753870AbYKGX1C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:27:02 -0500
Content-Disposition: inline; filename="netfilter-snmp-nat-leaks-memory-in-case-of-failure.patch"
In-Reply-To: <20081107232544.GA4282@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.25-stable review patch.  If anyone has any objections, please let u=
s know.

------------------

=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

netfilter: snmp nat leaks memory in case of failure

Upstream commit 311670f3e:

Signed-off-by: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
 net/ipv4/netfilter/nf_nat_snmp_basic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -742,6 +742,7 @@ static unsigned char snmp_object_decode(
 			*obj =3D kmalloc(sizeof(struct snmp_object) + len,
 				       GFP_ATOMIC);
 			if (*obj =3D=3D NULL) {
+				kfree(p);
 				kfree(id);
 				if (net_ratelimit())
 					printk("OOM in bsalg (%d)\n", __LINE__);

--=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
