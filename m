From: "Michael Lawson (mshindo)" <michael@sphinix.com>
Subject: Fwd: Modifying TCP packets with libnetfilter_queue
Date: Fri, 28 Aug 2009 14:09:46 +1200
Message-ID: <c97a47b90908271909s74161405ib542aa1080a9c833@mail.gmail.com>
References: <c97a47b90908262115l1dc29b78q7c02661b64af8cd9@mail.gmail.com>
	<c97a47b90908262116q61d4a77fif52cb49880a4d3d1@mail.gmail.com>
	<804829123.20090827093410@yandex.ru> <c97a47b90908271909l5849517bp729022d4cdd7cb6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:33410 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZH1CKJ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Aug 2009 22:10:09 -0400
Received: by ey-out-2122.google.com with SMTP id 25so360619eya.19
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2009 19:10:09 -0700 (PDT)
In-Reply-To: <c97a47b90908271909l5849517bp729022d4cdd7cb6f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the pointers, am still having problems sadly.

Does it matter where I intercept the packets? As a dev system, I have
been using a rule like: iptables -t filter -I OUTPUT -s ipaddress -j
QUEUE

This rule certainly picks up the packets, interestingly enough the
checksum is equal to zero, which according to the rfc is correct, this
I think is where my problem is coming from. Should I be queuing direct
from the wire? am wondering if the linux tcp/ip stack is playing games
with me ^_^

On Thu, Aug 27, 2009 at 5:34 PM, Kuzin Andrey<kuzinandrey@yandex.ru> wr=
ote:
> MLm> Hi,
> MLm> I am attempting to adjust contents of tcp packets using the nf q=
ueue
> MLm> system, the queue part is working as I expected, however I am ru=
nning
> MLm> into problems recalculating the tcp checksum. At the moment, the
> MLm> packet isnt being changed, and I am simply reading the checksum,=
 then
> MLm> trying to regenerate it, these values arent matching and I am at=
 a
