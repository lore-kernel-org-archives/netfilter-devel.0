From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 3 Oct 2007 15:06:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-648373348-1191416797=:5307"
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:33082 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbXJCNGp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:06:45 -0400
In-Reply-To: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-648373348-1191416797=:5307
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 26 Sep 2007, Krzysztof Oledzki wrote:

> Hello,
>
> Attached patch should fix missing space between "SYN" and "IN=3D".
>
> nf_ct_tcp: invalid SYNIN=3D OUT=3D SRC=3D192.168.150.16 DST=3D192.168.50.=
21 LEN=3D60=20
> TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D19810 DF PROTO=3DTCP SPT=3D43183 DPT=
=3D80=20
> SEQ=3D3917241971 ACK=3D0 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0 OPT=20
> (020405B40402080A3C14363B0000000001030307) UID=3D451
>
> 192.168.150.16 <- my local ip address
> 192.168.50.21  <- remote server
>
> My question is about this message. Apparently there is someting wrong wit=
h my=20
> configuration. I'm running http proxy/load balancer so my server makes _a=
=20
> lot_ of connections for/to the same address IP pair. I noticed that many =
of=20
> them were not successful. I know about TIMEWAIT issue, but as long there =
are=20
> enough free ports for current connection rate (in my situation it is abou=
t=20
> 100/s) it should not be a problem.
>
> So, with net.netfilter.nf_conntrack_log_invalid set to 255 I get:
>
> grep "invalid SYNIN" /var/log/syslog |wc -l
> 1186
>
> Could the problem be that default=20
> net.netfilter.nf_conntrack_tcp_timeout_time_wait is 120s by default, and=
=20
> TCP_TIMEWAIT_LEN is 60:
>
> /usr/src/linux/include/net/tcp.h:#define TCP_TIMEWAIT_LEN (60*HZ) /* how =
long=20
> to wait to destroy TIME-WAIT
>
> I tried to change net.netfilter.nf_conntrack_tcp_timeout_time_wait to 60 =
but=20
> this does not help much.

Small update to this issue. It seems that both ip stack and netfilter=20
indeed handle connections using different timers:

# wget --bind-address 192.168.0.1 192.168.129.28 -O /dev/null

--14:36:00--  http://192.168.129.28/
            =3D> `/dev/null'
Connecting to 192.168.129.28:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 915 [text/html]

100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>]=20
915           --.--K/s

14:36:00 (13.43 MB/s) - `/dev/null' saved [915/915]

# conntrack -L |grep =3D192.168.129.28|grep 192.168.0.1:
tcp      6 119 TIME_WAIT src=3D192.168.0.1 dst=3D192.168.129.28 sport=3D183=
00 dport=3D80 packets=3D6 bytes=3D422 src=3D192.168.129.28 dst=3D192.168.0.=
1 sport=3D80 dport=3D18300 packets=3D4 bytes=3D1475 [ASSURED] mark=3D0 use=
=3D1

# ss -anto |egrep "192.168.0.1.*192.168.129.28":
TIME-WAIT  0      0               192.168.0.1:18300       192.168.129.28:80=
     timer:(timewait,58sec,0)


After 60s kernel is able to reuse this (18300) port but it will be blocked=
=20
by local netfilter with this "invalid SYN" message. This is especially=20
more likely in newer kernels with tcp port randomization.

This does not solve my problem but it think we should consider changing=20
net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait from 120s to 60s.

I also wondering if the code from nf_conntrack_proto_tcp.c is correct:

--- cut here ---
new_state =3D tcp_conntracks[dir][index][old_state];

switch (new_state)
(...)
case TCP_CONNTRACK_SYN_SENT:
if (old_state < TCP_CONNTRACK_TIME_WAIT)
         break;
if ((conntrack->proto.tcp.seen[dir].flags &
         IP_CT_TCP_FLAG_CLOSE_INIT)
     || after(ntohl(th->seq),
              conntrack->proto.tcp.seen[dir].td_end)) {
         /* Attempt to reopen a closed connection.
         * Delete this connection and look up again. */
         write_unlock_bh(&tcp_lock);
         if (del_timer(&conntrack->timeout))
                 conntrack->timeout.function((unsigned long)
                                             conntrack);
         return -NF_REPEAT;
} else {
         write_unlock_bh(&tcp_lock);
         if (LOG_INVALID(IPPROTO_TCP))
                 nf_log_packet(pf, 0, skb, NULL, NULL,
                               NULL, "nf_ct_tcp: invalid SYN");
         return -NF_ACCEPT;
}
--- cut here ---

It seems that tcp_conntracks allows such (TCP_CONNTRACK_TIME_WAIT ->=20
TCP_CONNTRACK_SYN_SENT) transition, pointing to rfc1122:

When a connection is closed actively, it MUST linger in
TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
However, it MAY accept a new SYN from the remote TCP to
reopen the connection directly from TIME-WAIT state, if it:

(1)  assigns its initial sequence number for the new
      connection to be larger than the largest sequence
      number it used on the previous connection incarnation,
      and

(2)  returns to TIME-WAIT state if the SYN turns out to be
      an old duplicate.

So, it seems that this "after(...)" does not match this packet, right?

Patric, what do you think about this?

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-648373348-1191416797=:5307--
