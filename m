From: "Maarten Wijnants" <maarten.wijnants@pandora.be>
Subject: Re: libipq and QUEUE
Date: Thu, 31 Mar 2005 09:57:18 +0200
Message-ID: <001d01c535c7$4316aa10$642813ac@in.edm.luc.ac.be>
References: <424BA123.7080003@stud.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?J=F8rn_Andre_Berntzen?= <jornandr@stud.ntnu.no>,
	"Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
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

Hi Jorn,

It IS possible to change the destination address of a packet in userspace=
=20
using libipq and the QUEUE target. However, if you do this, it is my=20
experience NO rerouting will occur. For example, if you change a packet's=
=20
destination from X to Y using libipq and subsequently reinsert the packet=
 in=20
the kernel, the packet will still be delivered to machine X, although the=
=20
header of the packet will specify it is destined for machine Y! If you wa=
nt=20
rerouting to occur, I think you are better off with the NAT table (I myse=
lf=20
have no experience with this).

greetings,
Maarten

----- Original Message -----=20
From: "J=F8rn Andre Berntzen" <jornandr@stud.ntnu.no>
To: "Netfilter Development Mailinglist"=20
<netfilter-devel@lists.netfilter.org>
Sent: Thursday, March 31, 2005 9:05 AM
Subject: libipq and QUEUE


Hi

I'm trying to write a redirect code that will change the destination
address
on specific packets using libipq and trying to avoid coding a
kernel-module.
 From reading the man page on libipq and the functions one should be able
to manipulate the packet, update the checksum and reinject the packet to
kernel.

Has anyone here done this successfully or am I on the wrong path?
Is it possible to change the destination address using the ipq library an=
d
the QUEUE target or does one have to make a module for doing this?

Any help is greatly appreciated.

Regards,
J=F8rn Andre
