From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 15:38:57 +0100
Message-ID: <49BFB601.6060309@trash.net>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <49BF9F7E.3090208@trash.net> <alpine.LNX.1.10.0903171411560.17354@bizon.gios.gov.pl> <49BFA633.4010306@trash.net> <alpine.LNX.1.10.0903171444060.14581@bizon.gios.gov.pl> <49BFAADF.9000008@trash.net> <alpine.LNX.1.10.0903171452570.14581@bizon.gios.gov.pl> <49BFAC57.1060702@trash.net> <alpine.LNX.1.10.0903171505320.14581@bizon.gios.gov.pl> <49BFB217.9050001@trash.net> <alpine.LNX.1.10.0903171532230.14581@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49334 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZCQOjA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:39:00 -0400
In-Reply-To: <alpine.LNX.1.10.0903171532230.14581@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
>> Why do anything global at all? Its not needed unless connbytes is used
>> (or something in userspace, which we can't detect), and that affects
>> only a single namespace.
> 
> To enable it before the first packet?

We can't do that since we don't know whether it will be used at all.
A namespace starting after a different one has already used it will
have it enabled from the beginning. The first one won't however
unless you enable it whenever the module is enabled, at which point
the sysctl becomes useless.
