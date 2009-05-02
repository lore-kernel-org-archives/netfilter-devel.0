From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: -p udp marking tcp packets ?
Date: Sat, 2 May 2009 02:57:08 -0300
Message-ID: <beb91d720905012257h51bcb936v3326c13bd57e707e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35163 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZEBF5Y convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2009 01:57:24 -0400
Received: by qyk34 with SMTP id 34so4000376qyk.33
        for <netfilter-devel@vger.kernel.org>; Fri, 01 May 2009 22:57:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

i was having a strange behaviour marking packets in a new and updated
router with kernel 2.6.29 and iptables 1.4.3 using an old script ,
while it worked just fine on an old router.
Trying to debug i found out this:

# iptables  -p udp -t mangle -A PREROUTING -m state --state NEW -j LOG
# iptables -nvL PREROUTING -t mangle
Chain PREROUTING (policy ACCEPT 1491 packets, 232K bytes)
 pkts bytes target     prot opt in     out     source
destination
   34  5042 LOG        udp  --  *      *       0.0.0.0/0
0.0.0.0/0           state NEW LOG flags 0 level 4

In the logs i can see: [Why are TCP packets being marked by that rule ?=
]

May  2 02:54:01 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
DST=3D208.67.222.222 LEN=3D61 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D3746=
 DF
PROTO=3DUDP SPT=3D40824 DPT=3D53 LEN=3D41
May  2 02:54:01 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
DST=3D74.125.45.18 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D63870 =
DF
PROTO=3DTCP SPT=3D55145 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0
May  2 02:54:02 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
DST=3D208.67.222.222 LEN=3D73 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D3964=
 DF
PROTO=3DUDP SPT=3D50636 DPT=3D53 LEN=3D53
May  2 02:54:02 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
DST=3D74.125.45.189 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D60402=
 DF
PROTO=3DTCP SPT=3D41692 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0
May  2 02:54:05 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
DST=3D208.69.36.132 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D18184=
 DF
PROTO=3DTCP SPT=3D43497 DPT=3D995 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0
May  2 02:54:06 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
DST=3D74.125.45.18 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D2765 D=
=46 PROTO=3DTCP
SPT=3D47733 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0
May  2 02:54:06 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
DST=3D74.125.45.18 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D28286 =
DF
PROTO=3DTCP SPT=3D47734 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0




--=20

[]'s
Salatiel

"O maior prazer do inteligente =E9 bancar o  idiota
   diante de um  idiota que banca o inteligente".
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
