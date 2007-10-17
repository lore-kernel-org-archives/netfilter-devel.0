From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH 08/13] Split Netfilter IPv4 defragmentation into a separate
 module
Date: Wed, 17 Oct 2007 21:11:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710172108180.8216@bizon.gios.gov.pl>
References: <20071002203942.11052.7303.stgit@nessa.odu>
 <20071002204349.11052.18611.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1446113858-1192648275=:8216"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:52041 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbXJQTLn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2007 15:11:43 -0400
In-Reply-To: <20071002204349.11052.18611.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1446113858-1192648275=:8216
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE


Hello,

On Tue, 2 Oct 2007, KOVACS Krisztian wrote:

> Netfilter connection tracking requires all IPv4 packets to be defragmente=
d.
> Both the socket match and the TPROXY target depend on this functionality,=
 so
> this patch separates the Netfilter IPv4 defrag hooks into a separate modu=
le.

With this patch taken from:
  http://people.netfilter.org/hidden/tproxy/tproxy4-2.6.23-200710090922.tar=
=2Ebz2
with:
# CONFIG_NF_CONNTRACK_ENABLED is not set
# CONFIG_NF_CONNTRACK is not set

I get:

net/ipv4/netfilter/nf_defrag_ipv4.c: In function 'ipv4_conntrack_defrag':
net/ipv4/netfilter/nf_defrag_ipv4.c:44: error: 'struct sk_buff' has no memb=
er named 'nfct'
make[3]: *** [net/ipv4/netfilter/nf_defrag_ipv4.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2

This is not a surprise since:
--- cut here ---
#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
         struct nf_conntrack     *nfct;
         struct sk_buff          *nfct_reasm;
#endif
--- cut here ---

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1446113858-1192648275=:8216--
