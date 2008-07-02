From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCH 2/2] Netfilter: Accounting rework: ct_extend + 64bit
 counters (v3)
Date: Wed, 2 Jul 2008 15:46:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807021542420.4958@bizon.gios.gov.pl>
References: <485a3c49.C0A/tC0/U7AaZp3V%ole@ans.pl> <486114E9.9000809@trash.net>
 <Pine.LNX.4.64.0806241804340.24680@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0807021358370.4958@bizon.gios.gov.pl> <486B7D9C.4070501@trash.net>
 <Pine.LNX.4.64.0807021519330.4958@bizon.gios.gov.pl> <486B80F5.7050801@trash.net>
 <Pine.LNX.4.64.0807021522520.4958@bizon.gios.gov.pl> <486B853A.205@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1163509903-1215006414=:4958"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:46983 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYGBNq7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 09:46:59 -0400
In-Reply-To: <486B853A.205@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1163509903-1215006414=:4958
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 2 Jul 2008, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> (...)
>> bool nf_ct_acct __read_mostly =3D NF_CT_ACCT_DEFAULT;
>> (...)
>> module_param_named(acct, nf_ct_acct, bool, 0644);        <- line 28
>> (...)
>>=20
>> net/netfilter/nf_conntrack_acct.c: In function '__check_acct':
>> net/netfilter/nf_conntrack_acct.c:28: warning: return from incompatible=
=20
>> pointer type
>
> Seems you're the first to try module_param_named with a bool :)
> Does this help?

It helps but produces a lot of warnings in other places:

kernel/printk.c: In function '__check_time':
kernel/printk.c:570: warning: return from incompatible pointer type

arch/x86/kernel/cpu/mtrr/generic.c: In function '__check_show':
arch/x86/kernel/cpu/mtrr/generic.c:46: warning: return from incompatible po=
inter type

kernel/irq/spurious.c: In function '__check_noirqdebug':
kernel/irq/spurious.c:230: warning: return from incompatible pointer type

(...)

How about keeping it int currently and then issuing a cleanup patch that=20
touches all variables used in module_param/module_param_named(..., bool, ..=
=2E)?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1163509903-1215006414=:4958--
