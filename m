From: Darcy Watkins <dwatkins@tranzeo.com>
Subject: Is nftables project still alive?
Date: Tue, 07 Sep 2010 13:44:30 -0700
Message-ID: <1283892270.29631.13.camel@tr-pentomino>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from testserv.tranzeo.com ([64.114.87.10]:20254 "EHLO
	mail2.tranzeo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118Ab0IGU7n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:59:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I cross compiled nftables (kernel diffs merged into 2.6.35.4, nftables
userspace package and the modified libnl) for powerpc using crosstool-ng
toolchain and buildroot framework.

I can see the kernel modules load and the nft program runs but I can't
get past syntax errors.  I think the example rules and user doc must all
be out of date.

Is anyone actively working on this project?  Is there any updated user
doc with some good examples of setting up a bridge firewall say
equivalent to the below (done using ebtables)?

ebtables -I INPUT -i eth1 -p ip4 --ip-pro udp --ip-sport 67 --ip-dport 68 -j DROP
ebtables -I OUTPUT -o eth1 -p ip4 --ip-pro udp --ip-sport 68 --ip-dport 67 -j DROP
ebtables -I FORWARD -i eth1 -p ip4 --ip-pro udp --ip-sport 67 --ip-dport 68 -j DROP
ebtables -I FORWARD -o eth1 -p ip4 --ip-pro udp --ip-sport 68 --ip-dport 67 -j DROP

Any pointers would be helpful.

I want to duplicate something I've done using ebtables and then run high
volume small packet UDP traffic through the bridge using iperf to
compare performance overhead hits between nftables and ebtables as they
skip past rules not used by the high volume traffic.

Regards,

Darcy



