From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem with ipset on sparc64
Date: Wed, 4 Nov 2009 22:19:53 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911042219050.13080@obet.zrqbmnf.qr>
References: <4513233BE7DF454BB62D30017EEE55436CFB9228C3@GVW1115EXC.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55859 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932630AbZKDVTt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:19:49 -0500
In-Reply-To: <4513233BE7DF454BB62D30017EEE55436CFB9228C3@GVW1115EXC.americas.hpqcorp.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-11-04 22:07, Chini, Georg (HP App Services) wrote:

>Hello,
>
>I'm using ipset 3.2 on a sparc64 system (ultra2), kernel 2.6.31.5, Debian 5.
>Everything works fine, but the -L option shows strange values for a portmap.
>Example:
>Added Port 10, 20 and 456 to map xyz. Ipset -L xyz shows:

If you explicitly compile ipset as a 64-bit program rather than the
32-bit default that is used on sparc, will the correct values be
shown?

>Members:
>42
>52
>488
>Bindings:
>
>The iptables match works correctly, it is just the listing.
>Any idea what's wrong?
