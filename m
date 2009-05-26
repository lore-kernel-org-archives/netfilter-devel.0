From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: pull: minor tidbits
Date: Tue, 26 May 2009 15:08:09 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905261505270.24535@fbirervta.pbzchgretzou.qr>
References: <1243337187-18216-1-git-send-email-jengelh@medozas.de> <4A1BD494.9090105@netfilter.org> <4A1BDBA7.8080209@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59611 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbZEZNIK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 09:08:10 -0400
In-Reply-To: <4A1BDBA7.8080209@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-05-26 14:08, Pablo Neira Ayuso wrote:
>
>@@ -75,7 +75,7 @@ static void mh_init(struct xt_entry_match *m)
> static unsigned int name_to_type(const char *name)
> {
>        int namelen = strlen(name);
>-       unsigned int limit = sizeof(mh_names)/sizeof(struct mh_name);
>+       static const unsigned int limit = ARRAY_SIZE(mh_names);
>        unsigned int match = limit;
>        unsigned int i;
>
>The use of static here looks to me like a clever trick to avoid
>recalculations? I think this is a bit of abuse of static, the compiler
>itself should notice this and avoid re-calculations.

If you never take the address of limit, the static keyword is just
added safety sugar for when you do. Compiler does not recalculate
anything even without it, it's merely a hint to put it into the
right section, instead of the stack.
