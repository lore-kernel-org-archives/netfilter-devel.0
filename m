From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: quote variables in release.sh
Date: Fri, 04 Jul 2008 16:13:57 +0200
Message-ID: <486E3025.9030106@netfilter.org>
References: <alpine.LNX.1.10.0807032015430.23294@fbirervta.pbzchgretzou.qr> <486DD32C.6040903@netfilter.org> <486DD3AF.6040909@netfilter.org> <alpine.LNX.1.10.0807041227510.1890@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45839 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754122AbYGDOOF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 10:14:05 -0400
In-Reply-To: <alpine.LNX.1.10.0807041227510.1890@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-07-04 09:39, Pablo Neira Ayuso wrote:
> 
>> Pablo Neira Ayuso wrote:
>>> Jan Engelhardt wrote:
>>>> commit 68a69d9fbf610899aa95457cdd5c38dcfa447c02
>>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>>> Date:   Thu Jul 3 19:23:39 2008 +0200
>>>>
>>>>     build: quote variables in release.sh
>>> Actually, instead of fixing release.sh, we should have the `make
>>> distcheck' magic working. Currently it is broken.
>> I mean the magic to build the tarball, of course.
> 
> make tarball

That works but it is doing far less checkings that `make distcheck' in
other packages.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
