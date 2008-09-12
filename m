From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Changing IP destination in NF_IP_PRE_ROUTING hook
Date: Fri, 12 Sep 2008 09:25:41 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809120918320.14464@fbirervta.pbzchgretzou.qr>
References: <f4a980250809120428l14a26a31j1a08725404470fc4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Partha Majumdar <pmajumdar.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45143 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbYILNZo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2008 09:25:44 -0400
In-Reply-To: <f4a980250809120428l14a26a31j1a08725404470fc4@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-09-12 07:28, Partha Majumdar wrote:
>
>I am not very familiar with Linux kernel internals. I am trying to
>write a simple netfilter hook but facing some issues and did not find
>any clear answer in available docs on packet filter or netfilter
>hacking.
>
>I am writing an experimental kernel module that will register a
>NF_IP_PRE_ROUTING hook. This hook will change the destination address
>of the IP header. After that I'll update the checksum of the IP header
>by calling ip_nat_cheat_check as it is done in manip_pkt. Do I need to
>update the TCP checksum as well (if it is a TCP packet) since the
>pseudo header of the packet has changed? If I need to do update the
>tcp checksum as well then why isn't it being done  mainp_pkt after
>changing the source or destination IP address?

What you want to achieve sounds pretty much like the RAWNAT
extension:
http://dev.medozas.de/gitweb.cgi?p=xtables-addons;a=summary

>I also want to do similar modification for IPv6 packets. For IPv4 I
>have seen that skb_ip_make_writable is being called before modifying
>the IPv4 headers. I did not find anything similar for IPv6. What is
>the logic I should follow for IPv6?

It is always skb_make_writable().
