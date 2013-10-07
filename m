From: "Steve \(Telsat Broadband\)" <steve@telsatbb.vu>
Subject: Creation of a custom netfilter/iptables target module
Date: Tue, 8 Oct 2013 10:35:10 +1100
Message-ID: <0d7e01cec3b5$dd64f100$982ed300$@telsatbb.vu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.telsatbb.vu ([180.222.210.5]:51593 "EHLO mail.telsatbb.vu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3JGXuf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:50:35 -0400
Content-Language: en-au
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

I'm seeking the wisdom of the netfilter gurus to get me going in the right
direction.

Currently, we have a gateway in which several iptables/ip6tables rules send
information to the LOG target which a custom perl script then reads to
perform some processing on the sender's MAC and IP.

What I'm wanting to do is relieve load on the system by cutting out the step
of logging to syslog and sending straight to the processing program either
via a socket or some other means.  I don't need to store any of the
information in the packet, only pass the MAC and IP (v4 or v6) to the
processing program.

Reading through the PDF by Jan
(http://inai.de/documents/Netfilter_Modules.pdf) and this site
(http://pudhumaijude.blogspot.com/2011/01/mini-howto-write-your-own-iptables
.html), I've been trying to make a modified version of the LOG target, but
the part I'm not quite understanding is which method in the module actually
performs the 'work'; the part of the module that actually receives the
package and performs the processing on it.

If anyone can give me some pointers, this would be very much appreciated.

Cheers.
Steve.



