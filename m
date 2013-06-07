From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [PATCH 2/5] include: use C++ headers in C++ mode
Date: Fri, 07 Jun 2013 10:35:01 +0200
Message-ID: <1648235.41SkZRnnpI@storm>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de> <1289430485-16467-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Cc: Jan Engelhardt <jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:39039 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab3FGIfN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:35:13 -0400
In-Reply-To: <1289430485-16467-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Thursday, 11. November 2010 00:08:01 you wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  include/libmnl/libmnl.h |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
> index 7094af2..37c502a 100644
> --- a/include/libmnl/libmnl.h
> +++ b/include/libmnl/libmnl.h
> @@ -1,13 +1,16 @@
>  #ifndef _LIBMNL_H_
>  #define _LIBMNL_H_
> 
> -#include <stdio.h>
> -#include <stdint.h>
> +#ifdef __cplusplus
> +#	include <cstdio>
> +#	include <cstdint>
> +#else
> +#	include <stdbool.h> /* not in C++ */
> +#	include <stdio.h>
> +#	include <stdint.h>
> +#endif

just a side note regarding this old commit:

The header "<cstdint>" is part of the C++11 standard.
(http://www.cplusplus.com/reference/cstdint/)

g++ forces you to enable C++11 mode if you want to use it.
Tested with g++ (GCC) 4.4.4.

Do we really need this? It compiles fine without
the special headers inside the __cplusplus part.
Pablo asked the same back in 2010 ;)

Best regards,
Thomas

