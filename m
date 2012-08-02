From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Local port forwarding and IP_NF_NAT_LOCAL
Date: Thu, 2 Aug 2012 23:15:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208022314340.20545@frira.zrqbmnf.qr>
References: <CAKZGBhjfz1cXH1SFH__HhN23z8e11Zs=ip_naUXbz4EVQV8ckw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Fergal Meath <fergalme@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:55540 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab2HBVPM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:15:12 -0400
In-Reply-To: <CAKZGBhjfz1cXH1SFH__HhN23z8e11Zs=ip_naUXbz4EVQV8ckw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-08-02 13:58, Fergal Meath wrote:

>Hi,
>
>I have an SSH tunnel from my office to my home linux server box.
>On my linux server box, I am trying to forward all port 80 traffic to
>another device on my home network 192.168.1.1.
>This is to allow me to remotely configure the other device on my home network.

Then you should use
  ssh -L 8000:192.168.1.1:80 user@homebox

and access it via http://localhost:8000/
