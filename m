From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: NFQUEUE: best way to deal with changed SEQ/ACK in a stream?
Date: Fri, 25 Feb 2011 01:26:18 +0200
Message-ID: <AANLkTimKfmmACTGEuP1PE2SasYsbjyzHDGBTE3aJbtVq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57442 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab1BXX0V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:26:21 -0500
Received: by wwb39 with SMTP id 39so1436675wwb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2011 15:26:20 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.

I ran into problem while developing custom traffic filter; it is
needed to change TCP options in some of connection packets (signing
the transmission), and thereby tcp data offset is increased, network
(sender size) starts to duplicate missing bytes (length - data offset
increase).

I guess there's two ways of solving this - 1) getting custom module to
the place before SEQ/ACK are set for first packet and doing NFQUEUE
work there 2) constantly changing SEQ/ACK for a whole connection using
connmark.

What else can be recommended and how may the NFQUEUE transparency be
preserved whilst having SEQ/ACKs changed in a whole stream?

Seen that those guys -
http://stackoverflow.com/questions/260757/packet-mangling-utilities-besides-iptables
- had solved this somehow.

-- 
cheers,
Igor
