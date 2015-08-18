From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [lnf-log RFC PATCH 2/2] utils: take a example from libmnl and
 use nflog_nlmsg_parse
Date: Tue, 18 Aug 2015 08:04:22 +0200
Message-ID: <20150818060409.GA3062@salvia>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32904 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbbHRF6T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 01:58:19 -0400
Content-Disposition: inline
In-Reply-To: <20150810081752.GD25169@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This code can be generalized a bit so you can place it in
src/nlmsg.c, see below.

On Mon, Aug 10, 2015 at 05:17:53PM +0900, Ken-ichirou MATSUZAWA wrote:
[...]
> +static struct nlmsghdr *
> +nflog_build_cfg_pf_request(char *buf, uint8_t command)
> +{
> +	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> +	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
> +	nlh->nlmsg_flags = NLM_F_REQUEST;
> +
> +	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> +	nfg->nfgen_family = AF_INET;
> +	nfg->version = NFNETLINK_V0;
> +
> +	struct nfulnl_msg_config_cmd cmd = {
> +		.command = command,
> +	};
> +	mnl_attr_put(nlh, NFULA_CFG_CMD, sizeof(cmd), &cmd);
> +
> +	return nlh;
> +}

I suggest you use and implement the following new helper functions for
libnetfilter_log:

struct nlmsghdr *
nfnl_nlmsg_put_header(char *buf, uint8_t type, uint8_t cmd, uint16_t qnum);

int nfnl_attr_put_cfg_mode(struct nlmsghdr *nlh, struct nfulnl_msg_config_mode *mode);
int nfnl_attr_put_cfg_cmd(struct nlmsghdr *nlh, struct nfulnl_msg_config_cmd *cmd);

You can reuse code in the functions here below to make it. Thanks.

> +static struct nlmsghdr *
> +nflog_build_cfg_request(char *buf, uint8_t command, int qnum)
> +{
> +	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> +	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
> +	nlh->nlmsg_flags = NLM_F_REQUEST;
> +
> +	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> +	nfg->nfgen_family = AF_INET;
> +	nfg->version = NFNETLINK_V0;
> +	nfg->res_id = htons(qnum);
> +
> +	struct nfulnl_msg_config_cmd cmd = {
> +		.command = command,
> +	};
> +	mnl_attr_put(nlh, NFULA_CFG_CMD, sizeof(cmd), &cmd);
> +
> +	return nlh;
> +}
> +
> +static struct nlmsghdr *
> +nflog_build_cfg_params(char *buf, uint8_t mode, int range, int qnum)
> +{
> +	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> +	nlh->nlmsg_type	= (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
> +	nlh->nlmsg_flags = NLM_F_REQUEST;
> +
> +	struct nfgenmsg *nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> +	nfg->nfgen_family = AF_UNSPEC;
> +	nfg->version = NFNETLINK_V0;
> +	nfg->res_id = htons(qnum);
> +
> +	struct nfulnl_msg_config_mode params = {
> +		.copy_range = htonl(range),
> +		.copy_mode = mode,
> +	};
> +	mnl_attr_put(nlh, NFULA_CFG_MODE, sizeof(params), &params);
> +
> +	return nlh;
> +}
> +
[...]
