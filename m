From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: iptables version defines
Date: Fri, 30 May 2008 10:16:02 +0200
Message-ID: <200805301016.03130.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:42335 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbYE3I0b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 04:26:31 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re01.intra2net.com (Postfix) with ESMTP id 996B34EA3
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2008 10:16:08 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id 9A7EF1F76
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2008 10:16:07 +0200 (CEST)
Received: from storm.m.i2n (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTP id 3683F19E0
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2008 10:16:04 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello netfilter coreteam,

I'm currently looking for a way to support ipt_ACCOUNT
both for iptables 1.4.0 and iptables 1.4.1. Some function
names changed (addr_to_dotted() -> ipaddr_to_numeric())
and it would be easy to #ifdef around them.

The linux kernel provides multiple defines for its version number,
while iptables only supports a char* version string.

Would it make sense to add something like the kernel version defines
so one could write code like this:

#if IPTABLES_VERSION_CODE < IPTABLES_VERSION(1,4,1)
	abc
#else
	xyz
#endif

?

Another solution would be to have an "iptables" and "iptables-1.4.1"
directory in the pom archive, though I don't know if that is supported.
(and would lead to code duplication.)

Thanks,
Thomas
