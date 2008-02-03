From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 25/34]  Set oob.family as VALID key.
Date: Sun, 03 Feb 2008 13:17:15 +0100
Message-ID: <47A5B0CB.8000406@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <12019874703998-git-send-email-eric@inl.fr> <12019874701589-git-send-email-eric@inl.fr> <12019874701366-git-send-email-eric@inl.fr> <12019874704144-git-send-email-eric@inl.fr> <12019874703136-git-send-email-eric@inl.fr> <12019874701552-git-send-email-eric@inl.fr> <12019874701370-git-send-email-eric@inl.fr> <12019874702349-git-send-email-eric@inl.fr> <12019874703504-git-send-email-eric@inl.fr> <12019874704067-git-send-email-eric@inl.fr> <12019874703897-git-send-email-eric@inl.fr> <12019874712066-git-send-email-eric@inl.fr> <1201987471474-git-send-email-eric@inl.fr> <1201987471346-git-send-email-eric@inl.fr> <12019874712309-git-send-email-eric@inl.fr> <12019874714080-git-send-email-eric@inl.fr> <12019874712041-git-send-email-eric@inl.fr>
  <12019874711938-git-send-email-eric@inl.fr> <1201987471531-git-send-email-eric@inl.fr> <12019874713790-git-send-email-eric@inl.fr> <12019874712753-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50572 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760922AbYBCMRX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:17:23 -0500
In-Reply-To: <12019874712753-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> From: Eric leblond <eric@inl.fr>
> 
> OOB_FAMILY output was not set by NFLOG because the key was not set as valid.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
