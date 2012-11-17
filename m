From: Iain Fraser <iainkfraser@gmail.com>
Subject: create and insert packet at timer event
Date: Sat, 17 Nov 2012 22:36:42 +0000
Message-ID: <CA+bLfK4jn0nbokHr1_xgs=kUvEpGSFVuYTBGT1P3Y5k-i4SBiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46311 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab2KQWgn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Nov 2012 17:36:43 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so5248753iea.19
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Nov 2012 14:36:43 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

For my experiments I would like to create ( alloc_skb ) and ip route a
packet on a timer event in a kernel module I'm developing.
1) It doesn't have an incoming device therefore I can't use netif_rx
2) It doesn't have a cached route or a socket ( in fact it may even
have a source ip for a different host )

Is there anyway I can pass it onto the ip_forward or something similar
( i.e. onto the tcp/ip network stack )?  At the moment I'm trying to
get a route using the following code:

rt = ip_route_output( &init_net, iph->daddr,/*iph->saddr*/ 0, 0, 0) ) ;

This crashes the kernel ( computer freezes up instantly ). I know
iph->daddr is correct using printk, So I'm guessing ( after studying
the source ) that init_net is
incorrect. I must be honest I don't really understand this network
namespace and not even sure if this is the right way to go to solve my
problem.

thanks in advance
Iain
