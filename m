From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [v2 PATCH 1/6] netfilter: Add new netlink NFQA_CFG_FAIL_OPEN
Date: Tue, 8 May 2012 13:34:01 +0200
Message-ID: <20120508113401.GA11952@1984>
References: <20120508094342.19531.51351.sendpatchset@localhost.localdomain>
 <20120508094354.19531.92149.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, vivk@us.ibm.com, svajipay@in.ibm.com,
	fw@strlen.de, netfilter-devel@vger.kernel.org, sri@us.ibm.com
To: Krishna Kumar <krkumar2@in.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59051 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab2EHLeJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 07:34:09 -0400
Content-Disposition: inline
In-Reply-To: <20120508094354.19531.92149.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 08, 2012 at 03:13:54PM +0530, Krishna Kumar wrote:
> Define a new netlink message: NFQA_CFG_FAIL_OPEN
> 
> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>
> Signed-off-by: Vivek Kashyap <vivk@us.ibm.com>
> Signed-off-by: Sridhar Samudrala <samudrala@us.ibm.com>
> ---
>  include/linux/netfilter/nfnetlink_queue.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff -ruNp org/include/linux/netfilter/nfnetlink_queue.h new/include/linux/netfilter/nfnetlink_queue.h
> --- org/include/linux/netfilter/nfnetlink_queue.h	2012-05-08 09:16:41.969050136 +0530
> +++ new/include/linux/netfilter/nfnetlink_queue.h	2012-05-08 09:39:10.334761077 +0530
> @@ -84,6 +84,7 @@ enum nfqnl_attr_config {
>  	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
>  	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
>  	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
> +	NFQA_CFG_FAIL_OPEN,		/* __u8 */
>  	__NFQA_CFG_MAX
>  };
>  #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)

The patch logic that you use is not correct. One new feature, one
patch, please.

In case it gets big, then you can split changes following this logic:
patches that prepare the new feature first, then the patches that
contain the feature.

In this case, you have to put everything into one single patch.

Please, send one single patch for this new feature.

Moreover, rename NFQA_CFG_FAIL_OPEN to NFAQ_CFG_FLAGS and declare:

#define NFAQ_CFG_F_FAIL_OPEN  (1 << 0)

Then, check for that flag in the code to enable the fail open
behaviour.

I have another feature here that will use those flags for another
option.
