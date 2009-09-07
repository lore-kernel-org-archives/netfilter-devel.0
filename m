From: "Michael Lawson (mshindo)" <michael@sphinix.com>
Subject: Re: Modifying TCP packets with libnetfilter_queue
Date: Mon, 7 Sep 2009 14:52:28 +1200
Message-ID: <c97a47b90909061952kaacdd2ama86f073855af87ed@mail.gmail.com>
References: <c97a47b90908262115l1dc29b78q7c02661b64af8cd9@mail.gmail.com>
	<c97a47b90908262116q61d4a77fif52cb49880a4d3d1@mail.gmail.com>
	<005e01ca2819$2a1e1b30$e76ed48d@zhiyunpc> <c97a47b90908281548t5b31fb36i374e53ca27693d69@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Zhiyun Qian <zhiyunq@umich.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55701 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbZIGCwr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Sep 2009 22:52:47 -0400
Received: by ewy2 with SMTP id 2so1749809ewy.17
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2009 19:52:48 -0700 (PDT)
In-Reply-To: <c97a47b90908281548t5b31fb36i374e53ca27693d69@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Still having problems modifying the packet destination, the packets
appear to be getting out onto the wire, however the host receiving
them sets the RST flag in the TCP payload, can anyone suggest a reason
as to why this might occur once I adjust the destination address?

Regards

On Sat, Aug 29, 2009 at 10:48 AM, Michael Lawson
(mshindo)<michael@sphinix.com> wrote:
> I have made some form of progress late last night, basically a core
> problem I found was in how I was getting struct tcphdr, once I fixed
> this after a bit if fiddling round and some dirty string manipulation
> I was able to match the checksums, so the packets get send out onto
> the wire.
>
> However this has led to another problem (perhaps the one you are
> referring to) that ethereal picks up, but tcpdump does not. Under
> SEQ/ACK Analysis, ethereal notes that the packets being transmitted
> are duplicate ACK's. This might simply require some dirty hacks to
> fix.
>
> The code so far is on: http://pastebin.org/13016
>
> Sadly, I have to jump a 5 hour train shortly, so not much work will b=
e
> done this afternoon.
>
> Regards
>
> On Sat, Aug 29, 2009 at 7:53 AM, Zhiyun Qian<zhiyunq@umich.edu> wrote=
:
>> Have you solved your problem? I've run into the same problem before =
and then even if I successfully set the TCP checksum. The packet cannot=
 be delivered.
