From: Lockenvitz Jan EXT <Jan.Lockenvitz.extern@icn.siemens.de>
Subject: AW: TCP window tracking has bad side effects
Date: Wed, 1 Dec 2004 13:33:30 +0100
Message-ID: <47D438A0510BD611B9470002A58EDAE706B3B51F@mchh2a6e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

i recently saw the same problem on a Checkpoint FW. The problem there=20
was the blocked SYN packet.=20
The packet was blocked because it had the same Src-IP:src-port and=20
Dst-IP:dst-port than the old connection in the state table. So the
SYN never reached the other box and no ACK packet (with old sequence =
and=20
ack-nr) was send and of course no RST.

I don't know, what way netfilter is working. Should it block this SYN =
or
should it pass?=20

regards,
Jan

> -----Urspr=FCngliche Nachricht-----
> Von: netfilter-devel-bounces@lists.netfilter.org=20
> [mailto:netfilter-devel-bounces@lists.netfilter.org] Im=20
> Auftrag von Jozsef Kadlecsik
> Gesendet: Mittwoch, 1. Dezember 2004 13:17
> An: Ludwig Nussel
> Cc: netfilter-devel@lists.netfilter.org
> Betreff: Re: TCP window tracking has bad side effects
>=20
>=20
> Hi,
>=20
> On Wed, 1 Dec 2004, Ludwig Nussel wrote:
>=20
> > Recent state matching code apparently added some kind of TCP window
> > tracking which marks out of sequence packets as INVALID.
> >
> > Previously one could use some minimal filter rules like this on a
> > client machine:
> >
> > iptables -F
> > iptables -X
> > iptables -P INPUT DROP
> > iptables -P FORWARD DROP
> > iptables -P OUTPUT ACCEPT
> > iptables -A INPUT -j ACCEPT -i lo
> > iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED,RELATED
> >
> >
> > With TCP window tracking those rules no longer work for services
> > that use fixed ports (e.g. NFS) and one side crashes or terminates
> > the connection in other ways without notifying the peer (e.g. link
> > down). When the crashed machine comes up again and tries to
> > reestablish the connection it sends a SYN. The remote end finds =
that
> > confusing and replies with an ACK as probe. Since that ACK does not
> > fit any window it's discarded as INVALID.
>=20
> The remote end must send an ACK segment which is in the window (see
> RFC793, p68), thus the window tracking code could let it through.
>=20
> > The remote side can now
> > sit there forever sending ACKs and no new connection can be
> > established. Previously, without window tracking, the ACK was
> > accepted and answered with RST, the remote closed the connection =
and
> > a new one could be established.
> >
> > Is there a way to disable the window tracking and revert to the old
> > behavior?
>=20
> Yes, you can disable it anytime:
>=20
> echo 1 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal
>=20
> But a full tcpdump from such a session and the log entries on the
> invalid packets would be useful for us to recheck the code.
>=20
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
>=20
