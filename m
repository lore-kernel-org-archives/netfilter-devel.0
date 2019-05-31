Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D09C04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F9A8266CB
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 09:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfEaJaO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 05:30:14 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45034 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfEaJaO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 05:30:14 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hWdrY-00063e-DK; Fri, 31 May 2019 11:30:12 +0200
Date:   Fri, 31 May 2019 11:30:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft,v3 2/7] mnl: mnl_set_rcvbuffer() skips buffer size
 update if it is too small
Message-ID: <20190531093012.GH31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190530111246.14550-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530111246.14550-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Thu, May 30, 2019 at 01:12:46PM +0200, Pablo Neira Ayuso wrote:
> Check for existing buffer size, if this is larger than the newer buffer
> size, skip this size update.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v3: 'len' variable was not properly set.
> 
>  src/mnl.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 288a887df097..2270a084ad29 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -235,8 +235,15 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
>  
>  static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
>  {
> +	unsigned int cur_bufsiz;
> +	socklen_t len = sizeof(cur_bufsiz);
>  	int ret;
>  
> +	ret = getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
> +			 &cur_bufsiz, &len);
> +	if (cur_bufsiz > bufsiz)
> +		return 0;
> +

For mnl_set_sndbuffer(), there is simply a global static variable
holding the last set value. Can't we use that here as well? I think of
something like:

+ static unsigned int nlsndbufsiz;

 static int mnl_set_rcvbuffer(const struct mnl_socket *nl, size_t bufsiz)
 {
+	socklen_t len = sizeof(nlsndbufsiz);
 	int ret;
 
+	if (!nlsndbufsiz)
+		ret = getsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_RCVBUF,
+				 &nlsndbufsiz, &len);
+	if (nlsndbufsiz >= bufsiz)
+		return 0;

Cheers, Phil
