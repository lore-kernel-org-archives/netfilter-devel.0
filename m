From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH RFC 04/15] netfilter: add pernet hook support
Date: Mon, 15 Jun 2015 20:01:21 -0500
Message-ID: <87fv5slb4u.fsf@x220.int.ebiederm.org>
References: <1434383217-13732-1-git-send-email-pablo@netfilter.org>
	<1434383217-13732-5-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@vger.kernel.org, aschultz@warp10.net,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:51723 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbbFPBGg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jun 2015 21:06:36 -0400
In-Reply-To: <1434383217-13732-5-git-send-email-pablo@netfilter.org> (Pablo
	Neira Ayuso's message of "Mon, 15 Jun 2015 17:46:46 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> This patch modifies the nf_register_hook() and nf_register_hooks() interfaces
> to allow to register hooks at a pernet level.
>
> This starts using init_net for all the existing callers though, so the full
> conversion of existing netfilter hook clients to comes in follow up
> patches.

There is one issue with the approach this takes to per net network
namespace hooks.

nf_unregister_hook calls syncrhonize_net().

Which depending on which netfilter modules are loaded is going
to result in a nasty reduction in connections per second of vsftp,
because of the serialized nature of network namespace cleanup.

That should be something we can solve on top of the patches,
but I want to bring it up now so that other people are aware of it.

Eric
