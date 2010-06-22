From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Utilization of Multi-core hardware by Netfilter
Date: Tue, 22 Jun 2010 18:01:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006221801230.1731@obet.zrqbmnf.qr>
References: <AANLkTik76jQGjSbpXUo29e_75fUV_m8uQxLqEpW9jte5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43526 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701Ab0FVQBg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:01:36 -0400
In-Reply-To: <AANLkTik76jQGjSbpXUo29e_75fUV_m8uQxLqEpW9jte5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-06-22 16:38, Anand Raj Manickam wrote:

>Hi,
>I am  pumping data at a connection rate of 6000 connections per second
> on  a Dual Core CPU .
>But CPU 0 is the one which is always occupied  upto 100% and CPU 1 is
>always 98-100% idle  and after CPU0 reaches 100% connections starts to
>fail.
>Any pointers other than RPS/RFS  to load balance the CPU utilization ?
>I m using linux-2.6.26 kernel .

It's not in 2.6.26.
