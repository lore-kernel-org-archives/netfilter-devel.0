From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: [PATCH 0/2] rework of userspace expectation support
Date: Mon, 13 Jun 2011 14:57:31 -0700
Message-ID: <BANLkTimziN7bET5TcdsyiBkDHd8MaLz-8w@mail.gmail.com>
References: <20110412215458.3145.40830.stgit@decadence>
	<4DA58AE2.7000204@trash.net>
	<4DA58D48.4010307@netfilter.org>
	<4DA58F41.9080603@trash.net>
	<4DA592F3.1090201@netfilter.org>
	<4DA59700.9000400@trash.net>
	<4DAECD42.9080006@netfilter.org>
	<4DAEE86A.6070800@trash.net>
	<4DB02DAC.1070406@netfilter.org>
	<BANLkTinreLDGTuQ0tH+KyHVuB7XHckzYzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37736 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1FMV5c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:57:32 -0400
Received: by vws1 with SMTP id 1so4005875vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2011 14:57:32 -0700 (PDT)
In-Reply-To: <BANLkTinreLDGTuQ0tH+KyHVuB7XHckzYzA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 17, 2011 at 2:12 PM, Sam Roberts <vieuxtech@gmail.com> wrote:
> Patrick, are you going to merge these?
>
> I don't see it in nf-next-2.6.git.

Btw, here's a reproduction tool that will oops:

https://github.com/sam-github/nfct-expect-oops

Cheers,
Sam
