From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sat, 12 Dec 2015 17:34:55 -0200
Message-ID: <566c76e3.0303810a.334b3.fffffd08@mx.google.com>
References: <n4g4s8$4pr$1@ger.gmane.org>
	<566BEF33.7090501@gmail.com>
	<alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
	<566C09F5.6080606@gmail.com>
	<alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
	<566C0E75.6080800@familie-kuntze.de>
	<20151212191019.GA10759@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Noel Kuntze <noel@familie-kuntze.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Remzi =?UTF-8?B?QUtZw5xa?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33469 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbbLLTfD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2015 14:35:03 -0500
In-Reply-To: <20151212191019.GA10759@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 12 Dec 2015 20:10:19 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> For the record, -m state is *not* deprecated.
> 
> This syntax is still supported and will always be.

	Thanks, but why it works on Linux 4.3.0 and it doesn't work on
Linux 4.3.1 and above? Any hints?

-- 
Linux 4.3.2: Blurry Fish Butt
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
