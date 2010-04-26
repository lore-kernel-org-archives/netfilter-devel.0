From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: bridge filter can't deal with big package of vlan tag and
 ipsec
Date: Mon, 26 Apr 2010 14:45:13 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004261444350.27018@obet.zrqbmnf.qr>
References: <4BD4FE8E.0B9B63.09204@m12-11.163.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: fenglg <flg2932946@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36727 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab0DZMpP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Apr 2010 08:45:15 -0400
In-Reply-To: <4BD4FE8E.0B9B63.09204@m12-11.163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-04-26 04:31, fenglg wrote:

>netfilter-devel:
>    I use linux-2.6.18, and i have a ipsec vpn client and server, there are two swicthes using vlan trunk of 802.1Q between of the vpn client and server. 

That kernel is _so_ old that if we had any bugfixes up to now w.r.t. 
vlan (and I'm sure there were some threads) that I can't remember it 
anymore.

