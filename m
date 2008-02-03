From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 31/34]  Switch from INNER JOIN to LEFT JOIN in ulog view.
Date: Sun, 03 Feb 2008 13:26:53 +0100
Message-ID: <47A5B30D.9040205@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <12019874701370-git-send-email-eric@inl.fr> <12019874702349-git-send-email-eric@inl.fr> <12019874703504-git-send-email-eric@inl.fr> <12019874704067-git-send-email-eric@inl.fr> <12019874703897-git-send-email-eric@inl.fr> <12019874712066-git-send-email-eric@inl.fr> <1201987471474-git-send-email-eric@inl.fr> <1201987471346-git-send-email-eric@inl.fr> <12019874712309-git-send-email-eric@inl.fr> <12019874714080-git-send-email-eric@inl.fr> <12019874712041-git-send-email-eric@inl.fr> <12019874711938-git-send-email-eric@inl.fr> <1201987471531-git-send-email-eric@inl.fr> <12019874713790-git-send-email-eric@inl.fr> <12019874712753-git-send-email-eric@inl.fr> <12019874713782-git-send-email-eric@inl.fr> <12019874711816-git-send-email-eric@inl.fr>
 <1201987471602-git-send-email-eric@inl.fr> <12019874711187-git-send-email-eric@inl.fr> <12019874721299-git-send-email-eric@inl.fr> <12019874721188-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53833 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752070AbYBCM1y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:27:54 -0500
In-Reply-To: <12019874721188-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> From: Eric leblond <eric@inl.fr>
> 
> This patch fixes an error in MySQL schema which causes MySQL view to be always
> empty.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
