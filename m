From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: xt_AUDIT additions
Date: Thu, 30 Jun 2011 23:42:58 +0100
Message-ID: <4E0CFBF2.9000500@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35231 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1F3WnF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:43:05 -0400
Received: by wwe5 with SMTP id 5so2685470wwe.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 15:43:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I would like to add 3 more pieces of information to the audit target to 
be included in the audit logs:

1. pid/uid -> auid + program path (auid and program path is retrievable 
once the pid is known) - outgoing packets only, obviously;
2. tcpflags, where applicable; and
3. tos information, again, where applicable;

The last two are more-or-less directly retrievable as they are included 
in the tcphdr and iphdr structs respectively, but I am struggling to 
find a reliable source for the first one - uid/pid information.

I know this information *should* be available as outgoing packets are 
bound to sockets and those are created by a process, but I am struggling 
to find a reliable source which I could use. I looked at both ss and 
netstat sources, but the approach there is very different as they both 
use/scan "/proc" to retrieve this information and I am not sure this is 
the best way to approach things for the kernel code of the audit target.

Is there any other quicker/reliable way?

Having pid/uid, the program path and auid in particular (i.e. the audit 
id - the "master" session of the root process owning the process to 
which the socket/outgoing packet is bound) included in the audit logs 
would be invaluable piece of information as the source of the packets 
could be easily traced to the process (or processes) which created it 
and the user id used. It would also help with cross-referencing with 
other uid/pid/auid information from the audit logs to discover patterns 
of interest to the auditors/sys admins.
