From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Some iptables-1.4.3 issues
Date: Tue, 24 Mar 2009 12:57:31 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903241257090.15443@fbirervta.pbzchgretzou.qr>
References: <49C79C90.80804@trash.net> <1237882157.9988.2533.camel@localhost> <alpine.LSU.2.00.0903240951060.25646@fbirervta.pbzchgretzou.qr> <49C8C146.3040507@netfilter.org> <alpine.LSU.2.00.0903241219200.15443@fbirervta.pbzchgretzou.qr> <49C8C622.3060805@netfilter.org>
 <49C8C80F.8080105@netfilter.org> <alpine.LSU.2.00.0903241248120.15443@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Volkov <pva@gentoo.org>, Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34863 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbZCXL5d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:57:33 -0400
In-Reply-To: <alpine.LSU.2.00.0903241248120.15443@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2009-03-24 12:48, Jan Engelhardt wrote:

>
>On Tuesday 2009-03-24 12:46, Pablo Neira Ayuso wrote:
>>> Pulled and pushed. Thanks. If there's no more complains, we can release
>>> the 1.4.3.1.
>>
>>We seem to have more problems :(. I'm going to check what's wrong.
>
>Patrick already ran this. This is due to outdated dependency
>information; `git clean -dfx` will solve this.

FYI, reference: http://marc.info/?l=netfilter-devel&m=123174141705175&w=2

>>  CC       libipt_CLUSTERIP.oo
>>  CCLD     libipt_CLUSTERIP.so
>>make[2]: *** No rule to make target
>>`../include/linux/netfilter/nf_nat.h', needed by `libipt_DNAT.oo'.  Stop.
>>make[2]: Leaving directory
>>`/home/pablo/devel/scm/git-netfilter/iptables/extensions'
>>make[1]: *** [all-recursive] Error 1
>>make[1]: Leaving directory `/home/pablo/devel/scm/git-netfilter/iptables'
>>make: *** [all] Error 2
