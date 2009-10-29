From: Patrick McHardy <kaber@trash.net>
Subject: Re:
Date: Thu, 29 Oct 2009 23:55:38 +0100
Message-ID: <4AEA1D6A.9010902@trash.net>
References: <1256839878-24358-1-git-send-email-jengelh@medozas.de> <4AEA16AA.30605@trash.net> <alpine.LSU.2.00.0910292349040.3360@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61343 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbZJ2Wzm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:55:42 -0400
In-Reply-To: <alpine.LSU.2.00.0910292349040.3360@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-10-29 23:26, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> here are three commits that fix bugzilla entries and/or other
>>> problems encountered. There are also two extra commits prepended
>>> without any changes, which only provide missing log entries for
>>> already-merged commits.
>> Just to clarify before I apply this - how does adding changelog
>> entries afterwards work? Am I correct to assume that this won't
>> affect this history of the tree and existing clones?
> 
> I just used `git commit --allow-empty -e` to record a plain commit on 
> top, just without any change in the tree object. Take a look in 
> git-forest/gitk if in doubt ;-)

Nice. Pulled and pushed out again, thanks.

