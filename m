From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: Reading rules from multiple files
Date: Sat, 5 Mar 2016 22:54:04 +0530
Message-ID: <CAKrM2Xm9d76ZxvSL-WPk+W62dX1QCFk6pB0r=g_ktajHZkz2mg@mail.gmail.com>
Reply-To: ppang@linux.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:34369 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcCERYF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 12:24:05 -0500
Received: by mail-vk0-f43.google.com with SMTP id e185so82590635vkb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 05 Mar 2016 09:24:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently in nftables , reading rules from files ( '-f/--file
filename' ) works only with a single file.
If a directory contains multiple rule files , it cant be done by :

 $ nft -f /usr/local/etc/nftables/*
<cmdline>:1:1-1: Error: syntax error, unexpected /
/usr/local/etc/nftables/inet-filter /usr/local/etc/nftables/ipv4-filter

instead
$ nft -f /usr/local/etc/nftables/inet-filter -f
/usr/local/etc/nftables/ipv4-mangle

but adding '-f' each time for a file is cumbersome .

Is this behaviour ignored for some reasons ?
