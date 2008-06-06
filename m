From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [Bug 10875] Oops in nf_nat_setup_info
Date: Sat, 7 Jun 2008 00:47:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806070046360.12641@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-560210618-1212792472=:12641"
Cc: bugme-daemon@bugzilla.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:46994 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674AbYFFWsU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:48:20 -0400
In-Reply-To: <Pine.LNX.4.64.0806061931140.12641@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-560210618-1212792472=:12641
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 6 Jun 2008, Krzysztof Oledzki wrote:

> Hello,
>
> Today I have been plaing with the conntrackd utility and noticed it is ve=
ry=20
> easy to trigger a kernel oops just by:
>
> conntrackd -d
> conntrackd -n
> conntrackd -c
> conntrackd -c

OK, quite often is is enough to run only the first "conntrackd -c" to=20
crash the kernel.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-560210618-1212792472=:12641--
