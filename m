From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Fri, 17 Jul 2009 16:31:23 +0200
Message-ID: <4A608B3B.20702@trash.net>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de> <4A2A1260.7050207@netfilter.org> <4A2D171E.9060401@trash.net> <alpine.LSU.2.00.0906101405590.30984@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0906251903520.26556@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0907161624140.22115@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60905 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933405AbZGQObe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 10:31:34 -0400
In-Reply-To: <alpine.LSU.2.00.0907161624140.22115@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-06-25 19:08, Jan Engelhardt wrote:
>> On   2009-06-10 12:19:59, Patrick wrote:
>>> On Wednesday 2009-06-10 14:16, Jan Engelhardt wrote:
>>>> Git is not as castrated as Hg when it comes to branches, so why not
>>>> make a "stable" branch that is then regularly merged into master? :)
>>> I don't see why that would currently be necessary. We're talking
>>> about a few days, and in fact I'd rather have people test the
>>> current code before the release instead of hacking on new things :)
>> Yeah but in general? The - judging from their version numbers -
>> x.y.z.S stable versions like 1.4.3.1 used to receive lots of new
>> features because there is just master, in which case it should
>> have been the new 1.4.4 already.
>> So either z is bumped more often and S-versions will not
>> be released, or S only receives fixes, necessiting a separate branch.
>> Objections?
> 
> It would be cool to get an answer here so I know how to twingle 
> patchbranches that I'd like to submit.

Well, I don't object to having a stable branch when we actually do
need to release pure bug-fix versions. But I'd say those can be
created on demand.

