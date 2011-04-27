From: Leo Baltus <Leo.Baltus@omroep.nl>
Subject: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 10:57:57 +0200
Message-ID: <20110427085755.GD2418@omroep.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out1b.mail.omroep.nl ([145.58.30.185]:59850 "EHLO
	out1b.mail.omroep.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab1D0JEn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:04:43 -0400
Received: from localhost (ou1bclean [10.10.30.159])
	by out1b.mail.omroep.nl (Postfix MTA - NPO ICT) with ESMTP id BBCB9400CB1
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2011 10:57:58 +0200 (CEST)
Received: from tech1a.mail.omroep.nl (tech1a.mail.omroep.nl [145.58.71.108])
	by out1b.mail.omroep.nl (Postfix MTA - NPO ICT) with ESMTP id A259E400CA0
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2011 10:57:58 +0200 (CEST)
Received: from localhost (horus.verhip.com [83.163.138.249])
	by tech1a.mail.omroep.nl (Postfix MTA - NPO ICT) with ESMTPSA id 5D168200E8EF
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2011 10:57:58 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

When doing recusive dns queries to dnssec-enbled servers it looks like
ip6tables does not assemble udp packets before filtering takes place.
This results in fragments being dropped.

Here's how to reproduce using bind-9.7.x or bind-9.8.x with fedora 14,
kernel 2.6.35.12-88

1. make /tmp/named./conf
        options {
                directory               "/tmp";
                recursion yes;
                listen-on-v6 { ::1; };
        };

2. start named

        named -6 -c /tmp/named.conf

3. my ip6tables filter

        # cleanup
        ip6tables -P INPUT ACCEPT;
        ip6tables -P OUTPUT ACCEPT;
        for table in $(cat /proc/net/ip6_tables_names); do
                ip6tables -t $table -F; 
                ip6tables -t $table -X;
                ip6tables -t $table -Z;
        done
        
        #accept icmp6
        ip6tables -A INPUT -j ACCEPT -p icmpv6
        ip6tables -A OUTPUT -j ACCEPT -p icmpv6
        
        # accept incoming dns
        ip6tables -A INPUT -j ACCEPT -p udp --dport 53
        ip6tables -A OUTPUT -j ACCEPT -p udp --sport 53
        
        # accept outgoing dns
        ip6tables -A INPUT -j ACCEPT -p udp --sport 53
        ip6tables -A OUTPUT -j ACCEPT -p udp --dport 53
        
        # drop policy
        ip6tables -A INPUT  -j LOG --log-level 6 --log-prefix 'drop in: '
        ip6tables -A OUTPUT -j LOG --log-level 6 --log-prefix 'drop out: '
        ip6tables -P INPUT DROP;
        ip6tables -P OUTPUT DROP;

4. Do a query to a dnssec servers, I use this test-setup:
 https://www.dns-oarc.net/oarc/services/replysizetest

        dig @::1  +short  rs.dns-oarc.net txt

5. The result should be
        'DNS reply size limit is at least 4091', or roundabout 4000

However we see fragments being dropped in the logs and a reply size
just under MTU so I assume no fragments get assembled:

Apr 27 10:43:38 leo kernel: [81648.003267] drop in: IN=eth0 OUT= MAC=00:--:--:--:--:--:--:--:--:--:--:--:--:-- SRC=2001:04f8:0003:02bc:0002:0000:0000:0135 DST=2a02:0458:0101:----:----:----:----:---- LEN=1496 TC=0 HOPLIMIT=56 FLOWLBL=0 FRAG:1448 INCOMPLETE ID:88b59425 PROTO=UDP 
Apr 27 10:43:38 leo kernel: [81648.003289] drop in: IN=eth0 OUT= MAC=00:--:--:--:--:--:--:--:--:--:--:--:--:-- SRC=2001:04f8:0003:02bc:0002:0000:0000:0135 DST=2a02:0458:0101:----:----:----:----:---- LEN=1243 TC=0 HOPLIMIT=56 FLOWLBL=0 FRAG:2896 ID:88b59425 PROTO=UDP 


-- 
Leo Baltus, internetbeheerder                         /\
NPO ICT Internet Services                            /NPO/\
Sumatralaan 45, 1217 GP Hilversum, Filmcentrum, west \  /\/
beheer@omroep.nl, 035-6773555                         \/
