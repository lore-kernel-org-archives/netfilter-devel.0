From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Mon, 08 Mar 2010 12:13:39 +0100
Message-ID: <4B94DBE3.60809@trash.net>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com> <1267217680-22677-2-git-send-email-chifflier@edenwall.com> <4B892440.7030002@netfilter.org> <20100228140655.GC16135@piche.inl.fr> <4B8A99B6.5080708@netfilter.org> <20100228180505.GD16135@piche.inl.fr> <4B90E7C2.6030208@trash.net> <4B913B04.6020701@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab0CHLNl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:13:41 -0500
In-Reply-To: <4B913B04.6020701@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>>> Or do you have any preferred solution ? Maybe using nlattr + one special
>>> function for dealing with 64 bits variables ?
>> I'd suggest to add a function that reads the data in 4 byte
>> quantities.
> 
> Would memcpy() be enough? If so, we can go back to the 4 bytes alignment.

Both are fine.
