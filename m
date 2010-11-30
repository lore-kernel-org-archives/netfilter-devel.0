From: Dirk <biecie547@gmail.com>
Subject: Use connection tracking to store private data for rate shaping algorithms?
Date: Tue, 30 Nov 2010 16:18:42 +0100
Message-ID: <AANLkTik6sRQ=Pju6krQnUEf7qkhZ0j-cb+CdgmsoHoCf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35046 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0K3PTE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:19:04 -0500
Received: by vws3 with SMTP id 3so416576vws.19
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2010 07:19:04 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,


We are developing some some more advanced TCP rate shaping algorithms
( http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=1261834&tag=1 )
and would like to implement it as a (GPL) kernel module. The goal is
to have a high performant module that can 'shape' traffic for 10 000's
of hosts and users on individual base and also minimize shaping
overhead (drop/retransmits/latency) on the network.

Our current solution uses a custom developed iptables target that
already performs traffic policing for 10'000s of simultaneous users (
http://tnc2007.terena.org/programme/presentations/showbeb6.html ).
Since policing is not an ideal way to regulate bandwidth, we want to
improve it :-)


However, in order to function correctly, we need to keep some extra
information for each flow (both tcp and udp) through the device:
- few statistics (two 64bit integers)
- shaping/rate state information (four 64bit integers)

 This information should be set/accessible from a kernel tc qdisc module.

My idea was to use the connection tracking framework to keep track of
connection states (which is also required by the algorithms) and
somehow extend it to also store the extra information.

I have found there is an extension infrastructure for nf_conntrack (
http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg15798.html
), but it does not seem a module is intended to register itself
without modifying nf_ct_ext_id in /nf_conntrack_extend.h. Since that
would require a kernel recompile, it is not really an option.


Since we're not (yet) familiar with the connection tracking code: what
would be the best way to accomplish this?



Thanks in advance,
Dirk Janssens
