From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ulogd - rpm file generation
Date: Thu, 19 Jul 2012 23:21:39 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com> <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr> <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com> <alpine.LNX.2.01.1207192155210.5766@frira.zrqbmnf.qr>
 <CAAJpzgZYMWT4B5n8OOG=aCNfv2U6ztADB2r0KV-8ZmMtLYqD7A@mail.gmail.com> <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:59961 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab2GSVVm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:21:42 -0400
In-Reply-To: <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-07-19 23:13, Gomathivinayagam Muthuvinayagam wrote:

>For some packages like ulogd, conntrack there is no rpms available for
>RHEL5 version.
>It says it is disabled. Is there any reason for that?

ulogd depends on libnetfilter_acct, which in turn requires glibc >= 2.9, 
and RHEL5 is just too damn old.
