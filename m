From: David Newall <davidn@davidnewall.com>
Subject: Re: cups slow on linux-2.6.24
Date: Fri, 01 Feb 2008 11:17:14 +1030
Message-ID: <47A26C12.9020801@davidnewall.com>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>  <Pine.LNX.4.64.0801290855360.19273@blackhole.kfki.hu>  <b6a2187b0801291924k15f883aeg54f704156e4f2e3e@mail.gmail.com>  <47A07FEA.3000702@trash.net>  <b6a2187b0801301823m331957e9n9d9bb9613622c844@mail.gmail.com>  <b6a2187b0801301826l5a50ce84p7d5dce3d0a74b3c0@mail.gmail.com>  <47A13573.7090804@trash.net>  <b6a2187b0801301921s4a7842cg6cfec09a393cd63@mail.gmail.com>  <47A13FBD.8050803@trash.net> <b6a2187b0801302101l46d614c9y53f798a025b57dc3@mail.gmail.com> <Pine.LNX.4.64.0801311136540.23769@blackhole.kfki.hu> <47A21945.2050005@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jeff Chua <jeff.chua.linux@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>,
	Krzysztof Piotr Oledzki <ole@ans.pl>,
	"David S. Miller" <davem@davemloft.net>,
	cups-bugs <cups-bugs@easysw.com>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hawking.rebel.net.au ([203.20.69.83]:33645 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934749AbYBAArV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:47:21 -0500
In-Reply-To: <47A21945.2050005@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jozsef Kadlecsik wrote:
>> Strange, but there are a lot of incorrect checksum packets. How does
>> it come on the loopback interface?
>
> Loopback doesn't perform full checksumming, so thats expected.

The question remains: How do loopback packets get incorrect checksum? 
Where and how can they get corrupted?
