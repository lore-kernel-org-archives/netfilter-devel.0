From: "Michael Lawson (mshindo)" <michael@sphinix.com>
Subject: Fwd: Modifying TCP packets with libnetfilter_queue
Date: Thu, 27 Aug 2009 16:16:41 +1200
Message-ID: <c97a47b90908262116q61d4a77fif52cb49880a4d3d1@mail.gmail.com>
References: <c97a47b90908262115l1dc29b78q7c02661b64af8cd9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36010 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZH0ERA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2009 00:17:00 -0400
Received: by ewy2 with SMTP id 2so829177ewy.17
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2009 21:17:01 -0700 (PDT)
In-Reply-To: <c97a47b90908262115l1dc29b78q7c02661b64af8cd9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I am attempting to adjust contents of tcp packets using the nf queue
system, the queue part is working as I expected, however I am running
into problems recalculating the tcp checksum. At the moment, the
packet isnt being changed, and I am simply reading the checksum, then
trying to regenerate it, these values arent matching and I am at a
loss as to where I am going wrong.

Here is the checksum code at the moment:
struct tcp_pseudo /*the tcp pseudo header*/
{
=A0=A0=A0 =A0 __u32 src_addr;
=A0=A0=A0 =A0 __u32 dst_addr;
=A0=A0=A0 =A0 __u8 zero;
=A0=A0=A0 =A0 __u8 proto;
=A0=A0=A0 =A0 __u16 length;
}pseudohead;


long checksum(unsigned short *addr, unsigned int count) {
=A0=A0=A0 register long sum =3D 0;
=A0=A0=A0 while( count > 1 )=A0 {
=A0=A0=A0 /*=A0 This is the inner loop */
=A0=A0=A0 =A0=A0=A0 sum +=3D * addr++;
=A0=A0=A0 =A0=A0=A0 count -=3D 2;
=A0=A0=A0 }

=A0=A0=A0 /*=A0 Add left-over byte, if any */
=A0=A0=A0 if( count > 0 )
=A0=A0=A0 =A0=A0=A0 sum +=3D * (unsigned char *) addr;

=A0=A0=A0 /*=A0 Fold 32-bit sum to 16 bits */
=A0=A0=A0 while (sum>>16)
=A0=A0=A0 =A0=A0=A0 sum =3D (sum & 0xffff) + (sum >> 16);

=A0=A0=A0 return ~sum;
}

long get_tcp_checksum(struct iphdr * myip, struct tcphdr * mytcp) {
=A0=A0=A0 mytcp->check =3D 0;

=A0=A0=A0 u16 total_len =3D ntohs(myip->tot_len);
=A0=A0=A0 int tcpopt_len =3D mytcp->doff*4 - 20;
=A0=A0=A0 int tcpdatalen =3D total_len - (mytcp->doff*4) - (myip->ihl*4=
);

=A0=A0=A0 /*Setup the pseudo header*/
=A0=A0=A0 pseudohead.src_addr=3Dmyip->saddr;
=A0=A0=A0 pseudohead.dst_addr=3Dmyip->daddr;
=A0=A0=A0 pseudohead.zero=3D0;
=A0=A0=A0 pseudohead.proto=3DIPPROTO_TCP;
=A0=A0=A0 pseudohead.length=3Dhtons(sizeof(struct tcphdr) + tcpopt_len =
+ tcpdatalen);

=A0=A0=A0 /*Calc lengths*/
=A0=A0=A0 int totaltcp_len =3D sizeof(struct tcp_pseudo) + sizeof(struc=
t
tcphdr) + tcpopt_len + tcpdatalen;
=A0=A0=A0 unsigned short * tcp =3D new unsigned short[totaltcp_len];

=A0=A0=A0 /*Copy to required mem*/
=A0=A0=A0 memcpy((unsigned char *)tcp,&pseudohead,sizeof(struct tcp_pse=
udo));
=A0=A0=A0 memcpy((unsigned char *)tcp+sizeof(struct tcp_pseudo),(unsign=
ed
char *)mytcp,sizeof(struct tcphdr));

=A0=A0=A0 if(tcpopt_len > 0)
=A0=A0=A0 =A0=A0=A0 memcpy((unsigned char *)tcp+sizeof(struct
tcp_pseudo)+sizeof(struct tcphdr), (unsigned char
*)myip+(myip->ihl*4)+(sizeof(struct tcphdr)), tcpopt_len);

=A0=A0=A0 if(tcpdatalen > 0)
=A0=A0=A0 =A0=A0=A0 memcpy((unsigned char *)tcp+sizeof(struct
tcp_pseudo)+sizeof(struct tcphdr), (unsigned char
*)mytcp+(mytcp->doff*4), tcpdatalen);

//=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 memcpy((unsigned char *)tcp+sizeof(stru=
ct
tcp_pseudo)+sizeof(struct tcphdr)+tcpopt_len, (unsigned char
*)mytcp+(mytcp->doff*4), tcpdatalen);

=A0=A0=A0 return checksum(tcp, totaltcp_len);
}

and the whole file, although not much bigger is here:
http://pastebin.com/m2bc636ed

An example of the output values I am getting at the moment is:
=A0packet size =3D 529 ip->checksum =3D 22679 tcp->checksum =3D 14964 n=
ew
ip->checksum =3D 22679 new tcp->checksum =3D 8007
=A0packet size =3D 52 ip->checksum =3D 13465 tcp->checksum =3D 8007 new
ip->checksum =3D 13465 new tcp->checksum =3D 31444
=A0packet size =3D 52 ip->checksum =3D 13209 tcp->checksum =3D 31444 ne=
w
ip->checksum =3D 13209 new tcp->checksum =3D 50105
=A0packet size =3D 52 ip->checksum =3D 12953 tcp->checksum =3D 50105 ne=
w
ip->checksum =3D 12953 new tcp->checksum =3D 12783

Any help or suggestions please? I am at a loss

--
Michael Lawson (mshindo)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
