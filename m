From: Ed W <lists@wildgooses.com>
Subject: Performance issue due to constant "modprobes"
Date: Fri, 08 Apr 2011 00:16:18 +0100
Message-ID: <4D9E45C2.7030805@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:48548 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab1DGX0j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:26:39 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 2CC3034036D
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2011 00:16:19 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id sHMTV-zcLiz8 for <netfilter-devel@vger.kernel.org>;
	Fri,  8 Apr 2011 00:16:19 +0100 (BST)
Received: from Ed-Wildgooses-MacBook-Pro.local (office.nippynetworks.com [212.69.49.94])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id D7BCB34036B
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2011 00:16:18 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, I am using a relatively low powered (embedded) platform and I have a
significant performance problem due to slow "modprobe" performance.

I have my kernel compiled without modules.  My modprobe takes a little
under 1ms to execute.  "iptables" appears to try and modprobe some 21
match/target modules.  As a result, even "iptables -h" takes around 14ms
to run.  This is adding some substantial time to my firewall setup time
(hacking out the modprobes reduces run time from the 14ms to near zero,
ie it's 90+% of my runtime)

I have dug through the code a bit and the first thing I notice is that
there is no --modprobe option actually parsed for, and the undocumented
"-M" option doesn't appear to pass through to xtables.c? (I thought
about simply lying about the modprobe binary name)

My next thought was to collect all the modprobes and run them with a
single execution (modprobe -a). However, it's not clear to me whether
it's important that the modprobe occurs in the middle of xtables.c /
compatible_revision() ?

The final thought is whether it's possible to notice that a module is
already loaded and skip the modprobe call altogether? (/proc/modules is
not enough because the module could be built into the kernel)

Does someone have any ideas on how I can finesse these constant (and
expensive in my case) modprobes each time we run the iptables command?

Thanks

Ed W
