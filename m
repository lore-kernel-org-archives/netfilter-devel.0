From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: state match incompatibilty across versions
Date: Wed, 7 Aug 2013 21:28:49 -0400
Message-ID: <CA+0KVf0RDy0ub_R0t9Fn5-dBN2dRhZqu2+eRy36Xur7nF8EHoA@mail.gmail.com>
References: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:46166 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab3HHB3M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 21:29:12 -0400
Received: from mail-ve0-f177.google.com (mail-ve0-f177.google.com [209.85.128.177])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: google-debian@dunimos.ljlane.net)
	by dunimos.ljlane.net (Postfix) with ESMTPSA id 9F30F292D4
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2013 21:29:10 -0400 (EDT)
Received: by mail-ve0-f177.google.com with SMTP id cz11so2570141veb.36
        for <netfilter-devel@vger.kernel.org>; Wed, 07 Aug 2013 18:29:09 -0700 (PDT)
In-Reply-To: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I think I failed to explain the problem clearly. I'll try again.

If I use iptables 1.1.14 or 1.4.15 to create a match state rule,
iptables 1.4.16+ binaries do not display the state information that is
in the kernel.

https://gist.github.com/anonymous/6180482

The gist shows a way reproduce the problem. I can post that directly
on list if it's appropriate and necessary. The iptables-save output
(from iptables 1.4.16) on line 52 is missing "--state
INVALID,NEW,RELATED,ESTABLISHED,UNTRACKED". If I roll back to 1.4.15,
the info is still there.

There I used a fresh archlinux VM and compiled iptables 1.4.15 and
1.4.16 in the VM. I have the same results with Debian on VMs and HW,
with stock kernel.org and Debian kernels, and using both i686 and
amd64 and using iptables versions from 1.4.14 to 1.4.20. I'm fairly
certain it's the change between iptables 1.4.15 and 1.4.16, not any
kernel or distro influence, that is causing the problem.
