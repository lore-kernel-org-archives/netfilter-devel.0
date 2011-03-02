From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: recommendations on implementing a custom Netfilter hook to QUEUE
 packets before their SEQ/ACK and size before fragmentation are known?
Date: Wed, 2 Mar 2011 05:22:39 +0200
Message-ID: <AANLkTi=x_khzkObaG4F7PrVzbStd5c1OZMCE_oKHa35b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64850 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757764Ab1CBDXU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:23:20 -0500
Received: by wyg36 with SMTP id 36so5373744wyg.19
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2011 19:23:19 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.

What I look for is reimplementing a part of NFQUEUE functionality at
the stage where TCP packet is formed before sending to network.
It seems that NFQUEUE can't just handle expanded (> MTU) packet, and
also want to have control over SEQ/ACK numbers assigned to
both packets and connection structures.

But errr.. where to look for? The sources are too complex and there's
not enough guides.
Actually I have this doc only:
http://www.nsnam.org/wiki/index.php/GSOC2009Netfilter#Callback_Priority

Can anyone point me to correct place in kernel sources to see/attach
with SystemTap and track how SEQs are generated and how outgoing
packets are planned to be fragmented or even dropped? Deliberately
want a good tour.

P.S. There's at least 2 projects that can benefit from such
transparent packet size growing, one is mine and second is StegBox
(steganography based covert channels in traffic)

-- 
cheers,
Igor
