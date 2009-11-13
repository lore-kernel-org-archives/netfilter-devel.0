From: Frederic Beck <frederic.beck@loria.fr>
Subject: iptables-xml
Date: Fri, 13 Nov 2009 14:42:19 +0100
Message-ID: <20091113144219.09c8c2a3@hobbes.loria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:51090
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbZKMNyy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:54:54 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I'm thinking about writing a configuration tool for iptables/ip6tables
that would generate the rules according to a definition of services
running on a network and other parameters.

i saw that within netfilter there is already an XML format used by
iptables-xml that can be converted back to the rules via an XSLT form.

I was thinking of using that same XML representation (we are planning
to use Netconf to configure remotely the devices), but i couldn't find
it anywhere.

Where can i get it ?

Does the XSLT and iptables-xml work as well for IPv6 ?

Thanks a lot for your help

Regards
Frederic
