From: net expert <netexpert201@gmail.com>
Subject: netlink_netfilter bind failure
Date: Tue, 19 Jan 2010 10:38:12 -0600
Message-ID: <e8b4413d1001190838p2975d4fbg22abd072993a25ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:43161 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab0ASQiQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2010 11:38:16 -0500
Received: by iwn35 with SMTP id 35so2995554iwn.4
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2010 08:38:13 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
    I am trying to create small user space application to listen for
netfilter configuration message. Following is the snapshot of my code.
I am getting a bind failure (Operation not permitted error) when I try
to bind socket to specific netlink messages. Can someone please help
me here ?

nlSocketId = socket(PF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
if (nlSocketId == -1)
    perror("socket create failure\n");
memset(&nlSockAddr, 0x00, sizeof(nlSockAddr));
nlSockAddr.nl_family = AF_NETLINK;
nlSockAddr.nl_groups = NFNLGRP_CONNTRACK_NEW;
if ( bind(nlSocketId, (struct sockaddr *) &nlSockAddr,
sizeof(nlSockAddr)) == -1)
{
   perror("bind failure");
}

-NP
