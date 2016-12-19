From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] libxtables: xtables: Use getnameinfo()
Date: Tue, 20 Dec 2016 00:38:00 +0100
Message-ID: <20161219233800.GB4610@salvia>
References: <1481554437-20319-1-git-send-email-mayhs11saini@gmail.com>
 <1481554437-20319-2-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932110AbcLSXiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 18:38:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 367607643
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 00:38:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 28CDEDA865
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 00:38:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7301DA85D
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2016 00:38:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1481554437-20319-2-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 12, 2016 at 08:23:57PM +0530, Shyam Saini wrote:
> Replace gethostbyaddr() with getnameinfo() as getnameinfo()
> deprecates the former and allows programs to
> eliminate IPv4-versus-IPv6 dependencies

Also applied, thanks.

> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
>  libxtables/xtables.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index 6e75c15..e1512b1 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -1210,13 +1210,18 @@ const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
>  
>  static const char *ipaddr_to_host(const struct in_addr *addr)
>  {
> -	struct hostent *host;
> +	static char hostname[NI_MAXHOST];
> +	struct sockaddr_in saddr = { .sin_family = AF_INET, };
> +	saddr.sin_addr = *addr;

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index bed43480d589..d43f97066ea9 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1211,8 +1211,10 @@ const char *xtables_ipaddr_to_numeric(const
struct in_addr *addrp)
 static const char *ipaddr_to_host(const struct in_addr *addr)
 {
        static char hostname[NI_MAXHOST];
-       struct sockaddr_in saddr = { .sin_family = AF_INET, };
-       saddr.sin_addr = *addr;
+       struct sockaddr_in saddr = {
+               .sin_family = AF_INET,
+               .sin_addr = *addr,
+       };
        int err;

I collapsed this small update, so this is full C99 initialization.
Thanks.
