From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 0/2] iptables: add secmark match
Date: Tue, 05 Mar 2013 12:48:35 +0000
Message-ID: <5135E9A3.9070506@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Fedora SELinux Users <selinux@lists.fedoraproject.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:45241 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3CEMsp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:48:45 -0500
Received: by mail-wi0-f173.google.com with SMTP id hq4so46496wib.6
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2013 04:48:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The secmark match is used to match the security mark value
associated with a packet. For this extension to be available, the appropriate
SELinux support needs to be installed and present in the Linux kernel.

Examples:

iptables -I INPUT -p icmp --icmp-type 3 -m secmark --selctx system_u:object_r:dns_packet_t:s0 -j ACCEPT

iptables -I OUTPUT -m secmark --selctx system_u:object_r:ssh_packet_t:s0 -j DROP


Mr Dash Four (2):
   iptables (userspace): add secmark match
   iptables (kernel): add secmark match




