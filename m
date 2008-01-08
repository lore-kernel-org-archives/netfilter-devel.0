From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Use const in struct xt_match, xt_target, xt_table
Date: Tue, 08 Jan 2008 17:28:52 +0100
Message-ID: <4783A4C4.4030809@trash.net>
References: <Pine.LNX.4.64.0801081325380.3032@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbYAHQcu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:32:50 -0500
In-Reply-To: <Pine.LNX.4.64.0801081325380.3032@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> origin git://computergmbh.de/linux netfilter
> commit 911b3c3680fd17409c64a6589cfcaf18e4fa04ce
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Tue Jan 8 13:25:08 2008 +0100
> 
>     [NETFILTER]: Use const in struct xt_match, xt_target, xt_table

This causes compiler warnings:

net/ipv6/netfilter/ip6_tables.c: In function 'ip6t_do_table':
net/ipv6/netfilter/ip6_tables.c:407: warning: passing argument 5 of 
'trace_packet' discards qualifiers from pointer target type
net/ipv6/netfilter/ip6_tables.c:406: warning: passing argument 5 of 
'trace_packet' discards qualifiers from pointer target type
