From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 2/5] Factorize definition of some macros.
Date: Sat, 09 Feb 2008 18:33:47 +0100
Message-ID: <47ADE3FB.7080401@netfilter.org>
References: <12025605952271-git-send-email-eric@inl.fr> <12025605951159-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44876 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755015AbYBIRd6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:33:58 -0500
In-Reply-To: <12025605951159-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Some macros were defined several time. This was the case of GET_VALUE,
> pp_is_valid. This patch puts the definition in ulogd.h and fixes the
> definition of pp_is_valid which was wrong (causing segfault by acessing to
> fields at NULL).

I like these sort of cleanups a lot. I think that the code of the input
handlers would be also much nicer if we cook some macros to setup values
and flags of the ulogd_keys.

Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
