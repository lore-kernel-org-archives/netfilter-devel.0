From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 3 Oct 2007 21:57:35 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710032152430.5307@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-116332602-1191441455=:5307"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:42117 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbXJCT5q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2007 15:57:46 -0400
In-Reply-To: <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-116332602-1191441455=:5307
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 3 Oct 2007, Jozsef Kadlecsik wrote:

> Hi,
>
> On Wed, 3 Oct 2007, Krzysztof Oledzki wrote:
>
>> I also wondering if the code from nf_conntrack_proto_tcp.c is correct:
> [...]
>
> I think the code segment is correct. However, the end of the segment
> is miscalculated by segment_seq_plus_len because the offset added to
> 'dataoff' by the get_l4proto function of IPv4/IPv6 is not taken into
> account. Please check whether the patch below fixes it:

Thank you. Currently I am traveling so I do not have direct access to this=
=20
host but I will test it ASAP.

> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
>
> diff -urN --exclude-from=3D/usr/src/diff.exclude linux-2.6.23-rc4-orig/ne=
t/netfilter/nf_conntrack_proto_tcp.c linux-2.6.23-rc4-tcp_win/net/netfilter=
/nf_conntrack_proto_tcp.c

Does this same error exist in 2.6.22?

BTW: what is your opinion about=20
net.netfilter.nf_conntrack_tcp_timeout_time_wait?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-116332602-1191441455=:5307--
