From: Noel Butler <noel.butler@ausics.net>
Subject: BUG ip6tables and helper
Date: Thu, 19 Dec 2013 16:12:53 +1000
Message-ID: <b036229675020e020b2d1832e1251eec@ausics.net>
References: <20131122121232.GA5698@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from valhalla.ausics.net ([27.33.160.23]:60207 "EHLO mail.ausics.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3LSGXL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Dec 2013 01:23:11 -0500
Received: from mail.ausics.net (valhalla.ausics.net [10.10.0.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ausics.net (Postfix) with ESMTPSA id B5EFFC0E550
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Dec 2013 16:12:53 +1000 (EST)
In-Reply-To: <20131122121232.GA5698@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Bug with ip6tables and helpers

-j CT --helper irc

ip6tables: No chain/target/match by that name.


This *does* work with iptables


On 22/11/2013 22:12, Pablo Neira Ayuso wrote:

> Hi!
> 
> The Netfilter project proudly presents:
> 
> iptables 1.4.21
