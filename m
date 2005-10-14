From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: IPSec and Netfilter
Date: Fri, 14 Oct 2005 00:08:32 -0500
Message-ID: <365871C49598504A9481DDBEC3EB49551233B4@MAIL.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Jerry Alexander" <jerrya@airmail.net>,
	<netfilter-devel@lists.netfilter.org>, "Jerry" <jerry@mavenir.com>
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

I will take a stab at it.  Not sure if this belongs in the developer
forum or not, but what do I know?

In the 2.4 kernels, you build a custom kernel with the Free S/WAN or
Strongswan stuff.  When you fire up ipsec, you create this pseudo device
called ipsec0.  (Really, ipsec"n", where "n" is some number that's
generally 0 unless you say otherwise.)  And then there's an ipsec.conf
file where you define all your tunnels and parameters.  See
http://www.strongsec.org for documentation. =20

Anyway, now you have this ipsec virtual device, you can define iptables
rules as you see fit. =20

You can also define iptables rules around any or all of the ipsec
protocols (AH, ESP, UDP 500) against the real interfaces. =20

I haven't done this yet with a 2.6 kernel but my reading suggests the
ipsec stuff is built right into the mainline kernel now and all we need
are the user apps to manage encryption, tunnels, etc.

So is netfilter above or below ipsec?  I guess you could say netfilter
is more like a peer with ipsec.  You can apply iptables rules to the
virtual ipsec interfaces, or to the physical interfaces.  So instead of
one being "above" the other, I think of them in parallel. =20

- Greg Scott


-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Jerry
Alexander
Sent: Thursday, October 13, 2005 4:40 PM
To: netfilter-devel@lists.netfilter.org; Jerry
Subject: IPSec and Netfilter

Dear NF devel:

         Have just currently  written a user library to implement
iptables filter and NAT commands.
         Also have written a kernel module that hooks into the PREROUTE
hook to intercept packets and collect stats on the IP packet addresses
that have been entered into iptables.
         Manager just came by and asked me if  Netfilter is above or
below where IPSEC
resides.    Only know the minimal about IPSEC at this time.  I believe=20
his concern is
that  say in tunnel mode,  an IPSEC IP header is built and the contents
are encrypted and if Netfilter is below  IPSEC  routing and statistics
gathering won't work.
         From browsing the internet,  it appears with the correct
"iptables NAT command"
that the packet routing will occur correctly.
         I also assume that  when I try to read the packets at the
PREROUTE point that it will be the decrypted packet and my statistics
gathering will work.
        So far the documentation I have found is not clear on this.
        Could someone knowledgeable in this area please clearify.

=20
Thanks,
=20

Jerry
