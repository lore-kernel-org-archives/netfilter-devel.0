From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] extensions: libxt_sctp: Add translation to nft
Date: Wed, 2 Mar 2016 15:47:32 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603021539140.17720@nerf40.vanv.qr>
References: <20160301204056.GA18229@gmail.com> <20160302114826.GA3493@salvia> <20160302115453.GA4365@salvia> <CAKHNQQHaEwP1u0eSzjMnQ2Zc1heLLiHoSYJ+-i4-QP=qBuwzew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37930 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbcCBOrf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 09:47:35 -0500
In-Reply-To: <CAKHNQQHaEwP1u0eSzjMnQ2Zc1heLLiHoSYJ+-i4-QP=qBuwzew@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2016-03-02 15:14, Shivani Bhardwaj wrote:
>>
>> This crazy thing seems to be valid:
>>
>>         iptables -I INPUT -p sctp -m sctp

This is how all protocols are loaded. It can be readily seen
in a iptables-save dump. One tests the L3 header field, the other
loads the module for further options to do tests on L4 fields.

>>
>> and this will be translated as:
>>
>>         nft add rule filter INPUT ip protocol sctp sctp

that seems correct, does it not?
"sctp" is just a shorthand representation for "sctp port 1:65535".
