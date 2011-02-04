From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] libxtables: symbol visibility
Date: Fri, 04 Feb 2011 14:13:25 +0100
Message-ID: <4D4BFB75.4080803@trash.net>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de> <1296824935-4606-8-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46392 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1BDNNk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:13:40 -0500
In-Reply-To: <1296824935-4606-8-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.02.2011 14:08, Jan Engelhardt wrote:
> -void xtables_free_opts(int unused)
> +EXPORT_SYMBOL void xtables_free_opts(int unused)

This is pretty ugly in my opinion. Please do something like this:

#define EXPORT_SYMBOL(x)        typeof(x) (x)
__attribute__((visibility("default")))

so you can use EXPORT_SYMBOL as in the kernel.
