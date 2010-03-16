From: Thomas Woerner <twoerner@redhat.com>
Subject: Chain name length inconsistent
Date: Tue, 16 Mar 2010 16:35:29 +0100
Message-ID: <4B9FA541.7080408@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100Ab0CPPfc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:35:32 -0400
Received: from int-mx08.intmail.prod.int.phx2.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2GFZVFp012508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2010 11:35:31 -0400
Received: from [10.32.5.53] (unused [10.32.5.53] (may be forged))
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o2GFZTFq027510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Mar 2010 11:35:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

the size of a chain name is not consistent:

1) Adding a new chain name is checking for max length 30:

iptabels.c:1881 ( do_command):
         if (chain && strlen(chain) > IPT_FUNCTION_MAXNAMELEN)
                 xtables_error(PARAMETER_PROBLEM,
                            "chain name `%s' too long (must be under %i chars)",
                            chain, IPT_FUNCTION_MAXNAMELEN);

include/linux/netfilter_ipv4/ip_tables.h
#define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN

include/linux/netfilter/x_tables.h:
#define XT_FUNCTION_MAXNAMELEN 30


2) Using a jump target results in a check for max length 31:

iptables.c:1564 (do_command):
                         jumpto = parse_target(optarg);


iptables.c:464 (parse_target):
         if (strlen(targetname)+1 > sizeof(ipt_chainlabel))
                 xtables_error(PARAMETER_PROBLEM,
                            "Invalid target name `%s' (%u chars max)",
                            targetname, (unsigned int)sizeof(ipt_chainlabel)-1);

include/libiptc/libiptc.h:
         typedef char ipt_chainlabel[32];


3) But setting the target copies the name in an array of size 29:

iptables.c:1576 (do_command):
                                 strcpy(target->t->u.user.name, jumpto);

include/linux/netfilter/x_tables.h:
struct xt_entry_match {
         union {
                 struct {
                         __u16 match_size;

                         /* Used by userspace */
                         char name[XT_FUNCTION_MAXNAMELEN-1];

                         __u8 revision;
                 } user;
                 struct {
                         __u16 match_size;

                         /* Used inside the kernel */
                         struct xt_match *match;
                 } kernel;

                 /* Total length */
                 __u16 match_size;
         } u;

         unsigned char data[0];
};

Therefore all the checks should be for max length 29, right?

Please also have a look at
http://bugzilla.netfilter.org/show_bug.cgi?id=641
https://bugzilla.redhat.com/show_bug.cgi?id=545600


Thanks,
Thomas
