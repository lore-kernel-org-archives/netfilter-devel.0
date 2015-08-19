From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [lnf-log RFC PATCH 2/2] utils: take a example from libmnl and
 use nflog_nlmsg_parse
Date: Thu, 20 Aug 2015 00:04:03 +0200
Message-ID: <20150819220403.GA5220@salvia>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55185 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbbHSV5u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 17:57:50 -0400
Content-Disposition: inline
In-Reply-To: <20150819071103.GA15064@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 19, 2015 at 04:11:03PM +0900, Ken-ichirou MATSUZAWA wrote:
[...]
> Would you confirm the functions for nlmsg building which you suggested
> to add because it's a little different from you suggested. I am worried
> about it's in accodance with your intention.

I suggest you remove the nflog_data_init(), nflog_data_alloc(),
nflog_data_free() and nflog_nlmsg_parse().

Those are part of the old API, we should focus on API that we can
combine with libmnl.

More comments below:

> In addition, I added NFLOG_DATA_SIZE as is, the size of struct
> nflog_data. This enables to preallocate buffer, and I added
> functions which initialize a buffer based on this.
> 
> Would you see it again?
> 
> Changes from previous:
>   * introduce nlmsg three build functions:
>     struct nlmsghdr *
>       nfnl_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum);
>     int nfnl_attr_put_cfg_mode(struct nlmsghdr *nlh, struct nfulnl_msg_config_mode *mode);
>     int nfnl_attr_put_cfg_cmd(struct nlmsghdr *nlh, struct nfulnl_msg_config_cmd *cmd);

One small change more, please change this interface from:

+       nfcmd.command = NFULNL_CFG_CMD_PF_UNBIND;
+       if (nfnl_attr_put_cfg_cmd(nlh, &nfcmd) < 0) {

to:

        if (nfnl_attr_put_cfg_cmd(nlh, NFULNL_CFG_CMD_PF_UNBIND) < 0) {

Same thing with nfnl_attr_put_cfg_mode(), replace this:

+       nfmode.copy_mode = NFULNL_COPY_PACKET;
+       nfmode.copy_range = 0xFFFF;
+       if (nfnl_attr_put_cfg_mode(nlh, &nfmode) < 0) {

to:
        if (nfnl_attr_put_cfg_mode(nlh, NFULNL_COPY_PACKET, 0xffff)

>   * introduce NFLOG_DATA_SIZE macro and use it at allocate functions.

You can remove NFLOG_DATA_SIZE, this is only needed by the old API,
not for libmnl.

>   * update utils/nf-log to fit with the above.

Thanks a lot!
