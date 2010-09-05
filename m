From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: fragmented packet
Date: Sun, 5 Sep 2010 17:54:34 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009051754280.9116@obet.zrqbmnf.qr>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com> <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr> <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com> <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
 <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nicola Padovano <nicola.padovano@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41919 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0IEPyf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Sep 2010 11:54:35 -0400
In-Reply-To: <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2010-09-05 17:24, Changli Gao wrote:

>On Sun, Sep 5, 2010 at 5:45 PM, Nicola Padovano
><nicola.padovano@gmail.com> wrote:
>> i'm so sorry...i've said ethernet mtu=16bytes...........
>
>the minimal size of an ethernet frame is 60 bytes.

But loopback is not an ethernet device.
