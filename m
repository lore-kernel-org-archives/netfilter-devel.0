From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Wed, 3 Mar 2010 18:42:42 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003031841130.23267@obet.zrqbmnf.qr>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr> <4B8A99B6.5080708@netfilter.org> <20100228180505.GD16135@piche.inl.fr>
 <4B8C16A4.9010807@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52767 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0CCRmn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Mar 2010 12:42:43 -0500
In-Reply-To: <4B8C16A4.9010807@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-03-01 20:33, Pablo Neira Ayuso wrote:

>>>>>> +#define ALIGN_SIZE 8
>>>>> Minor question: why align this to 64 bits?
>>>> I originally used an alignment to 32 bits, but Jan noticed it would
>>>> break if using options/values on 64 bits (and a test confirmed that). I
>>>> took 64 bits as the biggest allowed value for integers.
>>> I would need to look into this in more detail, not sure where the
>>> problem is. I think that you can use something like `struct nlattr' (see
>>> include/linux/netlink.h) and then nla_put() to add attributes in the TLV
>>> format (see lib/nlattr.c). Those are align-safe. I'm using something
>>> similar for conntrackd for the synchronization messages (src/build.c and
>>> src/parse.c).

If they are align-safe, what's this? :-)

18:41 ares:/home/jengelh # conntrack -L
Bus error
18:41 ares:/home/jengelh # file `which conntrack`
/usr/sbin/conntrack: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required,
version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.4,
not stripped
