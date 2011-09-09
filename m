From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit timing
Date: Thu, 8 Sep 2011 22:26:47 -0700
Message-ID: <CAHo-OoxL-RKrkhgPux4pt0oeCHDK6bR5zST9kiFhpyqUH6PuYw@mail.gmail.com>
References: <4E68C314.3070709@dump-Storage.net>
	<alpine.LNX.2.01.1109081652310.13219@frira.zrqbmnf.qr>
	<1315494418.2456.23.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<alpine.LNX.2.01.1109081716390.13219@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Hiroshi KIHIRA <hiro@dump-storage.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f42.google.com ([74.125.83.42]:47992 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab1IIF0r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Sep 2011 01:26:47 -0400
Received: by gwb17 with SMTP id 17so870010gwb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Sep 2011 22:26:47 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1109081716390.13219@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Propose calling it -a --atomic instead of -d --delay and maybe
--sequence --sequential or --onebyone for the opposite.
Either way doing all the parsing, then attempting to apply, and if it
fails attempting to undo it is probably the right default behaviour.
