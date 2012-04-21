From: "alois.klingler@chello.at" <alois.klingler@chello.at>
Subject: wrong order of received packets/bytes and sent packets/bytes with
 local incoming connections
Date: Sat, 21 Apr 2012 20:33:03 +0200
Message-ID: <4F92FD5F.5010204@chello.at>
Reply-To: alois.klingler@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep21.mx.upcmail.net ([62.179.121.41]:45236 "EHLO
	fep21.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2DUSt0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Apr 2012 14:49:26 -0400
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep12-int.chello.at
          (InterMail vM.8.01.05.04 201-2260-151-105-20111014) with ESMTP
          id <20120421183304.WKJT29183.viefep12-int.chello.at@edge03.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Sat, 21 Apr 2012 20:33:04 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,

in /proc/net/nf_conntrack (and also in conntrack -L) i can see received
packets/bytes and sent packets/bytes.
with connections, which are local incoming connections (i.e. a
ssh-connection from anywhere to my machine) these fields are mixed,
means that the received packets/bytes are the sent packets/bytes and vice versa.

with local outbound connections or forwarding connections these fields
are correct filled.

is there anywhere a configuation option to fix this?

I am using kernel 3.3.2 (I can see this issue already very long, not
since this kernel) and conntrack 0.9.14 (debian squeeze).

Thanks!

Best regards
Alois

