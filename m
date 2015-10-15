From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH nf-next 2/2] netfilter: nfnetlink_log: validate
 dependencies to avoid breaking atomicity
Date: Thu, 15 Oct 2015 11:37:06 +0900
Message-ID: <20151015023706.GA16497@gmail.com>
References: <1444733268-8564-1-git-send-email-pablo@netfilter.org>
 <1444733268-8564-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36782 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbJOChN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Oct 2015 22:37:13 -0400
Received: by pabws5 with SMTP id ws5so8090819pab.3
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2015 19:37:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1444733268-8564-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 Thank you for your usual support.
 
On Tue, Oct 13, 2015 at 12:47:47PM +0200, Pablo Neira Ayuso wrote:
> @Ken-ichirou: Could you give a test to this patches? Thanks.

I've tested these with appended and is fine, of course.
Before applying patches:

    # ./a.out 123
    a.out: empty_cfg.c:56: main: Assertion `mnl_cb_run(buf, ret, 0, portid, ((void *)0), ((void *)0)) == -1' failed.
    Aborted

On Tue, Oct 13, 2015 at 12:47:48PM +0200, Pablo Neira Ayuso wrote:
> +#ifdef CONFIG_MODULES
> +			nfnl_unlock(NFNL_SUBSYS_ULOG);
> +			request_module("ip_conntrack_netlink");
> +			nfnl_lock(NFNL_SUBSYS_ULOG);
> +			if (rcu_access_pointer(nfnl_ct_hook)) {
> +				ret = -EAGAIN;
> +				goto out_put;
> +			}
> +#endif
> +			ret = -EOPNOTSUPP;
> +			goto out_put;

It's off the subject, but this fixes module unload. It was not
put instance at my first patch, Thanks!

--YiEDa0DAkWCtVeE4
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="empty_cfg.c"

/*
 * This example is placed in the public domain.
 * cc empty_cfg.c -lmnl -lnetfilter_log
 */

#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <errno.h>
#include <assert.h>

#include <linux/netfilter/nfnetlink_log.h>

#include <libmnl/libmnl.h>
#include <libnetfilter_log/libnetfilter_log.h>

int main(int argc, char *argv[])
{
	struct mnl_socket *nl;
	char buf[MNL_SOCKET_BUFFER_SIZE];
	struct nlmsghdr *nlh;
	int ret;
	unsigned int portid, qnum;

	if (argc != 2) {
		printf("Usage: %s [queue_num]\n", argv[0]);
		exit(EXIT_FAILURE);
	}
	qnum = atoi(argv[1]);

	nl = mnl_socket_open(NETLINK_NETFILTER);
	if (nl == NULL) {
		perror("mnl_socket_open");
		exit(EXIT_FAILURE);
	}

	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
		perror("mnl_socket_bind");
		exit(EXIT_FAILURE);
	}
	portid = mnl_socket_get_portid(nl);

	nlh = nflog_nlmsg_put_header(buf, NFULNL_MSG_CONFIG, AF_UNSPEC, qnum);
	nlh->nlmsg_flags |= NLM_F_ACK;
	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
		perror("mnl_socket_sendto");
		exit(EXIT_FAILURE);
	}

	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
	if (ret == -1) {
		perror("mnl_socket_recvfrom");
		exit(EXIT_FAILURE);
	}

	assert(mnl_cb_run(buf, ret, 0, portid, NULL, NULL) == MNL_CB_ERROR);
	assert(errno == ENODEV);

	mnl_socket_close(nl);

	return 0;
}

--YiEDa0DAkWCtVeE4--