>>
>> More specifically, I can queue the packets as expected but after I r=
ewrite the packet and generate the correct checksum at both IP and TCP =
header, and when I try re-injecting the packets into the network, it ju=
st never get sent out according to TCPDUMP. I've posted my question her=
e before but no one answers... I am guess you might also encounter the =
same problem. If you can let me know if you have made any progress, tha=
t'll be great.
>>
>> -Zhiyun
>> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
>> =E5=8F=91=E4=BB=B6=E4=BA=BA: netfilter-devel-owner@vger.kernel.org [=
mailto:netfilter-devel-owner@vger.kernel.org] =E4=BB=A3=E8=A1=A8 Michae=
l Lawson (mshindo)
>> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: Thursday, August 27, 2009 12:1=
7 AM
>> =E6=94=B6=E4=BB=B6=E4=BA=BA: netfilter-devel@vger.kernel.org
>> =E4=B8=BB=E9=A2=98: Fwd: Modifying TCP packets with libnetfilter_que=
ue
>>
>> Hi,
>> I am attempting to adjust contents of tcp packets using the nf queue
>> system, the queue part is working as I expected, however I am runnin=
g
>> into problems recalculating the tcp checksum. At the moment, the
>> packet isnt being changed, and I am simply reading the checksum, the=
n
>> trying to regenerate it, these values arent matching and I am at a
>> loss as to where I am going wrong.
>>
>> Here is the checksum code at the moment:
>> struct tcp_pseudo /*the tcp pseudo header*/
>> {
>> =C2=A0 =C2=A0 =C2=A0__u32 src_addr;
>> =C2=A0 =C2=A0 =C2=A0__u32 dst_addr;
>> =C2=A0 =C2=A0 =C2=A0__u8 zero;
>> =C2=A0 =C2=A0 =C2=A0__u8 proto;
>> =C2=A0 =C2=A0 =C2=A0__u16 length;
>> }pseudohead;
>>
>>
>> long checksum(unsigned short *addr, unsigned int count) {
>> =C2=A0 =C2=A0register long sum =3D 0;
>> =C2=A0 =C2=A0while( count > 1 ) =C2=A0{
>> =C2=A0 =C2=A0/* =C2=A0This is the inner loop */
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0sum +=3D * addr++;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0count -=3D 2;
>> =C2=A0 =C2=A0}
>>
>> =C2=A0 =C2=A0/* =C2=A0Add left-over byte, if any */
>> =C2=A0 =C2=A0if( count > 0 )
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0sum +=3D * (unsigned char *) addr;
>>
>> =C2=A0 =C2=A0/* =C2=A0Fold 32-bit sum to 16 bits */
>> =C2=A0 =C2=A0while (sum>>16)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0sum =3D (sum & 0xffff) + (sum >> 16);
>>
>> =C2=A0 =C2=A0return ~sum;
>> }
>>
>> long get_tcp_checksum(struct iphdr * myip, struct tcphdr * mytcp) {
>> =C2=A0 =C2=A0mytcp->check =3D 0;
>>
>> =C2=A0 =C2=A0u16 total_len =3D ntohs(myip->tot_len);
>> =C2=A0 =C2=A0int tcpopt_len =3D mytcp->doff*4 - 20;
>> =C2=A0 =C2=A0int tcpdatalen =3D total_len - (mytcp->doff*4) - (myip-=
>ihl*4);
>>
>> =C2=A0 =C2=A0/*Setup the pseudo header*/
>> =C2=A0 =C2=A0pseudohead.src_addr=3Dmyip->saddr;
>> =C2=A0 =C2=A0pseudohead.dst_addr=3Dmyip->daddr;
>> =C2=A0 =C2=A0pseudohead.zero=3D0;
>> =C2=A0 =C2=A0pseudohead.proto=3DIPPROTO_TCP;
>> =C2=A0 =C2=A0pseudohead.length=3Dhtons(sizeof(struct tcphdr) + tcpop=
t_len + tcpdatalen);
>>
>> =C2=A0 =C2=A0/*Calc lengths*/
>> =C2=A0 =C2=A0int totaltcp_len =3D sizeof(struct tcp_pseudo) + sizeof=
(struct
>> tcphdr) + tcpopt_len + tcpdatalen;
>> =C2=A0 =C2=A0unsigned short * tcp =3D new unsigned short[totaltcp_le=
n];
>>
>> =C2=A0 =C2=A0/*Copy to required mem*/
>> =C2=A0 =C2=A0memcpy((unsigned char *)tcp,&pseudohead,sizeof(struct t=
cp_pseudo));
>> =C2=A0 =C2=A0memcpy((unsigned char *)tcp+sizeof(struct tcp_pseudo),(=
unsigned
>> char *)mytcp,sizeof(struct tcphdr));
>>
>> =C2=A0 =C2=A0if(tcpopt_len > 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy((unsigned char *)tcp+sizeof(struct
>> tcp_pseudo)+sizeof(struct tcphdr), (unsigned char
>> *)myip+(myip->ihl*4)+(sizeof(struct tcphdr)), tcpopt_len);
>>
>> =C2=A0 =C2=A0if(tcpdatalen > 0)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy((unsigned char *)tcp+sizeof(struct
>> tcp_pseudo)+sizeof(struct tcphdr), (unsigned char
>> *)mytcp+(mytcp->doff*4), tcpdatalen);
>>
>> // =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy((unsigned char *)=
tcp+sizeof(struct
>> tcp_pseudo)+sizeof(struct tcphdr)+tcpopt_len, (unsigned char
>> *)mytcp+(mytcp->doff*4), tcpdatalen);
>>
>> =C2=A0 =C2=A0return checksum(tcp, totaltcp_len);
>> }
>>
>> and the whole file, although not much bigger is here:
>> http://pastebin.com/m2bc636ed
>>
>> An example of the output values I am getting at the moment is:
>> =C2=A0packet size =3D 529 ip->checksum =3D 22679 tcp->checksum =3D 1=
4964 new
>> ip->checksum =3D 22679 new tcp->checksum =3D 8007
>> =C2=A0packet size =3D 52 ip->checksum =3D 13465 tcp->checksum =3D 80=
07 new
>> ip->checksum =3D 13465 new tcp->checksum =3D 31444
>> =C2=A0packet size =3D 52 ip->checksum =3D 13209 tcp->checksum =3D 31=
444 new
>> ip->checksum =3D 13209 new tcp->checksum =3D 50105
>> =C2=A0packet size =3D 52 ip->checksum =3D 12953 tcp->checksum =3D 50=
105 new
>> ip->checksum =3D 12953 new tcp->checksum =3D 12783
>>
>> Any help or suggestions please? I am at a loss
>>
>> --
>> Michael Lawson (mshindo)
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-=
devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>>
>>
>>
>
>
>
> --
> Michael Lawson (mshindo)
>



--=20
Michael Lawson (mshindo)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
