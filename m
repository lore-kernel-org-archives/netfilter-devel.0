From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/6] build: tag function headers rather than decls as
 exported
Date: Fri, 19 Nov 2010 12:09:45 +0100
Message-ID: <4CE65AF9.9090904@netfilter.org>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de> <1289907814-32706-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56675 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab0KSLJu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:09:50 -0500
In-Reply-To: <1289907814-32706-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I like this patchset. Some minor glitch:

On 16/11/10 12:43, Jan Engelhardt wrote:
> @@ -49,31 +43,31 @@ MNL_API int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *b
>  #define MNL_ALIGN(len)		(((len)+MNL_ALIGNTO-1) & ~(MNL_ALIGNTO-1))
>  #define MNL_NLMSG_HDRLEN	MNL_ALIGN(sizeof(struct nlmsghdr))
>  
> -MNL_API size_t mnl_nlmsg_size(size_t len);
> -MNL_API size_t mnl_nlmsg_total_size(size_t len);
> -MNL_API size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
> +extern size_t mnl_nlmsg_size(size_t len);
> +extern size_t mnl_nlmsg_total_size(size_t len);
> +extern size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
>  
>  /* Netlink message header builder */
> -MNL_API struct nlmsghdr *mnl_nlmsg_put_header(void *buf);
> -MNL_API void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size);
> +extern struct nlmsghdr *mnl_nlmsg_put_header(void *buf);
> +extern void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size);
>  
>  /* Netlink message iterators */
> -MNL_API bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
> -MNL_API struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len);
> +extern bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
> +extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len);

In patch 1/6 mnl_nlmsg_next looks like:

-struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len)
+struct nlattr *mnl_attr_next(const struct nlattr *attr)

but here the old API seems to come back:

extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int
*len);
