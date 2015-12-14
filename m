From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Mon, 14 Dec 2015 20:25:17 +0100
Message-ID: <20151214192517.GA13160@salvia>
References: <20151029190717.GE5154@vapier.lan>
 <CAMQP0snn7nt=iK6Um4doYFPSn1ffTDtUOKi8NBjp=ZCE58EXQw@mail.gmail.com>
 <20151214123731.GA26186@salvia>
 <CABtf2+TgFhMvGPjFR=w91wmaGgtSUTaF-mxxKY7HXsxeQ9u3Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neutron Soutmun <neo.neutron@gmail.com>,
	20151006012711.GA5372@oxygen.gentoo.org,
	netfilter-devel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
To: Caroline Tice <cmtice@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45339 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbLNTcH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 14:32:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 84D038E7A6
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 20:32:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 72572DA85F
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 20:32:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DBC61DA86B
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 20:31:59 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CABtf2+TgFhMvGPjFR=w91wmaGgtSUTaF-mxxKY7HXsxeQ9u3Tw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 14, 2015 at 09:34:23AM -0800, Caroline Tice wrote:
> I did talk with some Clang developers initially, to try to determine
> if this was in fact a Clang bug and therefore would need to be fixed
> in Clang.  The answer I got was a resounding  no, this is not a Clang
> bug; it is, in fact a GCC bug -- an example of GCC being overly
> permissive (which, sadly, is not that uncommon).  After a function has
> been *declared*  (the header, but no code), it is still ok to change
> the visibility of the function.  However after the function has
> actually been *defined*, changing the visibility of the function is
> illegal.  That is why moving all of the EXPORT_SYMBOL statements from
> after the function code to before the function code fixes the problem,
> as far as Clang is concerned.

Thanks, so we already got feedback from them.

Then I think we upstream this patch:

http://patchwork.ozlabs.org/patch/537980/

But I'd suggest the MNL_EXPORT is renamed to EXPORT_SYMBOL and it is
placed in the .c files if possible, I don't think we need to expose
this through the library headers (every function declared there is
indeed exported, so that information is not relevant there).

Will anyone help sending a new version to end up with this issue?

Thanks.
