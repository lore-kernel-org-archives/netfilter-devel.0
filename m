From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ct_sync project update
Date: Sun, 08 Feb 2009 02:30:13 +0100
Message-ID: <498E35A5.2070702@netfilter.org>
References: <498C6996.5060004@usherbrooke.ca> <20090206172641.GH30540@outback.rfc2324.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43273 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750936AbZBHBag (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Feb 2009 20:30:36 -0500
In-Reply-To: <20090206172641.GH30540@outback.rfc2324.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Maximilian Wilhelm wrote:
> Anno domini 2009 David Goulet scripsit:
> 
> Hi!
> 
>> For a University Project, I'm trying to take back the ct_sync
>> project and make it work on >= linux kernel 2.6.26. The last patches
>> I found are for linux 2.6.10 and much have changed since then. They
>> are no longer applicable unless major changes.
> 
> I some time ago[tm] made up patches for 2.6.15/16.
> If you *really* want to go for ct_sync, you might want to have a look
> at http://files.rfc2324.org/patches/ct_sync/
> 
>> Is there any other group or "hidden svn" that maintain or contain up
>> to date stuff?
>> What's your best advice guys for this project? Is it realistic to
>> take it back or not?
> 
> Why do you want to?
> The user space deamon conntrackd has been developed and evolved as a
> successor of ct_sync and can be used with any current kernel
> supporting netlink without patching.

Indeed:

http://conntrack-tools.netfilter.org/

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
