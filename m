From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Fri, 16 Jul 2010 14:10:35 +0300
Message-ID: <1279278635.1603.53.camel@powerslave>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:23212 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965122Ab0GPLK7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:10:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

Jan Engelhardt <jengelh@medozas.de> writes:
> On Thursday 2010-04-22 13:14, Patrick McHardy wrote:
> 
> > This looks better, thanks. A few remaining questions about things
> > I missed previously:
> 
> Will deal with it shortly.

Are you planning to resend this patch with the changes Patrick
suggested?

As you may have seen in my earlier rfc email, I'm interested in
something similar to the condition match.  I'm not sure whether the best
approach is to create a CONDITION target where we can set the condition
variable in the iptables itself or if it is better to create a new
"variable match" and an accompanying "VARIABLE target" that keeps the
variables in memory, instead of using procfs.

Any suggestions?


-- 
Cheers,
Luca.

