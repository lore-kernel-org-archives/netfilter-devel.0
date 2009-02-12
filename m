From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: pull request
Date: Thu, 12 Feb 2009 06:33:48 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902120632140.32504@fbirervta.pbzchgretzou.qr>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de> <4993B3AC.1060707@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36343 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZBLFdu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:33:50 -0500
In-Reply-To: <4993B3AC.1060707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-02-12 06:29, Patrick McHardy wrote:
> jengelh@medozas.de wrote:
>> 13 files changed, 108 insertions(+), 182 deletions(-)
>
> This diffstat I get looks quite different:
>
> 11 files changed, 73 insertions(+), 67 deletions(-)
>
> Any idea whats going on there?
>

I used git diff --stat instead of whatever merge outputs.

$ git diff --stat nf/master..mdz/master
[13 files, 108+, 182-]
$ git rev-parse nf/master
8b7baebc93989106fd5d26b262d0ce191f8ef7c0
$ git rev-parse mdz/master
47a6fd9ec9891a8040eb8fd6db3c5012c1056061

HTH,
Jan
