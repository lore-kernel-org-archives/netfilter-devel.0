From: "Slagter, EM" <eslagter@wlz.nl>
Subject: Possible bug ipsec and SNAT?
Date: Wed, 19 Dec 2007 12:42:44 +0100
Message-ID: <476903B4.8060303@wlz.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.wlz.nl ([194.53.3.6]:43776 "EHLO mx1.wlz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbXLSMIj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:08:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I don't know whether this netfilter behaviour is a bug or intentional,
but at least for me it's not what I'd expect (nor want).

Our system (simplified to significant parts):
- linux i386 kernel 2.6.21.2 vanilla, almost all netfilter and ipsec
parts compiled in, no (relevant) modules
- one vlan interface connected to public internet
- one vlan interface connected to internal vlan, RFC addresses
- pluto ("openswan") to manage ISAKMP, appropriate config file
- some netfilter rules that include -m policy to separate the ipsec
traffic before and after encapsulation (for instance to prevent traffic
to be sent over internet without encryption)

Using this scenario, it works pretty much as documented.

As soon as I add SNAT to traffic originating from this vlan (as required
by our supplier), the rules that (properly) used to match on "-m policy
--pol ipsec --dir out --tunnel-src ... --tunnel-dst ..." no longer
match. Even if I remove the tunnel-src and --tunnel-dst the rule no
longer matches. If I change "the --pol ipsec" to "--pol none" the rule
matches again. This is wrong IMHO as the traffic is still encapsulated
(checked this with tshark) as expected.

I've checked the ChangeLogs of the kernel from 2.6.21.2 to current but
there doesn't seem to have been a relevant patch on this matter.

"Please help" ;-)

