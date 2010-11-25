From: Shan Wei <shanwei@cn.fujitsu.com>
Subject: [Question] why are these macros not used?
Date: Thu, 25 Nov 2010 16:40:18 +0800
Message-ID: <4CEE20F2.1080102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52845 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0KYIts (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Nov 2010 03:49:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


My scripts find lots of macros in nf_nat_snmp_basic.c never 
be used after they are added to kernel in commit: 
commit 807467c22a12381985878be23c778657fc0364d0
Author: Patrick McHardy <kaber@trash.net>
Date:   Sat Dec 2 22:10:34 2006 -0800

    [NETFILTER]: nf_nat: add SNMP NAT helper port
    
    Add nf_conntrack port of the SNMP NAT helper.

Will these marcos be used in the future?
Or Is there any reasones for keeping them here?

====================
nf_nat_snmp_basic.c:SNMP_V1 unused!
nf_nat_snmp_basic.c:SNMP_V2C unused!
nf_nat_snmp_basic.c:SNMP_V3 unused!
nf_nat_snmp_basic.c:SNMP_SIZE_COMM unused!
nf_nat_snmp_basic.c:SNMP_SIZE_OBJECTID unused!
nf_nat_snmp_basic.c:SNMP_SIZE_BUFCHR unused!
nf_nat_snmp_basic.c:SNMP_SIZE_BUFINT unused!
nf_nat_snmp_basic.c:SNMP_SIZE_SMALLOBJECTID unused!
nf_nat_snmp_basic.c:SNMP_NOERROR unused!
nf_nat_snmp_basic.c:SNMP_TOOBIG unused!
nf_nat_snmp_basic.c:SNMP_NOSUCHNAME unused!
nf_nat_snmp_basic.c:SNMP_BADVALUE unused!
nf_nat_snmp_basic.c:SNMP_READONLY unused!
nf_nat_snmp_basic.c:SNMP_GENERROR unused!
nf_nat_snmp_basic.c:SNMP_NOACCESS unused!
nf_nat_snmp_basic.c:SNMP_WRONGTYPE unused!
nf_nat_snmp_basic.c:SNMP_WRONGLENGTH unused!
nf_nat_snmp_basic.c:SNMP_WRONGENCODING unused!
nf_nat_snmp_basic.c:SNMP_WRONGVALUE unused!
nf_nat_snmp_basic.c:SNMP_NOCREATION unused!
nf_nat_snmp_basic.c:SNMP_INCONSISTENTVALUE unused!
nf_nat_snmp_basic.c:SNMP_RESOURCEUNAVAILABLE unused!
nf_nat_snmp_basic.c:SNMP_COMMITFAILED unused!
nf_nat_snmp_basic.c:SNMP_UNDOFAILED unused!
nf_nat_snmp_basic.c:SNMP_AUTHORIZATIONERROR unused!
nf_nat_snmp_basic.c:SNMP_NOTWRITABLE unused!
nf_nat_snmp_basic.c:SNMP_INCONSISTENTNAME unused!
nf_nat_snmp_basic.c:SNMP_TRAP_COLDSTART unused!
nf_nat_snmp_basic.c:SNMP_TRAP_WARMSTART unused!
nf_nat_snmp_basic.c:SNMP_TRAP_LINKDOWN unused!
nf_nat_snmp_basic.c:SNMP_TRAP_LINKUP unused!
nf_nat_snmp_basic.c:SNMP_TRAP_AUTFAILURE unused!
nf_nat_snmp_basic.c:SNMP_TRAP_EQPNEIGHBORLOSS unused!
nf_nat_snmp_basic.c:SNMP_TRAP_ENTSPECIFIC unused!
nf_nat_snmp_basic.c:SNMP_UINTEGER unused!
nf_nat_snmp_basic.c:SNMP_NSAP unused!

-- 
Best Regards
-----
Shan Wei
