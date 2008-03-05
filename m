From: Oleg Petrov <dsacode@yandex.ru>
Subject: Conntrack in-kernel question
Date: Wed, 05 Mar 2008 08:31:16 +0300
Message-ID: <1129421204695076@webmail25.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from webmail25.yandex.ru ([213.180.223.152]:59740 "EHLO
	webmail25.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132AbYCEFmz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 00:42:55 -0500
Received: from YAMAIL (webmail25) by mail.yandex.ru id S3687673AbYCEFbQ for
        <netfilter-devel@vger.kernel.org> (+ 1 other);
        Wed, 5 Mar 2008 08:31:16 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, Netfilter developers!

I'm working on kernel module used for network accounting and it's based
on amazing netfilter connection tracking code. But I lack some information
in nf_conn structure. Can you please advice what's preferable way of
getting such information:

1) In/out interface indices. More accurately, I'm interested in SNMP
interface indices to export accounting information but I hadn't seen
any interface stuff in conntrack code.

2) TCP connection flags and IP ToS (Type of Service).

If this is not implemented in conntrack, please describe me preferable
way for adding support of this into netfilter - and I'll do so.

Thank you in advance!

P.S.: I'm not subscribed to the list so please CC me your replies.
