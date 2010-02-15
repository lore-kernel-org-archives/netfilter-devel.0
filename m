From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/10] netfilter: CONFIG_COMPAT: allow delta to exceed
 32767
Date: Mon, 15 Feb 2010 18:08:04 +0100
Message-ID: <4B797F74.9020103@trash.net>
References: <1265897559-10610-1-git-send-email-fw@strlen.de> <1265897559-10610-4-git-send-email-fw@strlen.de> <4B797759.7030106@trash.net> <20100215163759.GA20183@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64784 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab0BORIH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:08:07 -0500
In-Reply-To: <20100215163759.GA20183@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
>>> This happens because the compat delta is using a short int.
>>> Easily reproducible via "iptables -m limit" ; after about 2050
>>> rules inserting new ones fails with -ELOOP.
>>>
>>> Note that compat_delta included 2 bytes of padding on x86_64, so
>>> structure size remains the same.
>> The first three patches already look fine, I'll apply those
>> after a bit of testing. The remaining ones should get submitted
>> very soon in order to still make the 2.6.34 merge window.
> 
> Thanks, I'll send out v3 of the patches (only changes are the ones suggested
> by Bart) once those three appear in nf-next-2.6.

Great, thanks. They should be in the tree within the next two or
three hours.
