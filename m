From: =?ISO-8859-1?Q?J=F8rn_Andre_Berntzen?= <jornandr@stud.ntnu.no>
Subject: libipq and QUEUE
Date: Thu, 31 Mar 2005 09:05:07 +0200
Message-ID: <424BA123.7080003@stud.ntnu.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi

I'm trying to write a redirect code that will change the destination=20
address
on specific packets using libipq and trying to avoid coding a=20
kernel-module.
 From reading the man page on libipq and the functions one should be able
to manipulate the packet, update the checksum and reinject the packet to=20
kernel.

Has anyone here done this successfully or am I on the wrong path?
Is it possible to change the destination address using the ipq library an=
d
the QUEUE target or does one have to make a module for doing this?

Any help is greatly appreciated.

Regards,
J=F8rn Andre
