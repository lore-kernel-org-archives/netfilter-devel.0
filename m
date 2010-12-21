From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] libipulog: rebuild required header file inclusion
Date: Tue, 21 Dec 2010 20:46:32 +0100
Message-ID: <4D110418.4020506@netfilter.org>
References: <1292703453-16324-1-git-send-email-jengelh@medozas.de> <1292703453-16324-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57318 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0LUTqg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:46:36 -0500
In-Reply-To: <1292703453-16324-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18/12/10 21:17, Jan Engelhardt wrote:
> Use C++ headers for C++ and throw out #includes that are not needed
> for the header file.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  include/libnetfilter_log/libipulog.h |    9 ++++++---
>  src/libipulog_compat.c               |    1 +
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/include/libnetfilter_log/libipulog.h b/include/libnetfilter_log/libipulog.h
> index 0278862..bb6736a 100644
> --- a/include/libnetfilter_log/libipulog.h
> +++ b/include/libnetfilter_log/libipulog.h
> @@ -1,9 +1,12 @@
>  #ifndef _LIBIPULOG_H
>  #define _LIBIPULOG_H
>  
> -#include <errno.h>
> -#include <unistd.h>
> -#include <fcntl.h>
> +#ifdef __cplusplus
> +#	include <cstdint>
> +#else
> +#	include <stdint.h>
> +#endif
> +#include <sys/types.h>

I agree that these headers shouldn't be there but I'm worry about
breaking the compilation of existing applications that, for whatever
reason, rely on these includes.
