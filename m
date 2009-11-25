From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [xtables-addons] [SOLVED] "unknown option `--gw'" for target
 TEE
Date: Wed, 25 Nov 2009 11:46:55 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0911251146470.30088@obet.zrqbmnf.qr>
References: <20091125083434.GC4295@lxiv.inria.fr> <20091125101012.GD4295@lxiv.inria.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	=?UTF-8?Q?Sebastian_Cla=C3=9Fen?= <sebastian.classen@freenet.de>
To: Olivier Mehani <shtrom@ssji.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36310 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758447AbZKYKqu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:46:50 -0500
In-Reply-To: <20091125101012.GD4295@lxiv.inria.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>Replying to self, funny how a night's sleep help find new approaches.
>
>On Wed, Nov 25, 2009 at 09:34:34AM +0100, Olivier Mehani wrote:
>> # ip6tables -t mangle -A PREROUTING -i eth0 -j TEE --gw PFX1:46ff:fee0:dfcc
>> ip6tables v1.4.5: unknown option `--gw'
>> Try `ip6tables -h' or 'ip6tables --help' for more information.
>> 
>> As far as my understanding of the doc goes, my command is valid, but it
>> doesn't work.
>
>In contradiction with the documentation, the proper parameter is
>actually --gateway, thus
># ip6tables -t mangle -A PREROUTING -i eth0 -j TEE --gateway PFX1:EUI64
>works like a charm.
>
>Maybe the documentation should be udpated as per the attached patch?
>It removes all occurences of --gw in the dor and error messages, and
>adds a quick example (quite similar to my scenario).

Yes fixed.
