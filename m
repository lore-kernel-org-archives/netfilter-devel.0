From: Khem Raj <raj.khem@gmail.com>
Subject: Re: [libnetfilter_queue][PATCH 2/2] Declare the define visivility
 attribute together
Date: Thu, 13 Apr 2017 18:31:34 -0700
Message-ID: <8d703d42-4e3b-1343-7e60-8df5884cc51c@gmail.com>
References: <20170410195804.18238-1-raj.khem@gmail.com>
 <20170410195804.18238-2-raj.khem@gmail.com> <20170413233719.GB8577@salvia>
 <20170413234911.GA9656@salvia>
 <7d497c66-5e61-8ba0-667b-1f1f3fed2460@gmail.com>
 <20170414013044.GA30760@salvia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qAE68n6FH3OEU2LEMbg92S5d8le1vmjn7"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:33042 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdDNBbm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 21:31:42 -0400
Received: by mail-pg0-f52.google.com with SMTP id x125so37881474pgb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 18:31:42 -0700 (PDT)
In-Reply-To: <20170414013044.GA30760@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qAE68n6FH3OEU2LEMbg92S5d8le1vmjn7
Content-Type: multipart/mixed; boundary="FvmhLGo0EF0O1ceDbBSbhkAadwFS0TlQJ";
 protected-headers="v1"
From: Khem Raj <raj.khem@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <8d703d42-4e3b-1343-7e60-8df5884cc51c@gmail.com>
Subject: Re: [libnetfilter_queue][PATCH 2/2] Declare the define visivility
 attribute together
References: <20170410195804.18238-1-raj.khem@gmail.com>
 <20170410195804.18238-2-raj.khem@gmail.com> <20170413233719.GB8577@salvia>
 <20170413234911.GA9656@salvia>
 <7d497c66-5e61-8ba0-667b-1f1f3fed2460@gmail.com>
 <20170414013044.GA30760@salvia>
In-Reply-To: <20170414013044.GA30760@salvia>

--FvmhLGo0EF0O1ceDbBSbhkAadwFS0TlQJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 4/13/17 6:30 PM, Pablo Neira Ayuso wrote:
> On Thu, Apr 13, 2017 at 06:22:54PM -0700, Khem Raj wrote:
>>> It would be good if you send me a patch for libnetfilter_queue that
>>> applies on top of you previous patch, or I can simply revert.
>>
>> I will send a patch which uses EXPORT_FUNCTION instead and declare it
>> before definition like libmnl
>>
>> I am fine with revert or patch on top, I can do both just let me know
>=20
> I have reverted it. Please follow up with a new patch. Thanks!
>=20

OK


--FvmhLGo0EF0O1ceDbBSbhkAadwFS0TlQJ--

--qAE68n6FH3OEU2LEMbg92S5d8le1vmjn7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iEYEARECAAYFAljwJnsACgkQuwUzVZGdMxR5pQCfRNcpbWQPErqcRr7WPKr6xIrE
WL4AoIQP7swMITiDai8vgnoJw+3Zjl9S
=QGr0
-----END PGP SIGNATURE-----

--qAE68n6FH3OEU2LEMbg92S5d8le1vmjn7--
