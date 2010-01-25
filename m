From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ebtables extension 'http'
Date: Mon, 25 Jan 2010 17:35:42 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001251707500.20906@obet.zrqbmnf.qr>
References: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>  <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr> <8a87046f1001250632hd4220d1s9f44cad2c3b268a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Felipe W Damasio <felipewd@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59310 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab0AYQfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:35:43 -0500
In-Reply-To: <8a87046f1001250632hd4220d1s9f44cad2c3b268a8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-01-25 15:32, Felipe W Damasio wrote:
>> For the same reason:
>> http://l7-filter.sourceforge.net/FAQ#usage
>
>  Right, thanks!
>
>  But I just don't see the point of letting all the http traffic flows
>through squid since it'll only care about a handful of domains...
>
>  I don't suppose there is a way  of "putting" the connection back on
>the forwarding-state on the bridge after ebtables already dropped it
>on the broute table, is there?

Once you decided which machine handles the packet stream, it's decided. 
The twist is, you have to decide when you see the very first packet.
