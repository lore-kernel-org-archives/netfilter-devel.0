From: ilninno <ilninno@gmail.com>
Subject: Hi again, get the process id associated to a packet
Date: Mon, 5 Jan 2009 01:43:14 +0100
Message-ID: <92770c820901041643t1b460c2bj4323a60ffcfc2c94@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:47428 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZAEAnR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:43:17 -0500
Received: by gxk6 with SMTP id 6so5578321gxk.13
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Jan 2009 16:43:14 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again, im the insistent newbie :)

Im trying to get packet pid (process identifier) but netfilter and
nfnetlink functions aren't very clear:

I saw a reference to packed pid in:

 struct nlmsghdr
{
	__u32		nlmsg_len;	/* Length of message including header */
	__u16		nlmsg_type;	/* Message content */
	__u16		nlmsg_flags;	/* Additional flags */
	__u32		nlmsg_seq;	/* Sequence number */
	__u32		nlmsg_pid;	/* Sending process port ID */
};

but isnt easy to get struct nlmsghdr from netfilter packet, i saw some
could be but im not sure:

extern struct nlmsghdr *nfnl_get_msg_first(struct nfnl_handle *h,
					   const unsigned char *buf,
					   size_t len);

I don't know what is buf and len, i saw library code with ddd but
description is very short and i dont know how can i get buf and what
is exactly. Please someone can help me to get packet's pid? I tried
using netstat (-ntap | grep sourceport and destination ip)  but is too
slow.

Thanks for your time and sorry for my english.
