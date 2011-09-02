From: Dan McGee <dan@archlinux.org>
Subject: Re: iptables: libxt_statistic.so undefined symbol: lround
Date: Fri, 2 Sep 2011 08:51:36 -0500
Message-ID: <CAEik5nN4W3W-51Zj=Yd-33uATD1TLZg0K4+N7RfWhKr7=78fRw@mail.gmail.com>
References: <CAEik5nPmurYA8tysJ7+LRH-uM5Nx=Odr-YYwsrxUKGFivQu1BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38090 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1IBNvi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:51:38 -0400
Received: by bke11 with SMTP id 11so2676201bke.19
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Sep 2011 06:51:37 -0700 (PDT)
In-Reply-To: <CAEik5nPmurYA8tysJ7+LRH-uM5Nx=Odr-YYwsrxUKGFivQu1BQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ping? Do I need to report this somewhere else? Not fixed in the just
released 1.4.12.1.

-Dan

On Tue, Aug 9, 2011 at 10:35 AM, Dan McGee <dan@archlinux.org> wrote:
> Arch Linux bug report: https://bugs.archlinux.org/task/25358
>
> Looks like this is simply a case of not adding -libm to xt_statistic
> after this [1] commit, should be a quick fix.
>
> Thanks!
> -Dan
>
> [1] http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=39d3aa36ea38668a2c343b5af42b2d8d3616a9de
>
