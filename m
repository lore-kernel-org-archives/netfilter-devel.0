From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables (1.4.2 release) failed to run on embedded system with
 "can't initialize iptables table `filter'"
Date: Wed, 26 Nov 2008 17:15:29 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811261711080.2741@fbirervta.pbzchgretzou.qr>
References: <op.uky4wc2dqigx4y@cyprus.local> <alpine.LNX.1.10.0811211659001.12307@fbirervta.pbzchgretzou.qr> <op.ukze8tjtqigx4y@cyprus.local> <alpine.LNX.1.10.0811221204080.25317@fbirervta.pbzchgretzou.qr> <op.uk6pzalwqigx4y@cyprus.local>
 <alpine.LNX.1.10.0811251841070.15844@fbirervta.pbzchgretzou.qr> <op.uk6vd0boqigx4y@cyprus.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: David Wu <davidwu@arcturusnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54276 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYKZQPb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:15:31 -0500
In-Reply-To: <op.uk6vd0boqigx4y@cyprus.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-25 20:07, David Wu wrote:
> On Tue, 25 Nov 2008 12:45:55 -0500, Jan Engelhardt <jengelh@medozas.d=
e> wrote:
>> On Tuesday 2008-11-25 18:10, David Wu wrote:
>> >
>> >It seems that I really have a 0 chains to start. Does this include =
default
>> >chains or is it only user defined chains?
>>
>> Apparently only user-defined chains. Seems ok to me.
>
> Then will there be a patch for the implementation of malloc() which r=
eturns a
> NULL for 0 size allocation?

Like this?
(Patrick, try not to screw up utf-8 in the git log too often ;-)

commit 3430170eca6bf73b590ddbd1a1ee0573862ff555
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Nov 26 17:13:57 2008 +0100

libiptc: guard chain index allocation for different malloc implementati=
ons

Some libc implementations such as =C2=B5Clibc return NULL on malloc(0).
They are free to do that per C standard.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/libiptc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 13e4c69..544a5b2 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -503,7 +503,7 @@ static int iptcc_chain_index_alloc(struct xtc_handl=
e *h)
 	      array_elems, array_mem);
=20
 	h->chain_index =3D malloc(array_mem);
-	if (!h->chain_index) {
+	if (h->chain_index =3D=3D NULL && array_mem > 0) {
 		h->chain_index_sz =3D 0;
 		return -ENOMEM;
 	}

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
