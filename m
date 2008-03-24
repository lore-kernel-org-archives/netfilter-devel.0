From: Hugo Mildenberger <Hugo.Mildenberger@t-online.de>
Subject: valgrind warning in libnetfilter_log.c
Date: Mon, 24 Mar 2008 14:47:40 +0100
Message-ID: <200803241447.41041.Hugo.Mildenberger@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout11.sul.t-online.de ([194.25.134.85]:43777 "EHLO
	mailout11.sul.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbYCXOHF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:07:05 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is output from valgrind, pointing to a possible problem in 
libnetfilter_log.c +307. 

==16332== Syscall param socketcall.sendmsg(msg.msg_iov[i]) points to 
uninitialised byte(s)
==16332==    at 0x40E0316: sendmsg (socket.S:65)
==16332==    by 0x42632AA: nflog_set_mode (libnetfilter_log.c:307)
==16332==    by 0x424315B: start (ulogd_inppkt_NFLOG.c:466)
==16332==    by 0x804C5E9: create_stack (ulogd.c:961)
==16332==    by 0x804E85B: cfg_parser_action_plugin (cfg_parser.l:524)
==16332==    by 0x805040F: cfg_parser (cfg_parser.l:590)
==16332==    by 0x805061B: cfg_parser_parse_file (cfg_parser.l:773)
==16332==    by 0x804D4B1: config_parse_file (conffile.c:260)
==16332==    by 0x804B497: main (ulogd.c:1405)
==16332==  Address 0xBE8B29F5 is on thread 1's stack

excerpt from libnetfilter_log.c:
int nflog_set_mode(struct nflog_g_handle *gh,
                   u_int8_t mode, u_int32_t range)
{
        char buf[NFNL_HEADER_LEN
                +NFA_LENGTH(sizeof(struct nfulnl_msg_config_mode))];
        struct nfulnl_msg_config_mode params;
        struct nlmsghdr *nmh = (struct nlmsghdr *) buf;

        nfnl_fill_hdr(gh->h->nfnlssh, nmh, 0, AF_UNSPEC, gh->id,
                      NFULNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);

        params.copy_range = htonl(range);       /* copy_range is short */
        params.copy_mode = mode;
        nfnl_addattr_l(nmh, sizeof(buf), NFULA_CFG_MODE, &params,
                       sizeof(params));

        return nfnl_talk(gh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
}

The warning  could not be suppressed by zeroing the message buffer in 
nflog_setmode, but it could be suppressed by zeroing  struct 
nfulnl_msg_config_mode params: 

excerpt from libnetfilter_log/linux_nfnetlink_log.h:
struct nfulnl_msg_config_mode {
        u_int32_t       copy_range;
        u_int8_t        copy_mode;
        u_int8_t        _pad;
} __attribute__ ((packed));

Therefore, this warning is caused by "_pad" remaining uninitialised. 
Referencing "_pad" explicitely would be  somewhat unpleasant. Using memset 
would induce additional computation only to suppress a warning. Best solution 
would be to extend .copy_mode from u_int8_t to u_int16_t and drop ._pad 
completely. There are more issues like that in linux_nfnetlink_log.h. I 
wonder why this approach was choosen to achieve 16-bit alignment: "_pad " 
will be transmitted anyway.


