From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATH nft v2 01/18] mnl: fix error handling in mnl_batch_talk
Date: Thu, 24 Aug 2017 17:13:30 +0200
Message-ID: <20170824151330.GA18794@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170819152420.22563-2-eric@regit.org>
 <20170821081050.GA2982@salvia>
 <1503342115.9868.5.camel@regit.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:58144 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751168AbdHXPNz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 11:13:55 -0400
Content-Disposition: inline
In-Reply-To: <1503342115.9868.5.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2017 at 09:01:55PM +0200, Eric Leblond wrote:
> Hi,
> 
> On Mon, 2017-08-21 at 10:10 +0200, Pablo Neira Ayuso wrote:
> > Hi Eric,
> > 
> > On Sat, Aug 19, 2017 at 05:24:03PM +0200, Eric Leblond wrote:
> > > If one of the command is failing we should return an error.
> > 
> > Is this fixing up a real issue or it is something you need in a
> > follow
> > up patch?
> 
> Not really for current users of the function. But I think but it is an
> issue as the result of the function is success even when it fails.

Yes, this function should consistently return an error.

I'm attaching an amended patch, I think we can remove the explicit:

        ret = -1;

from nft_netlink().

I'll be applying what I'm attaching unless there is any concern.

--gKMricLos+KVdGMg
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-mnl-fix-error-handling-in-mnl_batch_talk.patch"

>From 206fdb25b7b53c164700a8cd7d7e659e058ad881 Mon Sep 17 00:00:00 2001
From: Eric Leblond <eric@regit.org>
Date: Thu, 24 Aug 2017 17:07:37 +0200
Subject: [PATCH] mnl: fix error handling in mnl_batch_talk

If one of the command is failing we should return an error.

Pablo says: "This is not a real issue since nft_netlink() returns an
error in case the list of errors is not empty. But we can indeed
simplify things by removing that explicit assignment in nft_netlink() so
mnl_batch_talk() consistently reports when if an error has happened.

Signee-off-by: Eric Leblond <eric@regit.org>
---
 src/main.c | 1 -
 src/mnl.c  | 7 +++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index 3519377b6e2c..c09d9f341b69 100644
--- a/src/main.c
+++ b/src/main.c
@@ -220,7 +220,6 @@ static int nft_netlink(struct nft_ctx *nft,
 				netlink_io_error(&ctx, &cmd->location,
 						 "Could not process rule: %s",
 						 strerror(err->err));
-				ret = -1;
 				errno = err->err;
 				if (err->seqnum == cmd->seqnum) {
 					mnl_err_list_free(err);
diff --git a/src/mnl.c b/src/mnl.c
index a770dc567d9f..69e24071b8f1 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -249,6 +249,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		.tv_sec		= 0,
 		.tv_usec	= 0
 	};
+	int err = 0;
 
 	ret = mnl_nft_socket_sendmsg(ctx);
 	if (ret == -1)
@@ -271,8 +272,10 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 
 		ret = mnl_cb_run(rcv_buf, ret, 0, portid, &netlink_echo_callback, ctx);
 		/* Continue on error, make sure we get all acknowledgments */
-		if (ret == -1)
+		if (ret == -1) {
 			mnl_err_list_node_add(err_list, errno, nlh->nlmsg_seq);
+			err = -1;
+		}
 
 		ret = select(fd+1, &readfds, NULL, NULL, &tv);
 		if (ret == -1)
@@ -281,7 +284,7 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list)
 		FD_ZERO(&readfds);
 		FD_SET(fd, &readfds);
 	}
-	return ret;
+	return err;
 }
 
 int mnl_nft_rule_batch_add(struct nftnl_rule *nlr, struct nftnl_batch *batch,
-- 
2.1.4


--gKMricLos+KVdGMg--
