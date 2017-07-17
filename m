From: sorcus@inwebse.com
Subject: Re: Problem with snat.
Date: Mon, 17 Jul 2017 12:50:11 +0000
Message-ID: <851e0a73c4138e932ff6a9f40cc79696@inwebse.com>
References: <366821a9f3ba0d10162c23ef0e2c27e8@inwebse.com>
 <CAOkSjBin_=55oxx=HdY9aLAdE4vC0NJt8ne1kT4H470E82T0qA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from static.118.237.9.5.clients.your-server.de ([5.9.237.118]:56906
        "EHLO server.inwebse.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751290AbdGQMuN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 08:50:13 -0400
In-Reply-To: <CAOkSjBin_=55oxx=HdY9aLAdE4vC0NJt8ne1kT4H470E82T0qA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thank you so much. Now it's working.

On 2017-07-17 06:22, Arturo Borrero Gonzalez wrote:
> You are probably lacking the reply NAT chain, which needs to be 
> registered.
> 
> https://wiki.nftables.org/wiki-nftables/index.php/Performing_Network_Address_Translation_(NAT)
> 
> I'm updating right now the wiki to put this in bold.

