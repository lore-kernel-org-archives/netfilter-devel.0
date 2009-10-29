From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re:
Date: Thu, 29 Oct 2009 23:51:24 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0910292349040.3360@obet.zrqbmnf.qr>
References: <1256839878-24358-1-git-send-email-jengelh@medozas.de> <4AEA16AA.30605@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47215 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbZJ2WvT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:51:19 -0400
In-Reply-To: <4AEA16AA.30605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2009-10-29 23:26, Patrick McHardy wrote:

>Jan Engelhardt wrote:
>> here are three commits that fix bugzilla entries and/or other
>> problems encountered. There are also two extra commits prepended
>> without any changes, which only provide missing log entries for
>> already-merged commits.
>
>Just to clarify before I apply this - how does adding changelog
>entries afterwards work? Am I correct to assume that this won't
>affect this history of the tree and existing clones?

I just used `git commit --allow-empty -e` to record a plain commit on 
top, just without any change in the tree object. Take a look in 
git-forest/gitk if in doubt ;-)
