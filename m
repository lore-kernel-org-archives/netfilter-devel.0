From: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Subject: libnfnetlink: Strange behaviour in nfnl_fill_hdr
Date: Tue, 13 May 2008 09:30:02 +0100
Message-ID: <4829518A.6040904@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41730 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755861AbYEMIaG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 04:30:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am trying to use libnetfilter-log and libnfnetlink on a router with 
armeb architecture running OpenWRT. I cross-compiled the libraries, but 
have problems with the test tool nfulnl_test. When I run it I get:

"unbinding existing nf_log handler for AF_INET (if any)
nfnl_talk: sendmsg(netlink) Message too long 

error nflog_unbind_pf()"

The problem is caused by nfnl_fill_hdr from libnfnetlink. Here is the 
start of the function with two printfs added by me:

void nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
		    struct nlmsghdr *nlh, unsigned int len,
		    u_int8_t family,
		    u_int16_t res_id,
		    u_int16_t msg_type,
		    u_int16_t msg_flags)
{
	assert(ssh);
	assert(nlh);

	struct nfgenmsg *nfg = (struct nfgenmsg *)
					((void *)nlh + sizeof(*nlh));

	nlh->nlmsg_len = NLMSG_LENGTH(len+sizeof(*nfg));
	printf("nfnfl len %d\n", nlh->nlmsg_len);
	printf("nfnfl len %d\n", nlh->nlmsg_len);

The first printf prints 20 (0x14), whereas the second one prints 1310720 
(0x140000). The length stays on 1310720, which causes the "Message too 
long" error.

There is some magic going on. I supect this being a compiler bug. Else I 
have no explanation for shifting 16bit or half-word swapping for no 
reason. Can someone imagine another reason for this strange behaviour?

Regards,

Fabian


PS: If you think, I should have posted to the user list, just let me know.


Stacktrace:
main (nfulnl_test.c)
nflog_unbind_pf (libnetfilter_loc.c)
__build_send_cfg_msg (libnetfilter_log.c)
nfnl_fill_hdr (libnfnetlink.c)

Software:
libnetfilter_log 0.0.13
libnfnetlink 0.0.30
linux 2.6.24.2
armeb-linux-gcc 4.1.2
