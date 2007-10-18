From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [NETFILTER 01/02]: nf_conntrack_tcp: fix connection reopening
 fix
Date: Thu, 18 Oct 2007 12:26:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710181223310.17074@bizon.gios.gov.pl>
References: <20071018101159.28424.36079.sendpatchset@localhost.localdomain>
 <20071018101200.28424.26306.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-706978617-1192703198=:17074"
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:40418 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbXJRK0u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 06:26:50 -0400
In-Reply-To: <20071018101200.28424.26306.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-706978617-1192703198=:17074
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 18 Oct 2007, Patrick McHardy wrote:

> [NETFILTER]: nf_conntrack_tcp: fix connection reopening fix
>
> Setting the last_dir parameter was missing from the previous one.

This description is IMHO wrong. It should be as in previous, little=20
incomplete (last_dir), patch:

"If one side aborts an established connection, the entry still lingers for
10s in conntrack for the late packets. Allow to open up the connection
again for the party which sent the RST packet."

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-706978617-1192703198=:17074--
