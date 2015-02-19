From: Florian Westphal <fw@strlen.de>
Subject: iptables: add more test cases and minor bug fixes
Date: Thu, 19 Feb 2015 14:11:16 +0100
Message-ID: <1424351483-27617-1-git-send-email-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58474 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbbBSNLh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Will push to master soon if there are no objections.
iptables-test.py should now be complete enough to replace the old
iptables-save format "test" files, so I'm going to remove the tests/
directory as well.

All tests pass on current nf.git tree (minus ULOG since thats no longer
supported).

Cheers,
Florian

