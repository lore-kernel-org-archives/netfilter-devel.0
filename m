From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [lnf-log RFC PATCH 1/2] introduce new functions to use without
 nflog_handle
Date: Tue, 18 Aug 2015 07:48:25 +0200
Message-ID: <20150818054825.GA16745@salvia>
References: <20150810081342.GB25169@gmail.com>
 <20150810081553.GC25169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59877 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbbHRFmR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 01:42:17 -0400
Content-Disposition: inline
In-Reply-To: <20150810081553.GC25169@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 10, 2015 at 05:15:54PM +0900, Ken-ichirou MATSUZAWA wrote:
[...]
> diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
> index e92576b..422c550 100644
> --- a/src/libnetfilter_log.c
> +++ b/src/libnetfilter_log.c
> @@ -26,6 +26,7 @@
>  #include <errno.h>
>  #include <netinet/in.h>
>  #include <sys/socket.h>
> +#include <linux/netlink.h>
>  
>  #include <libnetfilter_log/linux_nfnetlink_log.h>
>  
> @@ -1067,5 +1068,47 @@ int nflog_snprintf_xml(char *buf, size_t rem, struct nflog_data *tb, int flags)
>  }
>  
>  /**
> + * nflog_data_alloc - allocate a new nflog data
> + *
> + * In case of success, this function returns a valid pointer to a memory blob,
> + * otherwise NULL is returned and errno is set appropiately.
> + */
> +struct nflog_data *nflog_data_alloc(void)
> +{
> +	struct nflog_data *nfad = calloc(1, sizeof(struct nflog_data));
> +	if (nfad == NULL)
> +		return NULL;
> +	nfad->nfa = (struct nfattr **)calloc(NFULA_MAX + 1,
> +					     sizeof(struct nlattr *));
> +	if (nfad->nfa == NULL) {
> +		free(nfad);
> +		return NULL;
> +	}
> +	return nfad;
> +}
[...]

The libnetfilter_log.c file contains the old API, its use is
discouraged since it depends on libnfnetlink.

> diff --git a/src/nlmsg.c b/src/nlmsg.c
> new file mode 100644
> index 0000000..8611b9d
> --- /dev/null
> +++ b/src/nlmsg.c

I like that you started the libmnl support for libnetfilter_log.

The idea is to provide a set of helper functions that we can use in
conjunction with libmnl, similar to what we have in
libnetfilter_queue/nlmsg.c

Thanks.
