From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 03/23] netfilter: ebtables: use generic table checking
Date: Mon, 06 Oct 2008 18:17:28 +0200
Message-ID: <48EA3A18.1090303@trash.net>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de> <ed9e91413b5b344265e42cf5019b8374ee85bf18.1223294924.git.jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45986 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYJFQRe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:17:34 -0400
In-Reply-To: <ed9e91413b5b344265e42cf5019b8374ee85bf18.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Ebtables ORs (1 << NF_BR_NUMHOOKS) into the hook mask to indicate that
> the extension was called from a base chain. So this also needs to be
> present in the extensions' ->hooks.

Applied, thanks.
