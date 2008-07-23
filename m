From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD2 PATCH 0/4] Misc cleaning
Date: Wed, 23 Jul 2008 16:43:56 +0200
Message-ID: <488743AC.4040909@trash.net>
References: <> <1216812835-9851-1-git-send-email-eric@inl.fr> <48873F55.2000706@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36700 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYGWOn7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:43:59 -0400
In-Reply-To: <48873F55.2000706@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Eric Leblond wrote:
>> The main concern here is about IPFIX which is in really bad shape. I've fix
>> some major error in one of the patch but it remains untested for now and I
>> don't think it can work properly.
> 
> Indeed. It's broken Do you plan to look into this? If not, I'll fix it
> myself. Please, let me know since I don't want to duplicate work. Do you
> also plan to send me a patch to fix all those warnings?

I think would prefer to enable the warnings that make sense
individually, -Wextra includes lots if crap like "%s expects
type char *, but argument is void *" or signedness warnings
that are compiler-detectable irrelevant 50% of the time.

OTOH a lot of the warnings in the current -git version indicate
that the code really needs more love, like missing return values
etc, so it seems we really want *some* of the new warnings.

