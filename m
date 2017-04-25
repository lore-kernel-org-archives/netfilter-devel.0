From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: warn users about queue
 allocation errors
Date: Tue, 25 Apr 2017 13:34:01 +0200
Message-ID: <20170425113401.GA5355@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270928606.1751.8172963085482513292.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947036AbdDYLeI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 07:34:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E1FF31373A2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 13:34:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D243F10078E
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 13:34:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FB52FF2D0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 13:33:58 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149270928606.1751.8172963085482513292.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 07:28:06PM +0200, Arturo Borrero Gonzalez wrote:
> These warnings, if they happen, should help users.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
> ---
>  src/channel.c  |    6 +++++-
>  src/queue_tx.c |   11 +++++++++--
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/src/channel.c b/src/channel.c
> index acbfa7d..b2f114d 100644
> --- a/src/channel.c
> +++ b/src/channel.c
> @@ -19,6 +19,7 @@
>  #include "channel.h"
>  #include "network.h"
>  #include "queue.h"
> +#include "log.h"
>  
>  static struct channel_ops *ops[CHANNEL_MAX];
>  extern struct channel_ops channel_mcast;
> @@ -161,8 +162,11 @@ static void channel_enqueue_errors(struct channel *c)
>  	struct channel_error *error;
>  
>  	qobj = queue_object_new(Q_ELEM_ERR, sizeof(struct channel_error));
> -	if (qobj == NULL)
> +	if (qobj == NULL) {
> +		dlog(LOG_WARNING, "could not enqueue channel errors, failed to"
> +		     " allocate memory");

Did you ever hit this?

Moreover, we have stats that can be dumped via option. Better use them there?
