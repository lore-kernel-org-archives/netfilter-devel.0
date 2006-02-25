From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: New H.323 conntrack & NAT helper module
Date: Fri, 24 Feb 2006 22:00:04 -0600
Message-ID: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Jing Min Zhao" <zhaojingmin@hotmail.com>,
	<netfilter-devel@lists.netfilter.org>
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

Holey moley - this is GREAT news!!

A couple questions.  Will this module work with 2.6.16 and upcoming
newer kernels?  And - this is a biggie - the documentation says all I
need to do is SNAT TCP 1720 for outbound calls and DNAT TCP 1720 for
inbound calls.  No more tinkering by hand with zillions of TCP/UDP ports
- no more trying to figure out if Polycom or Tandberg or whatever is on
which end.  Is this really true???  Will this patch really figure out
and track the dynamic ports these devices use by default?  If so, then
HOT DOGGIES!!!! =20

Also - will it work with proxy ARP?  Let's say I proxy ARP an H.323
device behind the firewall.  Will this patch still handle connection
tracking, even though there is no NAT?  The idea is, I would put a rule
in the FORWARD table for TCP 1720 and the patch would "know" it's an
H.323 device and also track and forward the appropriate TCP and UDP
ports.  But it would be to a public IP Address proxy ARP'd behind the
firewall instead of a NAT'd device. =20

thanks

- Greg Scott


-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Jing
Min Zhao
Sent: Tuesday, February 21, 2006 11:57 PM
To: netfilter-devel@lists.netfilter.org
Subject: New H.323 conntrack & NAT helper module


Hi, all,

I've written a new H.323 conntrack & NAT helper module for Netfilter.

I have five years experience in H.323 development and many years in
Linux development, so I know many people out there need Linux firewall
to support H.323 as IP phones are becoming more and more popular. I also
know Jozsef Kadlecsik and Max Kellermann have written such Netfilter
modules, but they don't support RAS, Fast-Start and H.245 tunnelling.
However, these features are essential for most modern H.323 devices.
Many carriers even don't support slow-start at all.

This is a almost full featured H.323 module. Since it is based on H.225
version 4, H.235 version 2 and H.245 version 7, it should support most
of the H.323 products in the market. I've spent a lot of time on this
module and my friends helped me test it a lot too. Now I believe it is
ready to go into kernel tree. I'm wondering if anybody can tell me what
I should do to adding it to Netfilter.

Anybody interested in this can download the patch for kernel 2.6.15 in
http://sourceforge.net/project/showfiles.php?group_id=3D158936. The
document is at http://nath323.sourceforge.net.

Thanks a lot!

Jing Min Zhao
