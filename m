From: Andreas Schultz <aschultz@tpip.net>
Subject: Re: nft rules processed in wrong network namespace
Date: Wed, 10 Jun 2015 07:59:39 +0000 (UTC)
Message-ID: <1962670441.242187.1433923179278.JavaMail.zimbra@tpip.net>
References: <1554031810.225997.1433850946873.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:46782 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591AbbFJH7m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 03:59:42 -0400
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.tpip.net (Postfix) with ESMTPS id 0CE8C4F419
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 07:59:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id DCF243A01B7
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 07:59:39 +0000 (UTC)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id qiQoJeNQz6IT for <netfilter-devel@vger.kernel.org>;
	Wed, 10 Jun 2015 07:59:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id 6692F3A01B0
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 07:59:39 +0000 (UTC)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 0KtIbmb1d-eX for <netfilter-devel@vger.kernel.org>;
	Wed, 10 Jun 2015 07:59:39 +0000 (UTC)
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	by office.tpip.net (Postfix) with ESMTP id 540793A01B4
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 07:59:39 +0000 (UTC)
In-Reply-To: <1554031810.225997.1433850946873.JavaMail.zimbra@tpip.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've now tested the same setup on Ubuntu 15.04 (Linux 3.19, nftables 0.4) and
the same problem occurs.

Should I open this as a bug at https://bugzilla.netfilter.org/ ???

Andreas

----- On 9 Jun, 2015, at 13:55, aschultz aschultz@tpip.net wrote:

> Hi,
> 
> It seems that nft rules are processed in the wrong network namespace.
> 
> Sample setup:
> 
> default netns:
> 
> # nft list table filter
> <cmdline>:1:1-17: Error: Could not receive table from kernel: No such file or
> directory
> list table filter
> ^^^^^^^^^^^^^^^^^
> 
> # netstat -atn
> Active Internet connections (servers and established)
> Proto Recv-Q Send-Q Local Address           Foreign Address         State
> tcp        0      0 127.0.0.1:13666         0.0.0.0:*               LISTEN
> [...]
> 
> netns "upstream":
> 
> # ip netns exec upstream nft list table filter
> table ip filter {
>	chain input {
>		type filter hook input priority 0; policy accept;
>	}
> 
>	chain forward {
>		type filter hook forward priority 0; policy accept;
>	}
> 
>	chain output {
>		type filter hook output priority 0; policy accept;
>		nftrace set 1
>		counter packets 6826 bytes 329487801 drop
>	}
> }
> 
> # ip netns exec upstream netstat -atn
> Active Internet connections (servers and established)
> Proto Recv-Q Send-Q Local Address           Foreign Address         State
> tcp        0      0 0.0.0.0:3128            0.0.0.0:*               LISTEN
> 
> # dmesg | tail
> 
> [ 3021.706763] TRACE: filter:output:rule:1 IN= OUT=lo SRC=127.0.0.1
> DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45563 DF PROTO=TCP
> SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH
> URGP=0 OPT (0101080A00298046001A1EEE) UID=0 GID=0
> [ 3021.728817] TRACE: filter:output:rule:2 IN= OUT=lo SRC=127.0.0.1
> DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45563 DF PROTO=TCP
> SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH
> URGP=0 OPT (0101080A00298046001A1EEE) UID=0 GID=0
> [ 3022.001321] TRACE: filter:output:rule:1 IN= OUT=lo SRC=127.0.0.1
> DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45564 DF PROTO=TCP
> SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH
> URGP=0 OPT (0101080A0029816D001A1EEE) UID=0 GID=0
> [ 3022.023382] TRACE: filter:output:rule:2 IN= OUT=lo SRC=127.0.0.1
> DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45564 DF PROTO=TCP
> SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH
> URGP=0 OPT (0101080A0029816D001A1EEE) UID=0 GID=0
> 
> tcpdump on interface lo in the default namespace shows the traffic, in the
> upstream namespace no traffic is seen (as should be).
> 
> It seems as if the nft rules in the upstream do receive the traffic from the
> default namespace.
> 
> Andreas
> --
> --
> Andreas Schultz
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
-- 
Dipl. Inform.
Andreas Schultz

email: as@travelping.com
phone: +49-391-819099-224
mobil: +49-170-2226073

------------------- enabling your networks -------------------

Travelping GmbH               phone:         +49-391-819099229
Roentgenstr. 13               fax:           +49-391-819099299
D-39108 Magdeburg             email:       info@travelping.com
GERMANY                       web:   http://www.travelping.com

Company Registration: Amtsgericht Stendal Reg No.:   HRB 10578
Geschaeftsfuehrer: Holger Winkelmann | VAT ID No.: DE236673780
--------------------------------------------------------------
