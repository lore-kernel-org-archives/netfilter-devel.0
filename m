From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: netfilter: nf_ct_helper: implement variable length helper
 private data
Date: Mon, 18 Jun 2012 16:13:27 +0300
Message-ID: <20120618131327.GB24400@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51099 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2FRNNp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:13:45 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Pablo Neira Ayuso,

This is a semi-automatic email about new static checker warnings.

The patch 1afc56794e03: "netfilter: nf_ct_helper: implement variable 
length helper private data" from Jun 7, 2012, leads to the following 
Smatch complaint:

net/netfilter/nf_conntrack_netlink.c:1231 ctnetlink_change_helper()
	 error: we previously assumed 'help->helper' could be null (see line 1228)

net/netfilter/nf_conntrack_netlink.c
  1227			}
  1228			if (help->helper)
                            ^^^^^^^^^^^^
If help->helper is non-NULL we return here.

  1229				return -EBUSY;
  1230			/* need to zero data of old helper */
  1231			memset(help->data, 0, help->helper->data_len);
                                              ^^^^^^^^^^^^^^^^^^^^^^
This is always lead to a NULL dereference here.

  1232		} else {
  1233			/* we cannot set a helper for an existing conntrack */

regards,
dan carpenter

