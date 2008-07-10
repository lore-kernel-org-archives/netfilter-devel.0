From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 2/2] Fix computation of allocated size for query.
Date: Thu, 10 Jul 2008 08:33:07 +0200
Message-ID: <4875AD23.1080101@netfilter.org>
References: <> <1215637005-3102-1-git-send-email-eric@inl.fr> <1215637005-3102-2-git-send-email-eric@inl.fr> <1215637005-3102-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay-ev.club-internet.fr ([194.158.96.209]:52257 "EHLO
	relay-ev.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYGJGdJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:33:09 -0400
In-Reply-To: <1215637005-3102-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch fixes the computation of the allocation size for the query.
> It was not taking into account the length of the name of the procedure.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
