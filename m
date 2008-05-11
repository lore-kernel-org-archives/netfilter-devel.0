From: "cyx" <cyx@fiberhome.com.cn>
Subject: CAN you give me a piece of sample code to implement this iptables command? thanks
Date: Sun, 11 May 2008 22:43:51 +0800
Message-ID: <200805112243513753221@fiberhome.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [61.183.207.101] ([61.183.207.101]:62912 "EHLO
	mail.fiberhome.com.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYEKOoq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2008 10:44:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

HI, all:

the command is "iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE"

how to write the code using libiptc to implement this? It is hard to get enough useful information about programing with libiptc APIs, so can you give me the sample code ? thanks a lot!

