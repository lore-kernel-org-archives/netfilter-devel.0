From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] iptables: save - fix getopt_long()'s optstring
Date: Fri, 14 Mar 2014 09:44:17 +0100
Message-ID: <20140314084417.GA15473@localhost>
References: <1394726481-6001-1-git-send-email-jpopelka@redhat.com>
 <1394726481-6001-3-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49576 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbaCNIoc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Mar 2014 04:44:32 -0400
Content-Disposition: inline
In-Reply-To: <1394726481-6001-3-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jiri,

On Thu, Mar 13, 2014 at 05:01:21PM +0100, Jiri Popelka wrote:
> ---
>  iptables/ip6tables-save.c | 2 +-
>  iptables/iptables-save.c  | 2 +-
>  iptables/xtables-save.c   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
> index a86a64a..cf56c63 100644
> --- a/iptables/ip6tables-save.c
> +++ b/iptables/ip6tables-save.c
> @@ -137,7 +137,7 @@ int ip6tables_save_main(int argc, char *argv[])
>  	init_extensions6();
>  #endif
>  
> -	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
> +	while ((c = getopt_long(argc, argv, "cdt:M:", options, NULL)) != -1) {

b is also removed.

My bet is that noone is using that, but just to make sure we break
some stupid script somewhere, just leave it there and add some warning
message to indicate that you can remove from your scripts. Thanks.
