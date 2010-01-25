From: Felipe W Damasio <felipewd@gmail.com>
Subject: Re: ebtables extension 'http'
Date: Mon, 25 Jan 2010 12:32:06 -0200
Message-ID: <8a87046f1001250632hd4220d1s9f44cad2c3b268a8@mail.gmail.com>
References: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>
	 <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:37586 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab0AYOcJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:32:09 -0500
Received: by ywh6 with SMTP id 6so3110678ywh.4
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2010 06:32:08 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

   Hi Mr. Jan,

2010/1/25 Jan Engelhardt <jengelh@medozas.de>:
> For the same reason:
> http://l7-filter.sourceforge.net/FAQ#usage

  Right, thanks!

  But I just don't see the point of letting all the http traffic flows
through squid since it'll only care about a handful of domains...

  I don't suppose there is a way  of "putting" the connection back on
the forwarding-state on the bridge after ebtables already dropped it
on the broute table, is there?

  I was trying to get something like "if the domain is not
www.amazon.com, but it back on the bridge"...

  Thanks!

Felipe Damasio
