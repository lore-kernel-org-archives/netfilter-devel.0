From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 11/11] Add option to CFLAGS to avoid useless warning.
Date: Thu, 31 Jul 2008 11:49:17 +0200
Message-ID: <48918A9D.5040204@netfilter.org>
References: <20080723162746.GB31572@bayen.regit.org> <1217166686-28508-12-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45067 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750752AbYGaJtX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 05:49:23 -0400
In-Reply-To: <1217166686-28508-12-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds the "-Wno-unused-parameter" option to CFLAGS. This suppress
> gcc warning that can not be fixed due to the usage of generic system like
> callback where function definition has to be standardized.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  configure.in |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/configure.in b/configure.in
> index 96cc2d0..8889575 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -30,7 +30,7 @@ dnl Checks for library functions.
>  AC_FUNC_VPRINTF
>  AC_CHECK_FUNCS(socket strerror)
>  
> -CFLAGS="$CFLAGS -Wall -Wextra"
> +CFLAGS="$CFLAGS -Wall -Wextra -Wno-unused-parameter"

Applied from 1 to 10. Thanks Eric.

With regards to this patch. This warning vanishes is we remove -Wextra.

We are not using this flag in any other userspace tools and IIRC Patrick
said that -Wextra did not provide very useful warning. Any comment on this?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
