Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28321C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 23:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76B360F70
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 23:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhIFXFg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 19:05:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40502 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhIFXFf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 19:05:35 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 32F0A6001B;
        Tue,  7 Sep 2021 01:03:23 +0200 (CEST)
Date:   Tue, 7 Sep 2021 01:04:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log] src: doc: revise doxygen for module
 "Netlink message helper functions"
Message-ID: <20210906230424.GA356@salvia>
References: <20210905023320.29740-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210905023320.29740-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 05, 2021 at 12:33:20PM +1000, Duncan Roe wrote:
> Adjust style to work better in a man page.
> Document actual return values.

All good, except one chunk I'm ambivalent.

> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  src/nlmsg.c | 53 +++++++++++++++++++++++++----------------------------
>  1 file changed, 25 insertions(+), 28 deletions(-)
> 
> diff --git a/src/nlmsg.c b/src/nlmsg.c
> index 3ebb364..399b19a 100644
> --- a/src/nlmsg.c
> +++ b/src/nlmsg.c
> @@ -18,15 +18,15 @@
>   */
>  
>  /**
> - * nflog_nlmsg_put_header - reserve and prepare room for nflog Netlink header
> - * \param buf memory already allocated to store the Netlink header
> - * \param type message type one of the enum nfulnl_msg_types
> - * \param family protocol family to be an object of
> - * \param qnum queue number to be an object of
> + * nflog_nlmsg_put_header - convert memory buffer into an nflog Netlink header

this is not just converting as in a cast, I understand "reserve and
prepare room" might not be so clear to understand.

> + * \param buf pointer to memory buffer
> + * \param type either NFULNL_MSG_PACKET or NFULNL_MSG_CONFIG

I'd keep above a reference to 'enum nfulnl_msg_types'.

> + * \param family protocol family
> + * \param qnum queue number

I remember you posted a patch to rename qh to gh, from queue handler
to group handler. You could rename this to 'group number'.

>   *
> - * This function creates Netlink header in the memory buffer passed
> - * as parameter that will send to nfnetlink log. This function
> - * returns a pointer to the Netlink header structure.
> + * Creates a Netlink header in _buf_ followed by
> + * a log\-subsystem\-specific extra header.

This function is adding the netlink + nfnetlink headers to the buffer
as well as setting up the header fields accordingly.

> + * \return pointer to created Netlink header structure
>   */
>  struct nlmsghdr *
>  nflog_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum)
