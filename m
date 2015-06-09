From: Andreas Schultz <aschultz@tpip.net>
Subject: nft rules processed in wrong network namespace
Date: Tue, 9 Jun 2015 11:55:46 +0000 (UTC)
Message-ID: <1554031810.225997.1433850946873.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:56259 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964791AbbFILzt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Jun 2015 07:55:49 -0400
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.tpip.net (Postfix) with ESMTPS id 99D414F403
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:55:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id 7A3223A97AD
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:55:47 +0000 (UTC)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id RGbRGmq58Z5H for <netfilter-devel@vger.kernel.org>;
	Tue,  9 Jun 2015 11:55:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id 0404E3A97AA
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:55:47 +0000 (UTC)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HxHdmy0teBXl for <netfilter-devel@vger.kernel.org>;
	Tue,  9 Jun 2015 11:55:46 +0000 (UTC)
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	by office.tpip.net (Postfix) with ESMTP id E57083A97AC
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2015 11:55:46 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

It seems that nft rules are processed in the wrong network namespace.

Sample setup:

default netns:

# nft list table filter
<cmdline>:1:1-17: Error: Could not receive table from kernel: No such file or directory
list table filter
^^^^^^^^^^^^^^^^^

# netstat -atn
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       
tcp        0      0 127.0.0.1:13666         0.0.0.0:*               LISTEN      
[...]

netns "upstream":

# ip netns exec upstream nft list table filter
table ip filter {
	chain input {
		type filter hook input priority 0; policy accept;
	}

	chain forward {
		type filter hook forward priority 0; policy accept;
	}

	chain output {
		type filter hook output priority 0; policy accept;
		nftrace set 1 
		counter packets 6826 bytes 329487801 drop 
	}
}

# ip netns exec upstream netstat -atn
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       
tcp        0      0 0.0.0.0:3128            0.0.0.0:*               LISTEN  

# dmesg | tail

[ 3021.706763] TRACE: filter:output:rule:1 IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45563 DF PROTO=TCP SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH URGP=0 OPT (0101080A00298046001A1EEE) UID=0 GID=0 
[ 3021.728817] TRACE: filter:output:rule:2 IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45563 DF PROTO=TCP SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH URGP=0 OPT (0101080A00298046001A1EEE) UID=0 GID=0 
[ 3022.001321] TRACE: filter:output:rule:1 IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45564 DF PROTO=TCP SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH URGP=0 OPT (0101080A0029816D001A1EEE) UID=0 GID=0 
[ 3022.023382] TRACE: filter:output:rule:2 IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 LEN=65535 TOS=0x00 PREC=0x00 TTL=64 ID=45564 DF PROTO=TCP SPT=48233 DPT=13666 SEQ=715960373 ACK=191464471 WINDOW=1930 RES=0x00 ACK PSH URGP=0 OPT (0101080A0029816D001A1EEE) UID=0 GID=0 

tcpdump on interface lo in the default namespace shows the traffic, in the
upstream namespace no traffic is seen (as should be).

It seems as if the nft rules in the upstream do receive the traffic from the
default namespace.

Andreas
-- 
-- 
Andreas Schultz
