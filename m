From: Michael Stapelberg <michael+netfilter@stapelberg.de>
Subject: iptlog: tracing iptables packet flow
Date: Fri, 25 Jun 2010 23:33:26 +0200
Message-ID: <1277495925-sup-9790@midna.zekjur.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.twice-irc.de ([79.140.35.195]:50092 "EHLO twice-irc.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751895Ab0FYVnT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:43:19 -0400
Received: from midna.zekjur.net (midna.zekjur.net [IPv6:2001:4d88:1008:4242:21c:c0ff:fe7e:4776])
	by twice-irc.de (Postfix) with ESMTPSA id 82964166636
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jun 2010 23:33:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everybody,

recently I wondered why there is no way to trace packet flow in iptables like
in pf (packet filter on BSD systems) with the pflog pseudo-interface (or can
you?). So, I did some research for a proof-of-concept and found the TRACE
target aswell as ulogd with the pcap-plugin. Then I defined a new format (like
the pflog format), wrote a plugin for ulogd2 and a dissector for wireshark and
there we go.

So, the links to look up my work so far are:
header description: 
  http://code.stapelberg.de/git/tracetables/tree/HEADER
the output plugin:
  http://code.stapelberg.de/git/tracetables/tree/ulogd2-output-iptlog
wireshark dissector:
  http://code.stapelberg.de/git/tracetables/tree/0001-add-dissector-for-iptlog.patch

So, here comes my first question: Is this the right way to implement it? Am I
missing some obvious better alternative?

The question which is probably harder to answer:
Because one wants to include the iptables rule in human readable format in the
iptlog file aswell, I want to get the string representation of a rule somehow.
iptables-save provides such a representation, but directly calls printf() when
generating it. So, my first try was to just copy its code and adapt it to
buffers and sprintf. However, I discovered that modules provide a save()
callback which also directly calls printf. So, there is no way to capture the
output of the save callback without modifying each module, right?

So, what should I do about this? Change the API to tell the module to call my
own function with the string instead of directly calling printf?

Best regards,
Michael
