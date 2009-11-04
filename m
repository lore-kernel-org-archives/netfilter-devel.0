From: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Subject: Problem with ipset on sparc64
Date: Wed, 4 Nov 2009 21:07:16 +0000
Message-ID: <4513233BE7DF454BB62D30017EEE55436CFB9228C3@GVW1115EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:36116 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbZKDVHr convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:07:47 -0500
Received: from G1W0401.americas.hpqcorp.net (g1w0401.americas.hpqcorp.net [16.236.31.6])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by g4t0014.houston.hp.com (Postfix) with ESMTPS id 993662439E
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2009 21:07:52 +0000 (UTC)
Content-Language: de-DE
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm using ipset 3.2 on a sparc64 system (ultra2), kernel 2.6.31.5, Debian 5.
Everything works fine, but the -L option shows strange values for a portmap.
Example:
Added Port 10, 20 and 456 to map xyz. Ipset -L xyz shows:
Name: xyz
Type: portmap
References: 1
Default binding: 
Header: from: 1 to: 65535
Members:
42
52
488
Bindings:

The iptables match works correctly, it is just the listing.
Any idea what's wrong?

Regards
       Georg Chini
