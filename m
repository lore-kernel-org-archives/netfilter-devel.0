From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/3] libxt_addrtype: rename from libipt_addrtype
Date: Tue, 6 Sep 2011 13:46:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109061346310.4849@frira.zrqbmnf.qr>
References: <1315247081-12131-1-git-send-email-jengelh@medozas.de> <1315247081-12131-2-git-send-email-jengelh@medozas.de> <20110906113444.GA3415@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60439 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab1IFLq7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 07:46:59 -0400
In-Reply-To: <20110906113444.GA3415@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-09-06 13:34, Pablo Neira Ayuso wrote:

>On Mon, Sep 05, 2011 at 08:24:38PM +0200, Jan Engelhardt wrote:
>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>> ---
>>  extensions/libipt_addrtype.c   |  308 ----------------------------------------
>>  extensions/libipt_addrtype.man |   69 ---------
>>  extensions/libxt_addrtype.c    |  308 ++++++++++++++++++++++++++++++++++++++++
>>  extensions/libxt_addrtype.man  |   69 +++++++++
>>  4 files changed, 377 insertions(+), 377 deletions(-)
>>  delete mode 100644 extensions/libipt_addrtype.c
>>  delete mode 100644 extensions/libipt_addrtype.man
>>  create mode 100644 extensions/libxt_addrtype.c
>>  create mode 100644 extensions/libxt_addrtype.man
>
>You can get smaller patches with -M option in git-format-patch. Just
>to let you know for the next time you have to make some renaming.

Does -M also work with  git send-email? 'Cause that is what I used..

