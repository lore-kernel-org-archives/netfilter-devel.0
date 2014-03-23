From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 5/8] ipfix: add function for ipfix message creation
Date: Sun, 23 Mar 2014 21:06:05 +0100
Message-ID: <1395605165.23474.29.camel@ice-age2.regit.org>
References: <20140308010344.GA4415@gmail.com>
	 <20140308011345.GF4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:40279 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaCWUGP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2014 16:06:15 -0400
In-Reply-To: <20140308011345.GF4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Sat, 2014-03-08 at 10:13 +0900, Ken-ichirou MATSUZAWA wrote:
> This function creates ipfix message, template and data part but not scope.
> Header sequence is kept by struct ipfix_instance, domain id is specified
> by config file. The returned value has no export time so caller set this
> and free the value after using it.
> 
> ---
>  include/ulogd/ipfix_protocol.h |  8 ++++-
>  output/ulogd_output_IPFIX.c    | 71 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/include/ulogd/ipfix_protocol.h b/include/ulogd/ipfix_protocol.h
> index 5d7e46a..266897e 100644
> --- a/include/ulogd/ipfix_protocol.h
> +++ b/include/ulogd/ipfix_protocol.h
> @@ -15,7 +15,13 @@ struct ipfix_msg_hdr {

...

> +
> +	msglen = sizeof(struct ipfix_msg_hdr) + sizeof(struct ipfix_set_hdr)
> +		+ template->data_length;
> +	if (need_template)
> +		msglen = msglen + sizeof(struct ipfix_set_hdr)
> +			+ (template->tmpl_cur - (void *)&template->tmpl);
> +	buf = malloc(msglen);


I don't like this malloc because ulogd will do an allocation for each
messages. If the size of the message has a global limit (looks like it
should be the case) it is possible to use a buffer attached to the ulogd
instance and to write the message in this buffer.

BR,
-- 
Eric Leblond <eric@regit.org>

