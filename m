From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Redirect target for IPv6 inclusion
Date: Tue, 29 May 2012 13:20:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205291320040.27038@frira.zrqbmnf.qr>
References: <008001cd3d8c$8f4238d0$adc6aa70$@telsatbb.vu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Steve (Telsat Broadband)" <steve@telsatbb.vu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:46906 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab2E2LUs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 May 2012 07:20:48 -0400
In-Reply-To: <008001cd3d8c$8f4238d0$adc6aa70$@telsatbb.vu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-05-29 13:16, Steve (Telsat Broadband) wrote:

>Hi All,
>
>I've seen a reference that a REDIRECT target for IPv6 is being worked on and
>I would like to know if/when it might be included into ip6tables?  This
>redirect target forms a very large part of our network access server and is
>critical for our IPv4 operations and will also be critical for us to start
>operating with IPv6.

There is already redirect-to-local with -j TPROXY.
