From: "Zhiyun Qian" <zhiyunq@umich.edu>
Subject: RE: Modifying TCP packets with libnetfilter_queue
Date: Fri, 28 Aug 2009 15:53:07 -0400
Message-ID: <005e01ca2819$2a1e1b30$e76ed48d@zhiyunpc>
References: <c97a47b90908262115l1dc29b78q7c02661b64af8cd9@mail.gmail.com> <c97a47b90908262116q61d4a77fif52cb49880a4d3d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "'Michael Lawson \(mshindo\)'" <michael@sphinix.com>,
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.mail.umich.edu ([141.211.14.81]:41053 "EHLO
	hackers.mr.itd.umich.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZH1TxK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2009 15:53:10 -0400
In-Reply-To: <c97a47b90908262116q61d4a77fif52cb49880a4d3d1@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Have you solved your problem? I've run into the same problem before and=
 then even if I successfully set the TCP checksum. The packet cannot be=
 delivered.=20

More specifically, I can queue the packets as expected but after I rewr=
ite the packet and generate the correct checksum at both IP and TCP hea=
der, and when I try re-injecting the packets into the network, it just =
never get sent out according to TCPDUMP. I've posted my question here b=
efore but no one answers... I am guess you might also encounter the sam=
e problem. If you can let me know if you have made any progress, that'l=
l be great.

-Zhiyun
-----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
=E5=8F=91=E4=BB=B6=E4=BA=BA: netfilter-devel-owner@vger.kernel.org [mai=
lto:netfilter-devel-owner@vger.kernel.org] =E4=BB=A3=E8=A1=A8 Michael L=
awson (mshindo)
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: Thursday, August 27, 2009 12:17 A=
M
=E6=94=B6=E4=BB=B6=E4=BA=BA: netfilter-devel@vger.kernel.org
=E4=B8=BB=E9=A2=98: Fwd: Modifying TCP packets with libnetfilter_queue

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
      __u32 src_addr;
      __u32 dst_addr;
      __u8 zero;
      __u8 proto;
      __u16 length;
}pseudohead;


long checksum(unsigned short *addr, unsigned int count) {
    register long sum =3D 0;
    while( count > 1 )  {
    /*  This is the inner loop */
        sum +=3D * addr++;
        count -=3D 2;
    }

    /*  Add left-over byte, if any */
    if( count > 0 )
        sum +=3D * (unsigned char *) addr;

    /*  Fold 32-bit sum to 16 bits */
    while (sum>>16)
        sum =3D (sum & 0xffff) + (sum >> 16);

    return ~sum;
}

long get_tcp_checksum(struct iphdr * myip, struct tcphdr * mytcp) {
    mytcp->check =3D 0;

    u16 total_len =3D ntohs(myip->tot_len);
    int tcpopt_len =3D mytcp->doff*4 - 20;
    int tcpdatalen =3D total_len - (mytcp->doff*4) - (myip->ihl*4);

    /*Setup the pseudo header*/
    pseudohead.src_addr=3Dmyip->saddr;
    pseudohead.dst_addr=3Dmyip->daddr;
    pseudohead.zero=3D0;
    pseudohead.proto=3DIPPROTO_TCP;
    pseudohead.length=3Dhtons(sizeof(struct tcphdr) + tcpopt_len + tcpd=
atalen);

    /*Calc lengths*/
    int totaltcp_len =3D sizeof(struct tcp_pseudo) + sizeof(struct
tcphdr) + tcpopt_len + tcpdatalen;
    unsigned short * tcp =3D new unsigned short[totaltcp_len];

    /*Copy to required mem*/
    memcpy((unsigned char *)tcp,&pseudohead,sizeof(struct tcp_pseudo));
    memcpy((unsigned char *)tcp+sizeof(struct tcp_pseudo),(unsigned
char *)mytcp,sizeof(struct tcphdr));

    if(tcpopt_len > 0)
        memcpy((unsigned char *)tcp+sizeof(struct
tcp_pseudo)+sizeof(struct tcphdr), (unsigned char
*)myip+(myip->ihl*4)+(sizeof(struct tcphdr)), tcpopt_len);

    if(tcpdatalen > 0)
        memcpy((unsigned char *)tcp+sizeof(struct
tcp_pseudo)+sizeof(struct tcphdr), (unsigned char
*)mytcp+(mytcp->doff*4), tcpdatalen);

//            memcpy((unsigned char *)tcp+sizeof(struct
tcp_pseudo)+sizeof(struct tcphdr)+tcpopt_len, (unsigned char
*)mytcp+(mytcp->doff*4), tcpdatalen);

    return checksum(tcp, totaltcp_len);
}

and the whole file, although not much bigger is here:
http://pastebin.com/m2bc636ed

An example of the output values I am getting at the moment is:
 packet size =3D 529 ip->checksum =3D 22679 tcp->checksum =3D 14964 new
ip->checksum =3D 22679 new tcp->checksum =3D 8007
 packet size =3D 52 ip->checksum =3D 13465 tcp->checksum =3D 8007 new
ip->checksum =3D 13465 new tcp->checksum =3D 31444
 packet size =3D 52 ip->checksum =3D 13209 tcp->checksum =3D 31444 new
ip->checksum =3D 13209 new tcp->checksum =3D 50105
 packet size =3D 52 ip->checksum =3D 12953 tcp->checksum =3D 50105 new
ip->checksum =3D 12953 new tcp->checksum =3D 12783

Any help or suggestions please? I am at a loss

--
Michael Lawson (mshindo)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
