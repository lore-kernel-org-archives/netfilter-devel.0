From: <anisha.chandrasekaran@wipro.com>
Subject: RE: Problem using connection tracking
Date: Wed, 25 Oct 2006 08:49:53 +0530
Message-ID: <2FEE63312285CF428A8480B07AC1C35903657F2E@CHN-SNR-MBX01.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <kaber@trash.net>,
	<mael.boutin@laposte.net>
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


Hello Patrick,
    The conntrack package might not have been built properly. That is
wen it says invalid parameters. I was trying to cross compile the
backage for arm architecture and it reported the same error for me.

But I tried with PC compilation it did work fine. If you are compiling
for i386 then,
1. Ensure the kernel in > 2.6.14 version.
2. run configure command with the proper kernel path specified.
3. Then run a make and make install.
4. 1-3 should be first done for libnfnetlink package, then for
libnetfilter-conntrack package and then for conntrack package. This
should be the order of build as the packages have some dependency with
each other.

If you have been following steps 1-4 then I guess the conntrack
executable must work.

=0D
 Regards,

Anisha Chandrasekaran
Email : anisha.chandrasekaran@wipro.com =0D
 =0D
        =0D

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of
Patrick McHardy
Sent: Monday, October 23, 2006 9:55 PM
To: mael.boutin
Cc: netfilter-devel
Subject: Re: Problem using connection tracking

mael.boutin wrote:
> Hi,
>=0D
> First excuse me for my poor english ...
>=0D
> I'm having problems using conntrack. Everything was ok while i
> was using the old ip_conntrack. However, now i need to use it
> with IPv6.
>=0D
> The problem i'm facing is with the new connection tracking
> system, i can't receive any conntrack events neither IPv4 nor
> IPv6.
>=0D
> Moreover, the conntrack application is not working :
> - conntrack -L returns invalid parameters
> - conntrack -E dumps nothing
>=0D
> I think it is a problem related with the configuration of the
> kernel (attached).
>=0D
> I'm using a 2.6.15.6 Linux Kernel and i can't go to a newer
> kernel.=0D

ctnetlink support for nf_conntrack was added in 2.6.16.




The information contained in this electronic message and any attachments to=
 this message are intended for the exclusive use of the addressee(s) and=
 may contain proprietary, confidential or privileged information. If you=
 are not the intended recipient, you should not disseminate, distribute or=
 copy this e-mail. Please notify the sender immediately and destroy all=
 copies of this message and any attachments.=0D

WARNING: Computer viruses can be transmitted via email. The recipient=
 should check this email and any attachments for the presence of viruses.=
 The company accepts no liability for any damage caused by any virus=
 transmitted by this email.
=0D
www.wipro.com
