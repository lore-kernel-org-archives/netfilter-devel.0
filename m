From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] xtables: Add locking to prevent concurrent instances
Date: Wed, 22 May 2013 16:04:28 -0400
Message-ID: <20130522200428.GA12199@gmail.com>
References: <20130522173511.GB860@gmail.com>
 <65164901-9a18-4349-973f-6b541beba6b3@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36910 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756323Ab3EVUEf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 16:04:35 -0400
Received: by mail-oa0-f46.google.com with SMTP id h2so3321968oag.19
        for <netfilter-devel@vger.kernel.org>; Wed, 22 May 2013 13:04:34 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <65164901-9a18-4349-973f-6b541beba6b3@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 22, 2013 at 09:29:06PM +0200, Patrick McHardy wrote:
> If I'm not mistaken, we retry failed operations since a few years now, so is this actually still a problem? 
> 
> If so, why abort after three tries instead of waiting until the lock can be acquired?

Not sure what you are referring to with retrying operations.  The race condition
between multiple simultaneous instances of iptables running still exists in
latest git.  For example, fire up a few simultanous instances of this:

# while : ;  do iptables -A INPUT -j ACCEPT ; iptables -D INPUT -j ACCEPT ; done
iptables: Resource temporarily unavailable.
iptables: Resource temporarily unavailable.
iptables: Invalid argument. Run `dmesg' for more information.
iptables: Resource temporarily unavailable.
iptables: Resource temporarily unavailable.

Bug 764 is another race problem where two simultaneous "iptables -Z" causes
counters to get reset to invalid numbers (and is reproducible with current git).  

As to your second question re: why only three tries (in 3 seconds): I suppose we
could just wait "forever".  In most normal cases I wouldn't expect a wait > 1
second for an instance to complete.  But there could be pathological corner cases
such as dumping a huge ruleset with DNS resolution (i.e. without -n) which could
take an eternity to complete.  Should we spit out (to stderr) some kind of
message in these cases, or just sit silently?  Perhaps every 5 seconds?

Phil
