From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 5/5] add xtables-multi{32,64} recognition
Date: Tue, 19 Apr 2011 01:55:15 -0700
Message-ID: <BANLkTinY9SzKLS0FrqEdLR74+Ty5SqdPtQ@mail.gmail.com>
References: <BANLkTikeSwL=TU9nPFsUJeLXTHnPdu5BUg@mail.gmail.com>
	<1303176233-14063-5-git-send-email-zenczykowski@gmail.com>
	<alpine.LNX.2.01.1104190950260.25800@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58026 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1DSIzQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:55:16 -0400
Received: by wwa36 with SMTP id 36so6692133wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Apr 2011 01:55:15 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104190950260.25800@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I do not see a reason to having these names added. If you do have
> more than one iptables program with different configuration installed
> in your custom environment, use some custom shell scripts to readout $0
> and pass control to whatever instance.

Fair enough, I can easily keep this change locally.

(FYI, in this particular case the wrapper is actually a generic
arch-based dispatch binary used for many other binaries as well: you
symlink /bin/prog to /bin/arch_dispatch, and then /bin/prog32 or
/bin/prog64 gets called,
ultimately probably the dispatcher should be fixed to pass 'prog'
instead of 'prog32' or 'prog64' as argv[0].)

- Maciej
