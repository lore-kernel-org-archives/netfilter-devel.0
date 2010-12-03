From: Ferenc Wagner <wferi@niif.hu>
Subject: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Fri, 03 Dec 2010 18:27:47 +0100
Message-ID: <87sjyercks.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:44056 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab0LCSEq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 13:04:46 -0500
Received: from wferi by tac.ki.iif.hu with local (Exim 4.72)
	(envelope-from <wferi@niif.hu>)
	id 1POZQB-00023t-7z
	for netfilter-devel@vger.kernel.org; Fri, 03 Dec 2010 18:27:47 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I opened http://bugzilla.netfilter.org/show_bug.cgi?id=683 quite some
time ago, but it hasn't received a single comment yet.  Don't you think
it's a real problem?  If you do, I'm willing to work on fixing it,
either by introducing a new option or by changing the default behaviour.
Actually, since we're seriously affected by this, I'm determined to
solve it, but of course I'd prefer to take a blessed route to get my
changes incorporated into the official sources if at all possible.

Comments, opinions, ideas and guidance most welcome. :)
-- 
Thanks,
Feri.
