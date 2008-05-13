From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Tue, 13 May 2008 18:32:02 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805131734130.448@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805131620450.448@fbirervta.pbzchgretzou.qr> <4829B177.9000501@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60849 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbYEMQcF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 12:32:05 -0400
In-Reply-To: <4829B177.9000501@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-05-13 17:19, Patrick McHardy wrote:
>> 
>> Fact is there has been going a lot of work into keeping it in git-style
>> shape. It's alright if you do not trust it, but then
>> again, it would be a waste to run with a crippled-metadata repo
>> or to do the conversion again.
>
> True, but as a matter of principle, I can't use an untrusted repository.
>
> And anyways, I also don't see anything wrong with simply starting with
> a clean history by only importing the latest version, In that case I'd
> have no problem using your fixed-up repository as historical reference.
>
I think this idea came up back in February already (starting from a
new slate), I am fine with that.

Though, what's wrong with stitching the first version of the
new repository to the last version of the old one?
