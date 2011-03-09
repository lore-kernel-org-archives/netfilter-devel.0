From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] src: use limits.h header
Date: Wed, 09 Mar 2011 14:49:56 +0100
Message-ID: <4D778584.2070702@netfilter.org>
References: <1299328292-4469-1-git-send-email-jengelh@medozas.de> <1299328292-4469-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36991 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab1CINuA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:50:00 -0500
In-Reply-To: <1299328292-4469-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/03/11 13:31, Jan Engelhardt wrote:
> values.h is not present on other systems, and the glibc copy reads
> right away: Old compatibility names for <limits.h> and <float.h>
> constants.

Applied, thanks Jan.
