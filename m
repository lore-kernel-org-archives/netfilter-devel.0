From: Andrew Watts <akwatts@ymail.com>
Subject: NFQUEUE verdicts - adding non-termination
Date: Thu, 11 Nov 2010 01:01:04 -0800 (PST)
Message-ID: <897598.58283.qm@web111015.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm2-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.248]:36675 "HELO
	nm2-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751660Ab0KKJBG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:01:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi.

The NF_CONTINUE verdict that Darryl Miles brings up in his 11/4 post is very interesting.

NF_CONTINUE would provide the NFQUEUE target the added flexibility of, say, partial handling in userspace. A queue-handler could have a set of criteria that, when satisfied, would result in an immediate drop or accept. One could then leave the rest of the packets to find their fate in the chains/rules left to traverse.

I would be interested in helping to add this verdict if someone will take the lead (assuming a patch hasn't already been written - has it?).

Your comments appreciated.

~ Andy


      
