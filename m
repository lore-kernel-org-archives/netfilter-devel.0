From: Eric Leblond <eric@regit.org>
Subject: Re: [nftables 3/3] mnl: improve select timeout logic
Date: Wed, 24 Jun 2015 11:31:16 +0200
Message-ID: <1435138276.18335.10.camel@regit.org>
References: <1435132311-31452-1-git-send-email-eric@regit.org>
	 <1435132311-31452-4-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48543 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbbFXJbX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jun 2015 05:31:23 -0400
Received: from dhcp150.ki.iif.hu ([193.6.223.150] helo=tiger2)
	by ks28632.kimsufi.com with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <eric@regit.org>)
	id 1Z7h1d-0002GJ-Jv
	for netfilter-devel@vger.kernel.org; Wed, 24 Jun 2015 11:31:22 +0200
In-Reply-To: <1435132311-31452-4-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Following live discussion with Pablo, please disregard this patch.
Sending a v2 in the following minutes.

BR,

On Wed, 2015-06-24 at 09:51 +0200, Eric Leblond wrote:
> This patch explicitely set timeout for select in mnl_batch_talk.
> Timeout used at the second call was the time spend on first select
> and this was not looking correct. Instead this patch set a short
> timeout as we are supposed to dequeue waiting kernel messages.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  src/mnl.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 76a9714..2da1074 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -246,7 +246,7 @@ int mnl_batch_talk(struct mnl_socket *nl, struct 
> list_head *err_list)
>  	char rcv_buf[MNL_SOCKET_BUFFER_SIZE];
>  	fd_set readfds;
>  	struct timeval tv = {
> -		.tv_sec		= 0,
> +		.tv_sec		= 10,
>  		.tv_usec	= 0
>  	};
>  
> @@ -274,6 +274,8 @@ int mnl_batch_talk(struct mnl_socket *nl, struct 
> list_head *err_list)
>  		if (ret == -1)
>  			mnl_err_list_node_add(err_list, errno, nlh
> ->nlmsg_seq);
>  
> +		tv.tv_sec = 0;
> +		tv.tv_usec = 1000;
>  		ret = select(fd+1, &readfds, NULL, NULL, &tv);
>  		if (ret == -1)
>  			return -1;
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

