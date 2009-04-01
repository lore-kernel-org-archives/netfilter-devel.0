From: Jan Engelhardt <jengelh@medozas.de>
Subject: [ANNOUNCE] Xtables-addons 1.14
Date: Wed, 1 Apr 2009 17:21:03 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904011717530.22472@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Greetings,


recently released was Xtables-addons 1.14 that fixes a few minor 
reported issues with some extensions.

Grabbit:
http://downloads.sf.net/xtables-addons/xtables-addons-1.14.tar.bz2 + .asc

Changes:
- fuzzy: need to account for kernel-level modified variables in .userspacesize
- geoip: remove XT_ALIGN from .userspacesize when used with offsetof
- SYSRQ: ignore non-UDP packets
- SYSRQ: do proper L4 header access in IPv6 code
  (must not use tcp/udp_hdr in input path)
- add "STEAL" target (cf. DROP)
- dhcpmac: rename from dhcpaddr
