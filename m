From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: RFC: Synopsis syntax change in nft.8
Date: Fri, 11 Aug 2017 00:53:18 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1708110051140.10879@n3.vanv.qr>
References: <20170810182932.GJ16375@orbyte.nwl.cc> <nycvar.YFH.7.76.1708110003470.10879@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:57650 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752135AbdHJWxT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 18:53:19 -0400
In-Reply-To: <nycvar.YFH.7.76.1708110003470.10879@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2017-08-11 00:44, Jan Engelhardt wrote:
>Some history for the mail archives: {} is not specified, but follows from
>prominent use of | inside [] and the desire to have some kind of grouping for
>non-optional things. I will — cautiously — claim that {} was an idea of mine
>(barring any fourth party uses in completely unrelated projects elsewhere that
>I do not know of); commit iptables.git#a8ad34cf11540d147b8aded6826a1452841d2aa7
>was the first to use '{}'.

Ohwell, notsomuch. I found some {} in
iproute2#985794ad38a55b214fae1c51058a81febef1941b dated 2004, so that is
probably where I might have got the idea from. Credit where credit is due!
