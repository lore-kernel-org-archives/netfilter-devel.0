From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH v2 0/10] netfilter: ebtables: CONFIG_COMPAT support
Date: Sat, 13 Feb 2010 14:20:48 +0100
Message-ID: <4B76A730.4000203@pandora.be>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:56651 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab0BMNU5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:20:57 -0500
In-Reply-To: <1265897559-10610-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal schreef:
> Hello everyone,
> 
> this is version 2 of the ebtables CONFIG_COMPAT patch set.
> 
> First patches are minor bug fixes/preparation patches.  Patch 7 is the
> main CONFIG_COMPAT hunk, 8 handles those ebtables binaries specifically
> built for 64 bit kernel (i.e. pad in userspace).
> 
> Last two patches add CONFIG_COMPAT support to the targets/matches that
> need special handling (maybe I missed some, though).
> 
> Tested on x86_64 with x86 userland by comparing output of 32 and 64 bit ebtables binaries.


One little cleanup that could be done is remove the last use of MEMPRINT
and the corresponding macro in patch 5/10.
For patch 8/10, I'd just remove the BUGPRINT line instead of adding the
compat argument to copy_counters_to_user().
But apart from that, the patches look ok to me (patch 10 was missing I
think).

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
