From: "Yigal Reiss (yreiss)" <yreiss@cisco.com>
Subject: NFQ breaks conntrack creation to confirmation path for a fast UDP
 stream causing dropped packets
Date: Mon, 28 Mar 2016 18:54:59 +0000
Message-ID: <0f95cd7b83dc47969639081df1bfe911@XCH-RTP-014.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:41157 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcC1SzI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 14:55:08 -0400
Received: from XCH-RTP-011.cisco.com (xch-rtp-011.cisco.com [64.101.220.151])
	by alln-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id u2SIt0VC032418
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=FAIL)
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 18:55:00 GMT
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sending a high throughput stream of UDP packets through NFQ causes a few packets to be dropped.

Let's say we have 10 packets with same tuple going in. They all receive different conntrack objects (with confirmed flag unset).

They then get grabbed by user space through NFQ and suppose they all get accept verdict.

The first one to be accepted will go through the standard flow (get confirmed and the conntrack will be entered into the hash table). 

The other 9 packets are reinjected and upon being sent for confirmation (ipv4_confirm) at some point it gets dropped (in __nf_conntrack_confirm). The conditions for being dropped are that a conntrack entry with that tuple already exists. The reason for dropping is given as comment in the code:

/* See if there's one in the list already, including reverse:
NAT could have grabbed it without realizing, since we're
not in the hash.  If there is, we lost race. */

Dropping packets in this case seems like a malfunction IMO. True, UDP is not guaranteed, but still this may in some cases cause degradation in functionality to a working application. Any opinions on that?

Also any ideas for how to resolve this? Seems like there is a strong assumption of serialization in conntrack, that is that one packet enters the ip layer only after the previous packet has left (i.e. confirmed). So any solution that only replaces the contract with the more updated one in the middle (not that I know how to do it) will be only partial (since the packet has already traversed some hooks which may have relied on having a 'good' conntrack). 

Any thoughts appreciated.



