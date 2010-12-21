From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] src: declare non-modified data as const
Date: Tue, 21 Dec 2010 20:56:13 +0100
Message-ID: <4D11065D.8000100@netfilter.org>
References: <1292703453-16324-1-git-send-email-jengelh@medozas.de> <1292703453-16324-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57905 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0LUT4Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:56:16 -0500
In-Reply-To: <1292703453-16324-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18/12/10 21:17, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  include/libnetfilter_log/libipulog.h |    2 +-
>  src/libipulog_compat.c               |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)

this one also applied, thanks.
