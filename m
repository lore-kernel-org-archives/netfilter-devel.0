From: David Corrales <corrales.david@gmail.com>
Subject: Re: Missing kernel header files
Date: Mon, 4 Oct 2010 10:56:22 -0600
Message-ID: <AANLkTi=S0f1DR0Y0YCqtV6jqU2ugHUsDWdSDRbMjYKr_@mail.gmail.com>
References: <AANLkTinPD=3yC=KF_juTvUumXwmuMzgjrXyRg4NmML-C@mail.gmail.com>
	<alpine.LNX.2.01.1010012248410.24065@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35848 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0JDQ4X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Oct 2010 12:56:23 -0400
Received: by eyb6 with SMTP id 6so1990721eyb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Oct 2010 09:56:22 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1010012248410.24065@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Choosing arbitrary kernels is not designed to work before 1.4.3.

Oh, that's too bad :(

> Why bother with patching when just using 1.4.9 yields equivalent
> behavior?
>

Thing is that other software modules depend on this headers as well so
I wanted to minimize the impact. I rather patch than bump the version
number.
