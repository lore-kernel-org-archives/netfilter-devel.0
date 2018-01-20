From: Jeff Kletsky <netfilter@allycomm.com>
Subject: Error: interval overlaps with previous one (with previously valid
 configuration)
Date: Fri, 19 Jan 2018 20:42:52 -0800
Message-ID: <d3d8d2fe-aebb-73ad-8162-44a0a184a7d2@wagsky.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: netfilter-devel@vger.kernel.org,
        Netfilter Users Mailing list <netfilter@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx.allycomm.com ([138.68.30.55]:15319 "EHLO mx.allycomm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753337AbeATEst (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 23:48:49 -0500
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With a previously valid configuration, which "includes" files into the 
main configuration, I get error messages with the HEAD of master on 
January 16, 2018 9afd72a883e391e366a1d75bb4e1705357e078e9

systemd[1]: Starting nftables...
apu.allycomm.com nft[31431]: In file included from nftables.conf:396:6-34:
apu.allycomm.com nft[31431]: ./dnat_targets.nft:45:9-23: Error: interval 
overlaps with previous one
apu.allycomm.com nft[31431]:         ^^^^^^^^^^^^^^^

Unfortunately, the error message both fails to identify what interval 
overlaps as well as failing to identify the location of the conflict. 
dnat_targets only has 23 lines. This feels like a similar problem to the 
"wrong-file" issues that were previously resolved.


Guessing that the problem was caused by

commit 9a4b513014cfdeaad6d247b72a7924b3a536cfe9
Author: Phil Sutter <phil@nwl.cc>
Date:   Wed Jan 10 21:32:04 2018 +0100

     src: Don't merge adjacent/overlapping ranges

     [...]


I have reverted back to the previous commit

commit 0b3ccd27e12d1df442aa3eac40a2ccb63d6c6407
Author: Phil Sutter <phil@nwl.cc>
Date:   Wed Jan 10 13:43:21 2018 +0100

     build: Restore per object CFLAGS

and at least have an operational system again.


I don't see any commits in today's master branch after the 9a4b51 commit 
that seem to relate either to the interval regression, or to the problem 
with logging.


How can I trace down this problem?


Thanks,

Jeff


