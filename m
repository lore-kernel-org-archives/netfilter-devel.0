From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: RE: LAND check: 2.4.20
Date: Mon, 14 Mar 2005 20:22:58 -0800
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B26A263D@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Content-class: urn:content-classes:message
To: "Martijn Lievaart" <m@rtij.nl>
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

Hi Martin/ folks,

Thanks. That was a lot of help. Can you point me to the code where the
checks have been made?

There is another issue I found. There are checks in the TCP code to see
if any of the reserved flags are set. However reserved flags do not seem
to take care of the NS flag (similar to ECE and CWR) which was
introduced some time back.

Would we want changes for the same in the kernel?

Thanks,
Vishwas
-----Original Message-----
From: Martijn Lievaart [mailto:m@rtij.nl]=20
Sent: Monday, March 14, 2005 8:21 PM
To: Vishwas Manral
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: LAND check: 2.4.20

Vishwas Manral said:
> Hi folks,
>
> I found no check in the iptables module for LAND attack source
> port/ipAddr =3D=3D destination port/ipAddr.
> http://www.cert.org/advisories/CA-1997-28.html
>
> Would we want to add that in ipt_unclean.c in the functions check_tcp
> and check_udp?

IMO, your anti spoofing rules should catch this.

M4
