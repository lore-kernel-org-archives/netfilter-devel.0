From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] src: remove redundant casts
Date: Tue, 21 Dec 2010 20:56:01 +0100
Message-ID: <4D110651.1060203@netfilter.org>
References: <1292703453-16324-1-git-send-email-jengelh@medozas.de> <1292703453-16324-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59504 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0LUT4F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:56:05 -0500
In-Reply-To: <1292703453-16324-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18/12/10 21:17, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  src/libipulog_compat.c |    2 +-
>  utils/ulog_test.c      |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

I have cherry-picked this one and pushed out to git.
