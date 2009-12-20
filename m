From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [xtables-addons][PATCH 0/2] Misc ipset issues
Date: Sun, 20 Dec 2009 10:36:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0912201029550.11541@blackhole.kfki.hu>
References: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kevin Locke <kevin@kevinlocke.name>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:53176 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZLTJgj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:36:39 -0500
In-Reply-To: <1261255847-16395-1-git-send-email-kevin@kevinlocke.name>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, 19 Dec 2009, Kevin Locke wrote:

> I ran across a few issues getting ipset to work on my system and
> wanted to bring them up here for consideration.
> 
> The first is that in 2.6.33-rc1, sk_buff->iff was renamed to
> sk_buff->skb_iif, which breaks compilation on kernels going forward.
> 
> The second issue is that the setlist module is currently not being
> built which results in "ipset v4.1: Unknown set type" when attempting
> to create a set of this type (as documented in the man page).  I'm not
> sure if this is intentional (if it is, feel free to ignore that
> patch), but in my experience it has worked quite well with the
> exception of -T not working as expected (or at all AFAICT).

These are xtables-addons related issues, Jan'll take care of them.
 
> Another issue, for which I did not include a patch, is how automatic
> resizing of hash tables is handled.  If I restore a file (created
> outside ipset) which contains somewhere near (but less than) 65000
> entries which do not hash to unique values I start getting log
> messages like the following:
> 
> /usr/src/modules/xtables-addons/ipset/ip_set_nethash.c: nethash_retry: rehashing of set setname triggered: hashsize grows from 44319 to 66478
> /usr/src/modules/xtables-addons/ipset/ip_set_nethash.c: nethash_retry: rehashing of set setname triggered: hashsize grows from 66478 to 99717
> 
> and ipset -R silently fails to restore the rest of the file (returning
> exit code 0).  I realize that there may be some code to deal with this
> during save (or when adding entries using -A), but it would be very
> helpful if the user could be warned about the failure during -R as
> well. 

You are hitting the internal (and somewhat artifical) limit of max 65535 
entries in a set. When rehashing, the next tried hash size was larger than 
the limit so it failed. It should be reported back, you are right.

> As a side note:  One use case is when building a large set it
> is significantly (on the order of 1000 times on my test system) faster
> to build the list and use -R than individually with -A).

That's normal, restore mode spares a lot of system calls.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
