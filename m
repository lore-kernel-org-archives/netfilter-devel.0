From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xtables: Add locking to prevent concurrent instances
Date: Wed, 22 May 2013 22:11:36 +0200
Message-ID: <e2bb3ad5-d865-4de3-829f-74cb8109d94a@email.android.com>
References: <20130522173511.GB860@gmail.com> <65164901-9a18-4349-973f-6b541beba6b3@email.android.com> <20130522200428.GA12199@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47487 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3EVULs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 16:11:48 -0400
In-Reply-To: <20130522200428.GA12199@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Phil Oester <kernel@linuxace.com> schrieb:

>On Wed, May 22, 2013 at 09:29:06PM +0200, Patrick McHardy wrote:
>> If I'm not mistaken, we retry failed operations since a few years
>now, so is this actually still a problem? 
>> 
>> If so, why abort after three tries instead of waiting until the lock
>can be acquired?
>
>Not sure what you are referring to with retrying operations.  The race
>condition
>between multiple simultaneous instances of iptables running still
>exists in
>latest git.  For example, fire up a few simultanous instances of this:
>
># while : ;  do iptables -A INPUT -j ACCEPT ; iptables -D INPUT -j
>ACCEPT ; done
>iptables: Resource temporarily unavailable.
>iptables: Resource temporarily unavailable.
>iptables: Invalid argument. Run `dmesg' for more information.
>iptables: Resource temporarily unavailable.
>iptables: Resource temporarily unavailable.
>
>Bug 764 is another race problem where two simultaneous "iptables -Z"
>causes
>counters to get reset to invalid numbers (and is reproducible with
>current git).  

I see, thanks.

>As to your second question re: why only three tries (in 3 seconds): I
>suppose we
>could just wait "forever".  In most normal cases I wouldn't expect a
>wait > 1
>second for an instance to complete.  But there could be pathological
>corner cases
>such as dumping a huge ruleset with DNS resolution (i.e. without -n)
>which could
>take an eternity to complete.  Should we spit out (to stderr) some kind
>of
>message in these cases, or just sit silently?  Perhaps every 5 seconds?

Printing a message sounds fine. But I think the main point of using locking is to provide a guarantee that a correct operation won't randomly fail. So I think we should retry forever.

