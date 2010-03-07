From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libnetfilter_conntrack alignment issue [was Re: [PATCH 1/2] Add
 new input plugin UNIXSOCK]
Date: Sun, 7 Mar 2010 20:30:36 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003072030190.31962@obet.zrqbmnf.qr>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr> <4B8A99B6.5080708@netfilter.org> <20100228180505.GD16135@piche.inl.fr>
 <4B8C16A4.9010807@netfilter.org> <alpine.LSU.2.01.1003031841130.23267@obet.zrqbmnf.qr> <4B90DC01.3050306@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35775 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab0CGTaw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Mar 2010 14:30:52 -0500
In-Reply-To: <4B90DC01.3050306@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-03-05 11:25, Pablo Neira Ayuso wrote:
>
>> 18:41 ares:/home/jengelh # conntrack -L
>> Bus error
>> 18:41 ares:/home/jengelh # file `which conntrack`
>> /usr/sbin/conntrack: ELF 32-bit MSB executable, SPARC32PLUS, V8+ Required,
>> version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.4,
>> not stripped
>
>The following patch should fix the problem that you are reporting. Let
>me know if you have more issues.

The patch works, thanks.
