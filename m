From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: can libnetfilter_conntrack be used to write a userspace
 connection tracker?
Date: Tue, 15 Feb 2011 16:08:14 -0800
Message-ID: <AANLkTi=CjQZW5mOmgsk8yjk3Q10iDQp4VLYFqM43T+Ah@mail.gmail.com>
References: <AANLkTimfmoEKVWA_kBM-1DiuTR0=OG0Y8kC5nvq0G7G-@mail.gmail.com>
	<4D2E1EF6.1010003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61643 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1BPAIS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:08:18 -0500
Received: by qyk12 with SMTP id 12so693395qyk.19
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Feb 2011 16:08:17 -0800 (PST)
In-Reply-To: <4D2E1EF6.1010003@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 12, 2011 at 1:36 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> You can implement a user-space conntrack helper with NFQUEUE and
> libnetfilter_conntrack:
>
> http://people.netfilter.org/pablo/userspace-conntrack-helpers/
>
> You require Linux kernel >= 2.6.37

I've upgraded the kernel to
http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.37-rc2-maverick/.

I began experiencing this bug
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=612272
For me, conntrack -E expect is exiting immediately, on an almost unloaded box.

So I built the two conntrack projects from git master to see if that
would help - and got a kernel bug (see other message).

Are there any other requirements? Would it be better if I build my own
kernel? Are there any other dependency issues between the various
players here: libnfnetlink, libnfconntrack, conntrack, and the kernel?

Or is there a limit to the users of conntrack? Can my own daemon
(modelled on the ftp userspace example of yours), conntrack -E, and
other users of conntrack coexist?

Thanks,
Sam
