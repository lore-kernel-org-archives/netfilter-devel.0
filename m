From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter moving to git
Date: Wed, 14 May 2008 18:28:37 +0200
Message-ID: <482B1335.30200@trash.net>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805131620450.448@fbirervta.pbzchgretzou.qr> <4829B177.9000501@trash.net> <alpine.LNX.1.10.0805131734130.448@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46315 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYENQ2j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 12:28:39 -0400
In-Reply-To: <alpine.LNX.1.10.0805131734130.448@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-05-13 17:19, Patrick McHardy wrote:
>>> Fact is there has been going a lot of work into keeping it in git-style
>>> shape. It's alright if you do not trust it, but then
>>> again, it would be a waste to run with a crippled-metadata repo
>>> or to do the conversion again.
>> True, but as a matter of principle, I can't use an untrusted repository.
>>
>> And anyways, I also don't see anything wrong with simply starting with
>> a clean history by only importing the latest version, In that case I'd
>> have no problem using your fixed-up repository as historical reference.
>>
> I think this idea came up back in February already (starting from a
> new slate), I am fine with that.
> 
> Though, what's wrong with stitching the first version of the
> new repository to the last version of the old one?


That would work, but Yasuyuki already provided me with the
information for properly tagging the tree, so I'll keep the
current iptables repository. Thanks anyway.

