From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH next v3] iptables: add xt_bpf match
Date: Tue, 22 Jan 2013 02:03:02 -0800
Message-ID: <CAHo-Oow5fE-V=gbP7auq0LJjgZJE_P+rA9QcHCgiFNynEh0AeQ@mail.gmail.com>
References: <1357776502-21555-1-git-send-email-willemb@google.com>
	<1357776944-28805-1-git-send-email-willemb@google.com>
	<20130117235328.GA16224@1984>
	<CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
	<20130121134434.GA12865@1984>
	<20130122084657.GE8541@breakpoint.cc>
	<alpine.DEB.2.00.1301221021060.31599@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Willem de Bruijn <willemb@google.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:36650 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab3AVKDD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:03:03 -0500
Received: by mail-vb0-f41.google.com with SMTP id l22so2521855vbn.14
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Jan 2013 02:03:02 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.1301221021060.31599@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With (b) the static iptables binary doesn't grow by the size of the
libpcap library.
I think this is a worthy goal.
