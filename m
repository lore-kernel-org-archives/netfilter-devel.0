From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: [PATCH 0/2] rework of userspace expectation support
Date: Tue, 17 May 2011 14:12:19 -0700
Message-ID: <BANLkTinreLDGTuQ0tH+KyHVuB7XHckzYzA@mail.gmail.com>
References: <20110412215458.3145.40830.stgit@decadence>
	<4DA58AE2.7000204@trash.net>
	<4DA58D48.4010307@netfilter.org>
	<4DA58F41.9080603@trash.net>
	<4DA592F3.1090201@netfilter.org>
	<4DA59700.9000400@trash.net>
	<4DAECD42.9080006@netfilter.org>
	<4DAEE86A.6070800@trash.net>
	<4DB02DAC.1070406@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47367 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab1EQVMU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2011 17:12:20 -0400
Received: by vxi39 with SMTP id 39so668268vxi.19
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2011 14:12:19 -0700 (PDT)
In-Reply-To: <4DB02DAC.1070406@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick, are you going to merge these?

I don't see it in nf-next-2.6.git.

On Thu, Apr 21, 2011 at 6:14 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On 20/04/11 16:06, Patrick McHardy wrote:
>> I thought this is what your patches try to fix?
>
> Yes, my patches add the helper extension to the conntrack by means of
> the CT target. Thus, in the case of userspace helpers, the master
> conntrack can store the list of unfulfilled expectations that it owns.

Its not clear to me why the CT master isn't added on a master-less
connection at the time that a userspace expectation is set (instead of
having to use the CT target in the raw table to create the master for
all connections that might potentially need a userspace expectation).

However, I'll take any fix that stops the oopsing.

Thanks,
Sam
