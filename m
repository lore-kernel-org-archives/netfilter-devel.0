From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Tue, 25 Jan 2011 16:06:49 +0100
Message-ID: <4D3EE709.4040303@trash.net>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-2-git-send-email-kadlec@blackhole.kfki.hu> <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55743 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1AYPGz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:06:55 -0500
In-Reply-To: <1295618527-9583-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.01.2011 15:01, Jozsef Kadlecsik wrote:
> +/* Flags at command level */
> +enum ipset_cmd_flags {
> +	IPSET_FLAG_BIT_EXIST	= 0,
> +	IPSET_FLAG_EXIST	= (1 << IPSET_FLAG_BIT_EXIST),
> +};

One more comment regarding this file - this duplicates the semantic
of the NLM_F_EXCL flag, which indicates that an error should be
returned if something already exists on creation.
