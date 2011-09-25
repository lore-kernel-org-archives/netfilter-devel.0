From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: [iptables] tcp handshake: ACK RST silently converted to RST ?
Date: Sun, 25 Sep 2011 14:59:15 +0200
Message-ID: <j5n8j4$713$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35468 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab1IYM72 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Sep 2011 08:59:28 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1R7oIp-0001hD-5a
	for netfilter-devel@vger.kernel.org; Sun, 25 Sep 2011 14:59:27 +0200
Received: from p4fdf493f.dip.t-dialin.net ([79.223.73.63])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2011 14:59:27 +0200
Received: from for-gmane by p4fdf493f.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2011 14:59:27 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I made a funny observation:

   client sends a tcp SYN packet to a served port on server,
   server answers with ACK SYN,
   client sends ACK RST to abort the 3-way-handshake.

When logging these sequences with the following commands:
   iptables -A INPUT  -p tcp --tcp-flags SYN SYN -j LOG --log-prefix "SYN IN  "
   iptables -A OUTPUT -p tcp --tcp-flags SYN SYN -j LOG --log-prefix "SYN OUT "
   iptables -A INPUT  -p tcp --tcp-flags RST RST -j LOG --log-prefix "RST IN  "
   iptables -A OUTPUT -p tcp --tcp-flags RST RST -j LOG --log-prefix "RST OUT "
then one sees that the "ACK RST" gets logged only as a "RST".

Is this perhaps a bug of iptables or its log module?

OTOH server itself sends ACK RST (and it gets logged as such) to an
immediate SYN if the port is not open (ie. blocked).

So, is then ACK RST maybe not an allowed answer to an ACK SYN to abort the handshake sequence?

