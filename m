From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [lnf-log RFC PATCH 2/2] utils: take a example from libmnl and
 use nflog_nlmsg_parse
Date: Wed, 19 Aug 2015 16:11:03 +0900
Message-ID: <20150819071103.GA15064@gmail.com>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34608 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbbHSHLJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 03:11:09 -0400
Received: by paccq16 with SMTP id cq16so107511544pac.1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2015 00:11:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150818060409.GA3062@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Thank you for comment.

On Tue, Aug 18, 2015 at 08:04:22AM +0200, Pablo Neira Ayuso wrote:
> I suggest you use and implement the following new helper functions for
> libnetfilter_log:
> 
> struct nlmsghdr *
> nfnl_nlmsg_put_header(char *buf, uint8_t type, uint8_t cmd, uint16_t qnum);
> 
> int nfnl_attr_put_cfg_mode(struct nlmsghdr *nlh, struct nfulnl_msg_config_mode *mode);
> int nfnl_attr_put_cfg_cmd(struct nlmsghdr *nlh, struct nfulnl_msg_config_cmd *cmd);

Would you confirm the functions for nlmsg building which you suggested
to add because it's a little different from you suggested. I am worried
about it's in accodance with your intention.

In addition, I added NFLOG_DATA_SIZE as is, the size of struct
nflog_data. This enables to preallocate buffer, and I added
functions which initialize a buffer based on this.

Would you see it again?

Changes from previous:
  * introduce nlmsg three build functions:
    struct nlmsghdr *
      nfnl_nlmsg_put_header(char *buf, uint8_t type, uint8_t family, uint16_t qnum);
    int nfnl_attr_put_cfg_mode(struct nlmsghdr *nlh, struct nfulnl_msg_config_mode *mode);
    int nfnl_attr_put_cfg_cmd(struct nlmsghdr *nlh, struct nfulnl_msg_config_cmd *cmd);
    
  * introduce NFLOG_DATA_SIZE macro and use it at allocate functions.
  * update utils/nf-log to fit with the above.
