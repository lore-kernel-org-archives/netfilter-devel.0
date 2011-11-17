From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: RFC: Probably wrong code in nf_nat_snmp_basic.c
Date: Thu, 17 Nov 2011 22:14:02 +0100
Message-ID: <4EC5791A.1040005@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:33573 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1KQVOF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Nov 2011 16:14:05 -0500
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id 4F33730127
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2011 22:14:04 +0100 (CET)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id C48BF2AC54
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2011 22:14:03 +0100 (CET)
Received: from pikkukde.a.i2n (unknown [192.168.12.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by intranator.m.i2n (Postfix) with ESMTPS id 9E5282AC52
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Nov 2011 22:14:02 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

consider this piece of code from
net/ipv4/netfilter/nf_nat_snmp_basic.c:1198

---------------------------------------------
/*
    * Determine mappping for application layer addresses based
    * on NAT manipulations for the packet.
    */
if (dir == IP_CT_DIR_ORIGINAL) {
    /* SNAT traps */
    map.from = NOCT1(&ct->tuplehash[dir].tuple.src.u3.ip);
    map.to = NOCT1(&ct->tuplehash[!dir].tuple.dst.u3.ip);
} else {
    /* DNAT replies */
    map.from = NOCT1(&ct->tuplehash[dir].tuple.src.u3.ip);
    map.to = NOCT1(&ct->tuplehash[!dir].tuple.dst.u3.ip);
}
---------------------------------------------

cppcheck reported: (style) Found duplicate branches for if and else.


Either I need glasses or the code is exactly the same :)

Cheers,
Thomas
