From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_hashlimit match, revision 1
Date: Tue, 29 Jan 2008 18:24:18 +0100
Message-ID: <479F6142.2000905@trash.net>
References: <Pine.LNX.4.64.0801241946190.12676@fbirervta.pbzchgretzou.qr> <479F245A.2030509@trash.net> <Pine.LNX.4.64.0801291621000.1185@fbirervta.pbzchgretzou.qr> <479F46C9.2010102@trash.net> <Pine.LNX.4.64.0801291805540.14907@fbirervta.pbzchgretzou.qr> <479F5EDC.8050207@trash.net> <Pine.LNX.4.64.0801291821350.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60078 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYA2RYW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:24:22 -0500
In-Reply-To: <Pine.LNX.4.64.0801291821350.14907@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 29 2008 18:14, Patrick McHardy wrote:
>>> Could you push the outstanding patches to Dave, or give me a git
>>> repository to sync against?
>> I'll try to push my patches to Dave tonight or tommorrow.
>>
> Do I get an ack on the annotation 15 patches? :)
> 

I haven't looked into them yet, but some of them will probably
clash with some naming unification patches I have queued
(struct nf_conn *conntrack -> struct nf_conn *ct everywhere).

There are also the iptables netns patches which might cause
clashes, I'll let you know when I get to them.
