From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: add and use a symbol version map
Date: Wed, 19 Nov 2014 16:56:46 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1411191530470.14103@nerf08.vanv.qr>
References: <1415797607-28793-1-git-send-email-jengelh@inai.de> <20141119134224.GA12289@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:56246 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbaKSP4t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:56:49 -0500
In-Reply-To: <20141119134224.GA12289@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2014-11-19 14:42, Pablo Neira Ayuso wrote:
>On Wed, Nov 12, 2014 at 02:06:47PM +0100, Jan Engelhardt wrote:
>> It was possible to combine e.g. conntrackd-1.2.1 with
>> libnetfilter_conntrack-0.0.101, causing libc to issue an exit from
>> within conntrackd iff such a conntrackd was promoted to a master and
>> tried to call nfexp_send, due to lazy symbol resolution in libc.
>
>I wonder how you have reached such a situation. I can only think of
>very broken packaging.

To reach such a situation, the shortest way to get there is:

1. On Debian squeeze, `apt-get install conntrack`.
This would install conntrack-tools-0.9.14.

2. Install a newer version at some point,
`perl -i -pe s/squeeze/wheezy/g /etc/apt/sources.list &&
 apt-get update && apt-get install conntrack`.



The long description:

The conntrack-tools source code only checks the
libnetfilter_conntrack version only once, at build time.

The files in the top-level source directory of conntrack-tools do not
indicate any particular runtime requirement on libnetfilter_conntrack
version besides the implicit requirement of the built conntrackd on a
particular library by SONAME, in other words, the runtime
requirements are weaker than the build-time requirements.

Such a case is pretty normal, too. Build-time requirements are
generally seen as independent from runtime requirements by distros
and packagers. Some perl module may want Test::Simple at build time,
and not use it at runtime.
I cannot find that the Debian packager for conntrack-tools has
done something inappropriate.


>Would you also convert libnetfilter_conntrack to use the same
>EXPORT_SYMBOL() macro that we use in more recent libnetfilter_*
>libraries for consistency?

I can; question is, do we need it? It turns out that using
just a .map file (with implicit -fvisibility=default) gives
the same result, but requiring less steps. The map file
can also turn symbols from visible to hidden, without requiring
-fvisibility+EXPORT_SYMBOLs.
