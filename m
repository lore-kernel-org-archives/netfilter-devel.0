From: Thomas Jacob <jacob@internet24.de>
Subject: Incorrect xt_iprange boundary check for IPv6
Date: Sat, 22 Jan 2011 15:10:31 +0100
Message-ID: <1295705432-2588-1-git-send-email-jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:36946 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1AVO3V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Jan 2011 09:29:21 -0500
Received: from [192.168.1.112] (helo=mailin03.ims-firmen.de)
	by mailout01.ims-firmen.de with esmtp (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PgeAk-0005RF-SV
	for netfilter-devel@vger.kernel.org; Sat, 22 Jan 2011 15:10:34 +0100
Received: from [213.174.32.254] (helo=localhost.localdomain)
	by mailin03.ims-firmen.de with esmtpa (Exim 4.72)
	(envelope-from <jacob@internet24.de>)
	id 1PgeAk-0002V9-Rd
	for netfilter-devel@vger.kernel.org; Sat, 22 Jan 2011 15:10:34 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Developed for and tested on 2.6.27.57, but applies and compiles
in current mainline as well (haven't tested it there though).

See the following script for a demonstration of the problem:

#!/bin/sh
PREFIX=fc42:4242
LEFTOUT=$PREFIX:0:ffff:ffff:ffff:ffff:ffff
FROM=$PREFIX:1::0
MIDDLE=$PREFIX:1::8000:0:0:0
TILL=$PREFIX:1::ffff:ffff:ffff:ffff
RIGHTOUT=$PREFIX:2::0
SUBNET=$PREFIX:1::/64
SOURCE=fc23:2323::1
CHAIN=iprange_bug

ip6tables -S OUTPUT | fgrep -q -- '-A OUTPUT -j '"$CHAIN" \
	&& ip6tables -D OUTPUT -j $CHAIN

ip6tables -F $CHAIN 2>/dev/null
ip6tables -X $CHAIN 2>/dev/null
ip6tables -N $CHAIN

ip6tables -A $CHAIN -p icmpv6 --icmpv6-type echo-request -s $SOURCE -m iprange --dst-range $FROM-$TILL
ip6tables -A $CHAIN -p icmpv6 --icmpv6-type echo-request -s $SOURCE -d $SUBNET -j DROP

ip6tables -I OUTPUT 1 -j $CHAIN

ip addr replace $SOURCE/128 dev lo
ip addr replace $LEFTOUT/128 dev lo
ip addr replace $FROM/128 dev lo
ip addr replace $MIDDLE/128 dev lo
ip addr replace $TILL/128 dev lo
ip addr replace $RIGHTOUT/128 dev lo

for IP in $LEFTOUT $FROM $MIDDLE $TILL $RIGHTOUT
do
	ping6 -c 1 -W 1 -q -I $SOURCE $IP | grep ^PING
done

echo
ip6tables -vnL $CHAIN

ip addr del $RIGHTOUT/128 dev lo
ip addr del $TILL/128 dev lo
ip addr del $MIDDLE/128 dev lo
ip addr del $FROM/128 dev lo
ip addr del $LEFTOUT/128 dev lo
ip addr del $SOURCE/128 dev lo

ip6tables -D OUTPUT -j $CHAIN
ip6tables -F $CHAIN
ip6tables -X $CHAIN