> MLm> loss as to where I am going wrong.
> MLm> Any help or suggestions please? I am at a loss
>
> Try this code stolen from tcpdump and other cool stuff.
>
> /*
> =A0* IP header checksum.
> =A0* don't modifiy the packet.
> =A0*/
> u_short
> in_cksum(const u_short *addr, register u_int len, int csum)
> {
> =A0 =A0 =A0 =A0int nleft =3D len;
> =A0 =A0 =A0 =A0const u_short *w =3D addr;
> =A0 =A0 =A0 =A0u_short answer;
> =A0 =A0 =A0 =A0int sum =3D csum;
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * =A0Our algorithm is simple, using a 32 bit accumula=
tor (sum),
> =A0 =A0 =A0 =A0 * =A0we add sequential 16 bit words to it, and at the=
 end, fold
> =A0 =A0 =A0 =A0 * =A0back all the carry bits from the top 16 bits int=
o the lower
> =A0 =A0 =A0 =A0 * =A016 bits.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0while (nleft > 1) =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sum +=3D *w++;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nleft -=3D 2;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (nleft =3D=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sum +=3D htons(*(u_char *)w<<8);
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * add back carry outs from top 16 bits to low 16 bits
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0sum =3D (sum >> 16) + (sum & 0xffff); =A0 =A0 /* add h=
i 16 to low 16 */
> =A0 =A0 =A0 =A0sum +=3D (sum >> 16); =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 /* add carry */
> =A0 =A0 =A0 =A0answer =3D ~sum; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0/* truncate to 16 bits */
> =A0 =A0 =A0 =A0return (answer);
> }
>
> static int tcp_cksum(register const struct ip *ip,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 register const struct tcphdr =
*tp,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 register u_int len)
> {
> =A0 =A0 =A0 =A0union phu {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct phdr {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u_int32_t src;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u_int32_t dst;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u_char mbz;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u_char proto;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u_int16_t len;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} ph;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u_int16_t pa[6];
> =A0 =A0 =A0 =A0} phu;
> =A0 =A0 =A0 =A0const u_int16_t *sp;
>
> =A0 =A0 =A0 =A0/* pseudo-header.. */
> =A0 =A0 =A0 =A0phu.ph.len =3D htons((u_int16_t)len);
> =A0 =A0 =A0 =A0phu.ph.mbz =3D 0;
> =A0 =A0 =A0 =A0phu.ph.proto =3D IPPROTO_TCP;
> =A0 =A0 =A0 =A0memcpy(&phu.ph.src, &ip->ip_src.s_addr, sizeof(u_int32=
_t));
> =A0 =A0 =A0 =A0if ( (ip->ip_hl & 0x0f) =3D=3D 5)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(&phu.ph.dst, &ip->ip_dst.s_addr=
, sizeof(u_int32_t));
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0phu.ph.dst =3D ip_finddst(ip);
>
> =A0 =A0 =A0 =A0sp =3D &phu.pa[0];
> =A0 =A0 =A0 =A0return in_cksum((u_short *)tp, len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sp[0]+sp[1]+sp[2]+sp[3=
]+sp[4]+sp[5]);
> }
>
>
> void recalculate_tcp_checksum(unsigned char *packet)
> {
> =A0 =A0struct ip *ip_packet =3D NULL;
> =A0 =A0struct tcphdr *tcp_packet =3D NULL;
> =A0 =A0u_int16_t word16, padd =3D 0, i, sum =3D 0, tcp_len;
> =A0 =A0unsigned char *buff;
> =A0 =A0if (!packet) return;
>
> =A0 =A0ip_packet =3D (struct ip *)packet;
> =A0 =A0tcp_packet =3D (struct tcphdr *)(packet + (ip_packet->ip_hl <<=
 2));
> =A0 =A0tcp_len =3D ntohs(ip_packet->ip_len) - (ip_packet->ip_hl << 2)=
;
>
> =A0 =A0sum =3D tcp_cksum(ip_packet,tcp_packet,tcp_len);
> =A0 =A0tcp_packet->check =3D sum; //ntohs(sum);
> }
>
>
> Use recalculate_tcp_checksum() on your modified payload in this way:
>
>
> =A0 =A0void *packet;
> =A0 =A0struct ip *ip_packet =3D NULL;
> =A0 =A0struct tcphdr *tcp_packet =3D NULL;
> =A0 =A0unsigned char *tcp_packet_content =3D NULL;
>
> .......
> =A0 =A0ip_packet =3D ((struct ip *)packet);
>
> =A0 =A0if (ip_packet->ip_p =3D=3D IPPROTO_TCP) {
> =A0 =A0 =A0 =A0tcp_packet =3D (struct tcphdr *)(packet + sizeof(struc=
t ip));
> =A0 =A0 =A0 =A0tcp_packet_content =3D (unsigned char *)(packet + size=
of(struct ip) + sizeof(struct tcphdr));
> =A0 =A0 =A0 =A0tcp_packet_content_size =3D htons(ip_packet->ip_len) -=
 sizeof(struct ip) - sizeof(struct tcphdr);
> =A0 =A0 =A0 =A0.......
> =A0 =A0 =A0 =A0// modify payload...
> =A0 =A0 =A0 =A0.......
> =A0 =A0 =A0 =A0// calculate
> =A0 =A0 =A0 =A0tcp_packet->check =3D 0;
> =A0 =A0 =A0 =A0recalculate_tcp_checksum(packet);
> =A0 }
>
> You also can move some of this code to recalculate_tcp_checksum() and
> simply call recalculate_tcp_checksum() without any payload preparatio=
ns.
>
> =3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D
> Kuzin Andrey =A0- =A0kuzinandrey@yandex.ru
> =3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D
>
>
>
>



--
Michael Lawson (mshindo)



--=20
Michael Lawson (mshindo)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
