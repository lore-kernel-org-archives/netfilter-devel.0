From: Patrick McHardy <kaber@trash.net>
Subject: iptables warnings on 64 bit
Date: Mon, 14 Apr 2008 08:54:47 +0200
Message-ID: <4802FFB7.1060802@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63482 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303AbYDNGyx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:54:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It appears your attempts to remove all warnings weren't entirely
successful, some of there even appear to be new (like all the
field precision warnings). It could also be the case that I simply
missed them previously in the noise, I'm not sure:


iptables.c: In function 'print_firewall':
iptables.c:741: warning: passing argument 1 of 'ipt_get_target' discards 
qualifiers from pointer target type
iptables.c: In function 'print_firewall_line':
iptables.c:854: warning: passing argument 1 of 'ipt_get_target' discards 
qualifiers from pointer target type
xtables.c: In function 'load_extension':
xtables.c:321: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:321: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:338: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:338: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
iptables-save.c: In function 'print_rule':
iptables-save.c:223: warning: passing argument 1 of 'ipt_get_target' 
discards qualifiers from pointer target type
iptables.c: In function 'print_firewall':
iptables.c:741: warning: passing argument 1 of 'ipt_get_target' discards 
qualifiers from pointer target type
iptables.c: In function 'print_firewall_line':
iptables.c:854: warning: passing argument 1 of 'ipt_get_target' discards 
qualifiers from pointer target type
xtables.c: In function 'load_extension':
xtables.c:321: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:321: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:338: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:338: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
iptables-save.c: In function 'print_rule':
iptables-save.c:223: warning: passing argument 1 of 'ipt_get_target' 
discards qualifiers from pointer target type
ip6tables.c: In function 'print_firewall':
ip6tables.c:741: warning: passing argument 1 of 'ip6t_get_target' 
discards qualifiers from pointer target type
ip6tables.c: In function 'print_firewall_line':
ip6tables.c:851: warning: passing argument 1 of 'ip6t_get_target' 
discards qualifiers from pointer target type
ip6tables-save.c: In function 'print_rule':
ip6tables-save.c:200: warning: passing argument 1 of 'ip6t_get_target' 
discards qualifiers from pointer target type
ip6tables.c: In function 'print_firewall':
ip6tables.c:741: warning: passing argument 1 of 'ip6t_get_target' 
discards qualifiers from pointer target type
ip6tables.c: In function 'print_firewall_line':
ip6tables.c:851: warning: passing argument 1 of 'ip6t_get_target' 
discards qualifiers from pointer target type
xtables.c: In function 'load_extension':
xtables.c:321: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:321: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:338: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
xtables.c:338: warning: field precision should have type 'int', but 
argument 4 has type 'long int'
ip6tables-save.c: In function 'print_rule':
ip6tables-save.c:200: warning: passing argument 1 of 'ip6t_get_target' 
discards qualifiers from pointer target type
