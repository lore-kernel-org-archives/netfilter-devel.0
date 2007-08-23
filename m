From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: nf_conntrack_ipv4 must be loaded explicitly
Date: Thu, 23 Aug 2007 17:48:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708231747220.32316@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708021937140.9319@fbirervta.pbzchgretzou.qr>
 <46B22364.9060506@trash.net> <Pine.LNX.4.64.0708171242450.5492@fbirervta.pbzchgretzou.qr>
 <46CD9F68.2060902@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764911AbXHWPsc@vger.kernel.org>
In-Reply-To: <46CD9F68.2060902@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Aug 23 2007 16:53, Patrick McHardy wrote:
>>>>After loading nf_conntrack_ipv4.ko, everything works again (also with the
>>>>"bad" ff09b7). But I have to load it explicitly, and I think that
>>>>unfortunately breaks a lot of setups (such as mine) which assume ipv4
>>>>connection tracking is always there.
>>>
>>>I already have a patch for this queued. I'll push it upstream once
>>>I get a new power supply for the box I keep that tree on, hopefully
>>>tommorrow.
>> 
>> 
>> What's that patch looking like?
>
>Upstream commit 591e6206. Doesn't it work for you?

I am sure it does, I just did not track the pulls or the log that
closely. Thanks for pointing out.


	Jan
-- 
