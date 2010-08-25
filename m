From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Fwd: help needed with EXPORT_SYMBOL
Date: Wed, 25 Aug 2010 12:06:35 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1008251204270.27274@obet.zrqbmnf.qr>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>  <1282540448.4080.86.camel@aijazbaig1-desktop>  <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>  <1282569477.2605.1798.camel@laptop>  <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
  <1282572346.2605.1856.camel@laptop>  <AANLkTimQDV74kcM_84QySMKmdf-XxFOhqp48cQdQNN4s@mail.gmail.com>  <AANLkTinRyoHcSmmHv9tZ36X4wxVVCKGLDwGiZUTPPn+z@mail.gmail.com>  <1282625054.4080.152.camel@aijazbaig1-desktop>  <AANLkTi=cj+qCFxeT5hq0-x-XqSUCbcqQRAwmQ9h+cOxy@mail.gmail.com>
  <AANLkTim9nvJR0K6xJc2kHGCeoMzFLzSxR8Avx59jsEbf@mail.gmail.com> <1282728478.17044.22.camel@aijazbaig1-desktop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: brgerst@gmail.com, peterz@infradead.org,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Aijaz Baig <aijazbaig1@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38130 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069Ab0HYKGg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:06:36 -0400
In-Reply-To: <1282728478.17044.22.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-08-25 11:27, Aijaz Baig wrote:

>By the way Jan I couldnt find bridge.c although there is an object file
>called bridge.o within /net/bridge.

$ git grep -e br_handle_frame_hook v2.6.35 net/bridge/

See that, which is used kernel<-module. This frame hook has been changed 
in 2.6.36-rc1 which is why looking at 2.6.35 would be the short route.
