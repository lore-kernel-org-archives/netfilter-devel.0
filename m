From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH] Use attribute to avoid warning about unused parameter.
Date: Thu, 31 Jul 2008 16:46:01 +0200
Message-ID: <4891D029.9090702@netfilter.org>
References: <48918F6D.8040307@trash.net> <1217512238-26173-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49813 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751567AbYGaOqO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:46:14 -0400
In-Reply-To: <1217512238-26173-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Following live discussion with Pierre Chifflier, it appears that the flag
> -Wno-unused-parameter is deprecated in gcc and has to be replaced by an
> attribute: __attribute__ ((unused)).
> 
> The following patch fixes all warnings related to unused parameters by
> correctly settings the attribute in all unused function parameters. This
> is mainly the case for callback functions. It uses a macro named UNUSED
> which is simply defined as __attribute__((unused)).

I don't like polluting the code with tons of UNUSED flags, sorry. I
prefer if we use several -Wxyz options that may be report useful
warnings instead of -Wextra.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
