From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [ANNOUNCE] Release conntrack-tools 0.9.6
Date: Sun, 9 Mar 2008 20:37:08 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803092035380.24925@bizon.gios.gov.pl>
References: <47D28F29.6080707@netfilter.org> <Pine.LNX.4.64.0803092018460.24925@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2049608702-1205091428=:24925"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:59403 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYCIThN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:37:13 -0400
In-Reply-To: <Pine.LNX.4.64.0803092018460.24925@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2049608702-1205091428=:24925
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sun, 9 Mar 2008, Krzysztof Oledzki wrote:

>
>
> On Sat, 8 Mar 2008, Pablo Neira Ayuso wrote:
>
>> Hi!
> Hi,
>
>> The netfilter project proudly presents another development release of
>> the conntrack-tools. This release includes important improvements, new
>> features and bugfixes:
>
> <CUT>
>
> I attached two patches to fix two warnings about shadowed declarations.
>
> BTW: It seems there is somethig wrong with --dst-nat/--src-nat filtering:
>
> # conntrack -L --src-nat|wc -l;conntrack -L --src-nat=3D1.2.3.4|wc -l;con=
ntrack=20
> -L --src-nat=3D244.244.244.244|wc -l
> 5010
> 5010
> 5010
>
> If I understand it properly "conntrack -L --src-nat=3DA.B.C.D" is suppose=
d to=20
> show only connections snated to A.B.C.D, but as you can see it ignores th=
is=20
> parameter and shows all snated connections.
>
> From the other hand --dst-nat works in exactly opposite way: it filters o=
ut=20
> all connections, even matching ones.

Small update: "--dst-nat A.B.C.D" instead of "--dst-nat=3DA.B.C.D" works=20
exactly like --src-nat (shows everything).

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-2049608702-1205091428=:24925--
