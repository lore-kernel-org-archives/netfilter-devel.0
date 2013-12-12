From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: Merging iptables-nftables into iptables
Date: Thu, 12 Dec 2013 11:15:58 +0200
Message-ID: <52A97ECE.8020000@linux.intel.com>
References: <20131204114834.GA13280@localhost> <CAOkSjBj5z7x+15Dmw-EWtqiBWfv4h+DBO0s7KNeZgkgrZP4g+w@mail.gmail.com> <20131205082409.GB4557@localhost> <52A0ED02.40603@pandora.be> <20131205215447.GA4367@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18618 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3LLJQB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:16:01 -0500
In-Reply-To: <20131205215447.GA4367@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo and Bart,

> Regarding arptables, there's still one limitation that we have to
> resolve as it only allows EUI-64 addresses (which should be the most
> common case), the arptables kernel code seems to support variable
> length hardware addresses up to 128 bytes long IIRC. Tomasz has been
> working on that for a while.

Actually I have a question about that.
On INPUT or OUTPUT I guess we need to handle input device and output 
device, respectively.

What about FORWARD? Still input device? Afaik the output device is not 
know yet at that point, is it?

Thanks,

Tomasz
