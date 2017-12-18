From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] Can someone please review my latest wiki update
Date: Mon, 18 Dec 2017 10:48:16 +0100
Message-ID: <20171218094816.ejlo4swg67ywyomy@salvia>
References: <20171216092210.GA22043@dimstar.local.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758323AbdLRJsV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 04:48:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A945E25D37
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2017 10:48:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7DE6111A050
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2017 10:48:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 962D411A050
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2017 10:48:06 +0100 (CET)
Received: from us.es (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 915584265A2F
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Dec 2017 10:48:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171216092210.GA22043@dimstar.local.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Duncan,

On Sat, Dec 16, 2017 at 08:22:10PM +1100, Duncan Roe wrote:
> Hi,
> 
> For those who contribute to the wiki:
> 
> I updated https://wiki.nftables.org/wiki-nftables/index.php/Flow_tables section
> "Doing iptables hashlimit with nft" in light of trying the examples.
> 
> There's more in the associated discussion page,

"Notice also that the translator defaults --hashlimit-htable-expire and
--hashlimit-burst to 1000 milliseconds and 5 packets respectively so
''timeout 1s'' and ''burst 5 packets'' are inserted. You may remove
either or both of these if you wish."

I think we can just skip printing default values in the translation, I
mean, we can "fix" the translation instead.

BTW, this reminds me we should also expose the missing options such as
hashlimit-htable-max and hashlimit-htable-gcinterval, those can be
exposed too, it just needs some code in nft, I'll add this to my TODO
list.

Let us know, thanks for reviewing documentation!
