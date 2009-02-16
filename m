From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [pull] all patches complete
Date: Mon, 16 Feb 2009 13:11:58 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902161307420.12536@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0902131642300.17695@fbirervta.pbzchgretzou.qr> <499942C3.1090906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57632 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbZBPMMB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:12:01 -0500
In-Reply-To: <499942C3.1090906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-16 11:41, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>>
>> All patches have been gathered and collected, pullable at the usual place of
>> 	git://dev.medozas.de/iptables master
>>
>> 20 files changed, 180 insertions(+), 173 deletions(-)
>
> I wanted to pull this, but I'm again getting a quite different
> diffstat:

This is because another patch was added at jamal's request.

I am not quite sure how the preferred workflow is for when
only a subset of a branch is supposed to be merged (because
the branch already moved on). I guess
`git fetch...; git merge $sha1` would work, but that looks
a bit odd in the changelog.
stat is currently
 21 files changed, 242 insertions(+), 258 deletions(-)
