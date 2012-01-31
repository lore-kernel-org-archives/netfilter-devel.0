From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Alter TCP packet not work fine with netfilter hook
Date: Tue, 31 Jan 2012 16:37:46 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201311637230.27841@frira.zrqbmnf.qr>
References: <CAF4uzgWbtvmyum-5tmfjmWKQi6ev=+=O52ENvq9png=jhdpiGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: nt pm <ntph.minh@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:55636 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2AaPhr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:37:47 -0500
In-Reply-To: <CAF4uzgWbtvmyum-5tmfjmWKQi6ev=+=O52ENvq9png=jhdpiGw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-01-31 05:50, nt pm wrote:

>Hi netfilter family,
>I'm a newbie to netfilter.
>I have just developt a crypto module using netfilter hook.
>In this module :
>SENDER : IP payload will be encrypted at POST ROUTING hook
>RECEIVE : IP payload wil be decrypted at PRE ROUTING hook.
>
>The module work fine with ICMP & UDP but it NOT work fine with TCP: 2
>machine still receive packet at hook but application not communicate
>together.
>
>I don't know whether any mystery in netfilter or linux network kernel at here?

And what makes you think we would know what happens in your hidden code?
