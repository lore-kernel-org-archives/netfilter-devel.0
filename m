From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] attr: remove redundant check for NULL
Date: Thu, 11 Nov 2010 14:02:09 +0100
Message-ID: <4CDBE951.5030100@netfilter.org>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40684 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146Ab0KKNCN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 08:02:13 -0500
In-Reply-To: <1289430485-16467-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/11/10 00:08, Jan Engelhardt wrote:
> Calling mnl_attr_parse with cb==NULL is pointless, because the
> function will do nothing else.

Indeed, applied.
