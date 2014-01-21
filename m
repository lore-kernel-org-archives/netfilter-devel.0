From: Phil Oester <kernel@linuxace.com>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 07:15:42 -0800
Message-ID: <20140121151541.GA23738@home>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <20140121114524.GA27552@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34622 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaAUPPp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:15:45 -0500
Received: by mail-pa0-f46.google.com with SMTP id rd3so8494312pab.19
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 07:15:44 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140121114524.GA27552@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 11:45:25AM +0000, Patrick McHardy wrote:
> I think the semantics of "flush table" should be changed though. It should
> kill *every* object in the table. Perhaps not the base chains, but at least
> all rules, non base chain and also sets.

+1, as current method of having to clear out a table in 2 or 3 steps is
a major PITA.

Phil
