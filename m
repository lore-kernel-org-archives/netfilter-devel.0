From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: fragmented packet
Date: Sun, 5 Sep 2010 23:24:27 +0800
Message-ID: <AANLkTi=Gv7J5K7kip0JzvDtybsF-hJV_oBm6pQpezhWb@mail.gmail.com>
References: <AANLkTikniSd5X_ryuhWbAyDLPa7oDSDULe1iYfG02vuP@mail.gmail.com>
 <alpine.LNX.2.01.1009050017350.15290@obet.zrqbmnf.qr> <AANLkTimmN8T4fw=kW+CB0Oh285wrVb4BD4_bx9k_kVxs@mail.gmail.com>
 <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49143 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab0IEPYt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Sep 2010 11:24:49 -0400
Received: by wwj40 with SMTP id 40so5307520wwj.1
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Sep 2010 08:24:48 -0700 (PDT)
In-Reply-To: <AANLkTinNdSq-PMnsYQ7Qb6E0tkhuUF71F2+9ux5OFM3h@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 5, 2010 at 5:45 PM, Nicola Padovano
<nicola.padovano@gmail.com> wrote:
> i'm so sorry...i've said ethernet mtu=16bytes...........

the minimal size of an ethernet frame is 60 bytes.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
