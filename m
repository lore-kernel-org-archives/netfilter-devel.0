From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: Wrong ethernet headers after double postrouting fix
Date: Thu, 13 Dec 2007 09:05:10 +0100
Message-ID: <9a4a382a0712130005l49a72164r26e5818060534285@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:51836 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbXLMIFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:05:11 -0500
Received: by wa-out-1112.google.com with SMTP id v27so926703wah.23
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Dec 2007 00:05:10 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm using a nat-over-bridges setup with two bridges and I'm using
iptables to MASQUERADE over it.
I'm trying to use rtsp so I applied the rtsp conntrack/nat patch (to
the 2.6.23 kernel I'm using actually) [1]. But it doesn't work because
the nat seems to be done twice.
After some search, I found a patch [2] which should solve this problem
(bridge-to-bridge routing). So I applied it, but then I get wrong
packets on the output (see below).
I tried with 2.6.24-rc5 and the result is similar (the output below is
with 2.6.24-rc5).

[1] http://mike.it-loops.com/rtsp/rtsp-2.6.23.patch
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=81d9ddae856678c45297550e9353c8a5a7fd6438

(The captures were taken with tcpdump and displayed with wireshark,
tell me if it's not the right way to post it)

LAN-side bridge setup : IP 192.168.1.1    MAC 00:03:47:df:32:a8
WAN-side bridge setup : IP 172.20.211.144 MAC 10:d0:cf:03:fc:52
LAN client            : IP 192.168.1.206  MAC 00:19:4b:27:ca:86
WAN server gateway    : IP 172.20.211.190 MAC 00:03:fa:00:05:00

NTP Client packet, LAN-side :
0000  00 03 47 df 32 a8 00 19  4b 27 ca 86 08 00 45 00   ..G.2... K'....E.
0010  00 4c 00 02 00 00 3c 11  30 88 c0 a8 01 ce ac 14   .L....<. 0.......
0020  df 8c 05 03 00 7b 00 38  c2 38 1b 0f 08 00 00 00   .....{.8 .8......
0030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ........ ........
0040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ........ ........
0050  00 00 c0 c4 49 92 6c 49  50 00                     ....I.lI P.

NTP Client packet, WAN-side (after routing/forward) :
0000  ac 14 df 8c 00 00 00 00  00 00 00 00 00 00 45 00   ........ ......E.
0010  00 4c 00 02 00 00 3b 11  74 59 ac 14 d3 90 ac 14   .L....;. tY......
0020  df 8c 05 03 00 7b 00 38  05 0a 1b 0f 08 00 00 00   .....{.8 ........
0030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ........ ........
0040  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ........ ........
0050  00 00 c0 c4 49 92 6c 49  50 00                     ....I.lI P.

SNMP trap packet, LAN-side :
0000  00 03 47 df 32 a8 00 19  4b 27 ca 86 08 00 45 00   ..G.2... K'....E.
0010  00 5f 00 03 00 00 3c 11  30 74 c0 a8 01 ce ac 14   ._....<. 0t......
0020  df 8c 00 a2 00 a2 00 4b  2c 28 30 41 02 01 00 04   .......K ,(0A....
0030  06 72 65 70 6f 72 74 a4  34 06 08 2b 06 01 04 01   .report. 4..+....
0040  c4 07 01 40 04 c0 a8 01  ce 02 01 00 02 01 04 43   ...@.... .......C
0050  01 06 30 19 30 17 06 0c  2b 06 01 04 01 c4 07 65   ..0.0... +......e
0060  0d 02 04 00 04 07 31 2e  32 34 2e 30 31            ......1. 24.01

SNMP trap packet, WAN-side :
0000  ac 14 df 8c 00 00 00 00  00 00 00 00 00 00 45 00   ........ ......E.
0010  00 5f 00 03 00 00 3b 11  74 45 ac 14 d3 90 ac 14   ._....;. tE......
0020  df 8c 00 a2 00 a2 00 4b  6e 0e 30 41 02 01 00 04   .......K n.0A....
0030  06 72 65 70 6f 72 74 a4  34 06 08 2b 06 01 04 01   .report. 4..+....
0040  c4 07 01 40 04 ac a8 01  ce 02 01 00 02 01 04 43   ...@.... .......C
0050  01 06 30 19 30 17 06 0c  2b 06 01 04 01 c4 07 65   ..0.0... +......e
0060  0d 02 04 00 04 07 31 2e  32 34 2e 30 31            ......1. 24.01

We can see that the outputted packets have a wrong ethernet header :
ac 14 df 8c 00 00 00 00  00 00 00 00 00 00
Without the patch, the same header is good :
00 03 fa 00 05 00 10 d0  cf 03 fc 52 08 00

The ethertype is set to 00 00 instead of 08 00 (IPv4), the destination
mac address is set to the destination ip address instead, and there is
no source mac address.

I think that the ethernet-building stage is not run anymore in my
case, but I don't know really why.
Any help would be appreciated.
Thanks,

--
Damien Thebault
