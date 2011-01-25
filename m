From: Patrick McHardy <kaber@trash.net>
Subject: Re: Filter input traffic by uid
Date: Tue, 25 Jan 2011 15:06:05 +0100
Message-ID: <4D3ED8CD.9040902@trash.net>
References: <AANLkTikXDsRGoV4aFDxpWzdU9Pov=_-=6dMB=cbmtpQu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Glauco Junquera <glaucoaok@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54668 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab1AYOGO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:06:14 -0500
In-Reply-To: <AANLkTikXDsRGoV4aFDxpWzdU9Pov=_-=6dMB=cbmtpQu@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.01.2011 13:04, Glauco Junquera wrote:
> Hi All,
> 
> Iptables can filter output traffic by uid, for example iptables -A
> OUTPUT -m owner --uid-owner 100 -p udp -j DROP.
> I need to implement the same for input traffic. Anyone have any idea
> of how can i do it (where i must start)? I am new to netfilter
> development i tried some simple modifications on code with no success.
> I would really appreciate any kind of help.

I've added socket layer hooks a couple of years ago for that
purpose, but we've never merged it. James Morris based some
work on them, I think this should be the latest version:

http://people.redhat.com/jmorris/selinux/skfilter/kernel/
