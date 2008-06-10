From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [SPAM?] Re: conntrackd causes kernel panic
Date: Tue, 10 Jun 2008 19:01:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806101858080.12641@bizon.gios.gov.pl>
References: <200806101343.12607.sabelka@iue.tuwien.ac.at> <484E8FC8.4000402@trash.net>
 <200806101706.52341.sabelka@iue.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-39537897-1213117305=:12641"
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:51479 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYFJRCI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jun 2008 13:02:08 -0400
In-Reply-To: <200806101706.52341.sabelka@iue.tuwien.ac.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-39537897-1213117305=:12641
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 10 Jun 2008, Rainer Sabelka wrote:

> On Tuesday 10 June 2008 16:29, Patrick McHardy wrote:
>> Do these two patches help?
>
> Patrick, I tried to apply those patches to the Ubuntu kernel sources
> (2.6.24-18) but they failed, so I guess I should try to use a vanilla ker=
nel
> instead.
> Which version should I try?

Those patches are for nf-next-2.6. I have a backport of this patches for=20
2.6.24.x and 2.6.25.x kernels, but I need to make sure there were no=20
changes in the latest version.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-39537897-1213117305=:12641--
