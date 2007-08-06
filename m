From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: fedora compilation problems [Fwd: Re: conntrack compile problem]
Date: Mon, 06 Aug 2007 10:09:15 +0200
Message-ID: <46B6D72B.9090205@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050303020001080800090505"
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050303020001080800090505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

I'm forwarding this to everyone since many people have reported
libnfnetlink, libnetfilter_contrack, et al. compilation problems at
configure stage that are related to the fedora setup. I hope that this
helps.

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.

--------------050303020001080800090505
Content-Type: message/rfc822;
 name="Re: conntrack compile problem"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: conntrack compile problem"

Return-Path: <szdobos@eastron.hu>
Received: from ganesha.gnumonks.org ([unix socket])
	by ganesha (Cyrus v2.1.18-IPv6-Debian-2.1.18-1+sarge2) with LMTP;
	Thu, 02 Aug 2007 16:38:31 +0200
X-Sieve: CMU Sieve 2.2
Return-path: <szdobos@eastron.hu>
Received: from vishnu.netfilter.org ([213.95.27.115])
	by ganesha.gnumonks.org with esmtps
	(TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32) (Exim 4.50) id 1IGbot-00037l-L6
	for pablo@imap.netfilter.org; Thu, 02 Aug 2007 16:38:31 +0200
Received: from [2001:780:45:f107:a00:20ff:feb3:606d] (helo=durga.netfilter.org)
	by vishnu.netfilter.org with esmtps (Exim 4.62 #1 (Debian))
	id 1IGcul-0000Y4-Rj
	for <pablo@imap.netfilter.org>; Thu, 02 Aug 2007 17:48:40 +0200
Received: from vishnu.netfilter.org ([2001:780:45:1d:20d:93ff:fe9b:e443])
	by durga.netfilter.org with esmtp (Exim 4.50) id 1IGXIL-0002Wp-4F
	for pablo@people.netfilter.org; Thu, 02 Aug 2007 11:48:37 +0200
Received: from smtp.eastron.hu ([195.38.123.122] helo=mail.eastron.hu)
	by vishnu.netfilter.org with esmtp (Exim 4.62 #1 (Debian))
	id 1IGcui-0000Xl-Gf
	for <pablo@netfilter.org>; Thu, 02 Aug 2007 17:48:39 +0200
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Subject: RE: conntrack compile problem
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 2 Aug 2007 16:38:08 +0200
Message-ID: <70CDA8AC42AB6545A5DC5FDB2446E13DA3C90F@liam.server.eastron.hu>
In-Reply-To: <46B1D039.706@netfilter.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: conntrack compile problem
Thread-Index: AcfVAd/MjPntRYmSQ8GWdzL0e9yFfgAA2xcw
References: <70CDA8AC42AB6545A5DC5FDB2446E13DA3C8B1@liam.server.eastron.hu>
	<46B08BFC.4070800@netfilter.org>
	<70CDA8AC42AB6545A5DC5FDB2446E13DA3C8F1@liam.server.eastron.hu>
	<46B1D039.706@netfilter.org>
From: =?iso-8859-1?Q?Dobos_Szil=E1rd?= <szdobos@eastron.hu>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
X-Spam-Score: -2.4 (--)
X-Spam-Score: -2.4 (--)
X-Spam-Score: 0.1 (/)
X-Spam-Report: SpamASsassin versoin 3.0.3 on ganesha.gnumonks.org summary:
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ----------------------
	--------------------------------------------------
	0.1 FORGED_RCVD_HELO       Received: contains a forged HELO
	0.1 TW_ZT                  BODY: Odd Letter Triples with ZT

[root@ucarp1 libnfnetlink-0.0.30]# pkg-config --exists --print-errors =
"libnfnetl                                              ink >=3D 0.0.25"
Package libnfnetlink was not found in the pkg-config search path.
Perhaps you should add the directory containing `libnfnetlink.pc'
to the PKG_CONFIG_PATH environment variable
No package 'libnfnetlink' found
[root@ucarp1 libnfnetlink-0.0.30]# echo $?
1
[root@ucarp1 libnfnetlink-0.0.30]# echo $PKG_CONFIG_PATH

[root@ucarp1 libnfnetlink-0.0.30]#
________________________________________________________________


Resolving problem:

PKG_CONFIG_PATH=3D/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH

./configure success!!=20

libnetfilter_conntrack-0.0.81 compiling -> OK.
conntrack-tools-0.9.5 compiling -> OK.

For conntrack-tools compile need: bison and flex package.

Thank You!!

Maybe you could put conntrack to the Fedora yum repository, solve many =
people  problems..:)


Bye, Sz.







-----Original Message-----
From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]=20
Sent: 2007. augusztus 2. 14:38
To: Dobos Szil=E1rd
Subject: Re: conntrack compile problem

Hi,

This fedora thing is weird. I don't have such problems running debian.

Dobos Szil=E1rd wrote:
>> checking pkg-config is at least version 0.9.0... yes
>>
>> checking for LIBNFNETLINK... no
>>
>> configure: error: Cannot find libnfnetlink >=3D 0.0.25

I extracted this from config.log:

configure:19860: $PKG_CONFIG --exists --print-errors "libnfnetlink >=3D
$LIBNFNETLINK_REQUIRED"
configure:19863: $? =3D 0

Could you run the following command?

pkg-config --exists --print-errors "libnfnetlink >=3D 0.0.25"

and echo $? to show the return value. Something must be wrong with
pkg-config.

--=20
"Ser=E1 preciso viajar a trav=E9s de los ojos de los idiotas" -- Poeta =
en
Nueva York -- Federico Garc=EDa Lorca.

--------------050303020001080800090505--
