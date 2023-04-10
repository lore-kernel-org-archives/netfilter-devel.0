Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14956C77B71
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Apr 2023 09:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjDJJEt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Apr 2023 05:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDJJEr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2023 05:04:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A08F19A9
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2023 02:04:47 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:04:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dave Pifke <dave@pifke.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: try SO_SNDBUF before SO_SNDBUFFORCE
Message-ID: <ZDPRLBtCQds/nEn9@calendula>
References: <87wn2n8ghs.fsf@stabbing.victim.com>
 <ZDH0EJN9O0DrWp0W@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8j8Kkk+WWqaZuLzW"
Content-Disposition: inline
In-Reply-To: <ZDH0EJN9O0DrWp0W@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--8j8Kkk+WWqaZuLzW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

On Sun, Apr 09, 2023 at 01:09:07AM +0200, Pablo Neira Ayuso wrote:
> > diff --git a/src/mnl.c b/src/mnl.c
> > index 26f943db..ab6750c8 100644
> > --- a/src/mnl.c
> > +++ b/src/mnl.c
> > @@ -260,6 +260,13 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
> >  		return;
> >  
> >  	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
> > +	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
> > +		       &newbuffsiz, sizeof(socklen_t)) == 0)
> > +		return;
> 
> setsockopt() with SO_SNDBUF never fails: it trims the newbuffsiz that is
> specified by net.core.wmem_max
> 
> This needs to call:
> 
> 	setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
> 		   &newbuffsiz, sizeof(socklen_t));
> 
> without checking the return value. Otherwise, SO_SNDBUFFORCE is never
> going to be called after this patch. This needs a v2.

I think this patch should be fine.

--8j8Kkk+WWqaZuLzW
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/mnl.c b/src/mnl.c
index 26f943dbb4c8..ee62c0c9c2a0 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -261,8 +261,13 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 
 	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
 	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
-		       &newbuffsiz, sizeof(socklen_t)) < 0)
-		return;
+		       &newbuffsiz, sizeof(socklen_t)) < 0) {
+		/* Fall back to SO_SNDBUF, this never fails, kernel trims down
+		 * the size to net.core.wmem_max.
+		 */
+		setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
+			   &newbuffsiz, sizeof(socklen_t));
+	}
 }
 
 static unsigned int nlsndbufsiz;

--8j8Kkk+WWqaZuLzW--
