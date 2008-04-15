From: Patrick McHardy <kaber@trash.net>
Subject: ip6tables broken
Date: Tue, 15 Apr 2008 15:23:36 +0200
Message-ID: <4804AC58.3000604@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37013 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbYDONXj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:23:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Using the net-2.6.26.git/latest SVN tree I get:

[96565.511804] ip6_tables: MARK target: invalid size 4 != 8
[96565.536937] ip6_tables: MARK target: invalid size 4 != 8
[96565.570762] ip6_tables: MARK target: invalid size 4 != 8

Userspace chooses revision 2, the kernel apparently revision 0.
I'm pretty certain this is some fallout from your latest patches.

