From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Sun, 18 Nov 2007 14:21:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711181407270.17843@blackhole.kfki.hu>
References: <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net>
 <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr>
 <20071116.044413.227110480.davem@davemloft.net> <473D91E9.4010809@trash.net>
 <20071116153541.GA25986@linuxace.com> <473DBB8C.9020709@trash.net>
 <473E27E9.4080306@treenet.co.nz> <473F120F.80508@trash.net>
 <Pine.LNX.4.64.0711172208490.2240@fbirervta.pbzchgretzou.qr>
 <473FA140.7080708@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:49601 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbXKRNVW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Nov 2007 08:21:22 -0500
In-Reply-To: <473FA140.7080708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Sun, 18 Nov 2007, Patrick McHardy wrote:

> For people who want to compile-test them all (like me), we
> still can have a CONFIG_NETFILTER_ALL option hidden under
> CONFIG_NETFILTER_ADVANCED for simplicity, but that is a
> different topic.

I think the other way around would be better:

CONFIG_NETFILTER		enable everyting
CONFIG_NETFILTER_WITHOUT_NAT	everything except NAT
CONFIG_NETFILTER_ADVANCED	select modules manually

This is more or less the most usual cases: typically almost everyone wants 
NAT and the wide range of matches and targets. Some places don't use NAT. 
And if someone wants to exclude modules or disable settings like 
conntrack flow accounting, in advanced mode it'd be possible to do so.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
