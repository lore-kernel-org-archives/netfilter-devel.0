From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: ulogd - rpm file generation
Date: Thu, 19 Jul 2012 23:52:32 +0100
Message-ID: <50088FB0.4020403@googlemail.com>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com> <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr> <CAAJpzgaM3KpsDuS6SpUWQjTTQtgfpGO4B8Ok3hH61SXqYtdkrw@mail.gmail.com> <alpine.LNX.2.01.1207192155210.5766@frira.zrqbmnf.qr> <CAAJpzgZYMWT4B5n8OOG=aCNfv2U6ztADB2r0KV-8ZmMtLYqD7A@mail.gmail.com> <CAAJpzgaMy3mbRMEZTLQavzmbemozexe6OPykRTrR8pKdfwh8Uw@mail.gmail.com> <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65428 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2GSWwk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:52:40 -0400
Received: by wibhq12 with SMTP id hq12so5540840wib.1
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jul 2012 15:52:38 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207192320100.6629@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> ulogd depends on libnetfilter_acct, which in turn requires glibc >= 2.9, 
> and RHEL5 is just too damn old.
>   
Nope! If libnetfilter_acct is compiled from source it does *not* require 
glibc >= 2.9 and uses the version of glibc on the host system.

It is how I managed to build (and use) ulogd on one of my FC13-based 
machines - built and installed it from source, together with its 
immediate dependencies (libnetfilter_acct-devel, libnetfilter_log-devel, 
libnfnetlink-devel & libnetfilter_conntrack_devel).

There is currently a "bug" in the main ulogd.spec file (at least for my 
Fedora distribution) as it doesn't have a BuildRequires for 
libnetfilter_acct-devel - maybe because Fedora people are too lazy and 
haven't got arround to create the libnetfilter_acct package yet.

