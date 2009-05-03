From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Re: -p udp marking tcp packets ?
Date: Sat, 2 May 2009 21:46:39 -0300
Message-ID: <beb91d720905021746n36dc3fdco90d9035021a6ac61@mail.gmail.com>
References: <beb91d720905012257h51bcb936v3326c13bd57e707e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:13231 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbZECAqy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2009 20:46:54 -0400
Received: by qw-out-2122.google.com with SMTP id 5so2527134qwd.37
        for <netfilter-devel@vger.kernel.org>; Sat, 02 May 2009 17:46:54 -0700 (PDT)
In-Reply-To: <beb91d720905012257h51bcb936v3326c13bd57e707e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 2, 2009 at 02:57, Salatiel Filho <salatiel.filho@gmail.com>=
 wrote:
> i was having a strange behaviour marking packets in a new and updated
> router with kernel 2.6.29 and iptables 1.4.3 using an old script ,
> while it worked just fine on an old router.
> Trying to debug i found out this:
>
> # iptables =A0-p udp -t mangle -A PREROUTING -m state --state NEW -j =
LOG
> # iptables -nvL PREROUTING -t mangle
> Chain PREROUTING (policy ACCEPT 1491 packets, 232K bytes)
> =A0pkts bytes target =A0 =A0 prot opt in =A0 =A0 out =A0 =A0 source
> destination
> =A0 34 =A05042 LOG =A0 =A0 =A0 =A0udp =A0-- =A0* =A0 =A0 =A0* =A0 =A0=
 =A0 0.0.0.0/0
> 0.0.0.0/0 =A0 =A0 =A0 =A0 =A0 state NEW LOG flags 0 level 4
>
> In the logs i can see: [Why are TCP packets being marked by that rule=
 ?]
>
> May =A02 02:54:01 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
> MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
> DST=3D208.67.222.222 LEN=3D61 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D37=
46 DF
> PROTO=3DUDP SPT=3D40824 DPT=3D53 LEN=3D41
> May =A02 02:54:01 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
> MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
> DST=3D74.125.45.18 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D6387=
0 DF
> PROTO=3DTCP SPT=3D55145 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D=
0
> May =A02 02:54:02 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
> MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
> DST=3D208.67.222.222 LEN=3D73 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D39=
64 DF
> PROTO=3DUDP SPT=3D50636 DPT=3D53 LEN=3D53
> May =A02 02:54:02 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
> MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
> DST=3D74.125.45.189 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D604=
02 DF
> PROTO=3DTCP SPT=3D41692 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D=
0
> May =A02 02:54:05 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
> MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
> DST=3D208.69.36.132 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D181=
84 DF
> PROTO=3DTCP SPT=3D43497 DPT=3D995 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D=
0
> May =A02 02:54:06 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
> MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
> DST=3D74.125.45.18 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D2765=
 DF PROTO=3DTCP
> SPT=3D47733 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D0
> May =A02 02:54:06 OpenWrt user.warn kernel: IN=3Dbr-lan OUT=3D
> MAC=3D00:1a:70:fe:62:5c:00:1c:c0:82:25:c8:08:00 SRC=3D192.168.1.141
> DST=3D74.125.45.18 LEN=3D60 TOS=3D0x00 PREC=3D0x00 TTL=3D64 ID=3D2828=
6 DF
> PROTO=3DTCP SPT=3D47734 DPT=3D443 WINDOW=3D5840 RES=3D0x00 SYN URGP=3D=
0
>
>
>
>
> --
>
> []'s
> Salatiel
>
> "O maior prazer do inteligente =E9 bancar o =A0idiota
> =A0 diante de um =A0idiota que banca o inteligente".
>

-p tcp is also matching against udp packets ...
Noone else having this behaviour ?

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
