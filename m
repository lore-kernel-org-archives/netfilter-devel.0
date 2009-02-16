From: Patrick McHardy <kaber@trash.net>
Subject: Re: [pull] all patches complete
Date: Mon, 16 Feb 2009 13:15:58 +0100
Message-ID: <499958FE.2060002@trash.net>
References: <alpine.LSU.2.00.0902131642300.17695@fbirervta.pbzchgretzou.qr> <499942C3.1090906@trash.net> <alpine.LSU.2.00.0902161307420.12536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55243 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZBPMQD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:16:03 -0500
In-Reply-To: <alpine.LSU.2.00.0902161307420.12536@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-02-16 11:41, Patrick McHardy wrote:
> 
>> Jan Engelhardt wrote:
>>> All patches have been gathered and collected, pullable at the usual place of
>>> 	git://dev.medozas.de/iptables master
>>>
>>> 20 files changed, 180 insertions(+), 173 deletions(-)
>> I wanted to pull this, but I'm again getting a quite different
>> diffstat:
> 
> This is because another patch was added at jamal's request.
> 
> I am not quite sure how the preferred workflow is for when
> only a subset of a branch is supposed to be merged (because
> the branch already moved on). I guess
> `git fetch...; git merge $sha1` would work, but that looks
> a bit odd in the changelog.
> stat is currently
>  21 files changed, 242 insertions(+), 258 deletions(-)

The preferred way is to not change the public tree after a pull request
until it has been pulled. Not sure how you work, but I assume you have
a local tree that you push to the public one. In that case simply wait
until I've pulled before you update again.
