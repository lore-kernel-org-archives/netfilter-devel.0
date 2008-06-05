From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Thu, 05 Jun 2008 20:13:24 +0200
Message-ID: <48482CC4.1090103@trash.net>
References: <483AB493.6010503@trash.net> <x6skw443x5@gzp>	<483BB9DE.6050003@trash.net> <x6y75w3q2j@gzp>	<483C088E.4020405@trash.net> <x67idfq6d8@gzp>	<483CFF21.40608@trash.net> <4847F64C.2040902@trash.net>	<x663snremo@gzp> <4848200A.3060600@trash.net>	<alpine.LNX.1.10.0806051946330.29055@fbirervta.pbzchgretzou.qr>	<alpine.LNX.1.10.0806051953430.29055@fbirervta.pbzchgretzou.qr> <x6zlpzpxdv@gzp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "Gabor Z. Papp" <gzp@papp.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50045 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYFESNj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:13:39 -0400
In-Reply-To: <x6zlpzpxdv@gzp>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gabor Z. Papp wrote:
> * Jan Engelhardt <jengelh@medozas.de>:
>
> | commit 1ebc55e29f220082814a97e541427be7746400e0
>
> ok, iptables 1.4.1-rc2 with the patches now compiled fine on:
>   
Thanks a lot!
> [kernel]
> Linux gzp1 2.4.36.5-gzp1 #1 SMP Mon Jun 2 19:36:14 CEST 2008 i686
> GNU/Linux
>
> [glibc]
> GNU C Library stable release version 2.3.6, by Roland McGrath et al.
> Compiled by GNU CC version 4.1.2.
> Compiled on a Linux 2.4.34-gzp1 system on 2007-04-04.
>
> [gcc]
> gcc (GCC) 4.2.4
>
> [binutils]
> GNU ld (Linux/GNU Binutils) 2.18.50.0.7.20080502
>
> [autoconf]
> autoconf (GNU Autoconf) 2.62
>
> [automake]
> automake (GNU automake) 1.10.1
>
> [libtool]
> ltmain.sh (GNU libtool) 1.5.26 (1.1220.2.492 2008/01/30 06:40:56)
>
> The question is, how usable on this system. ;-)
>   

Everything supported by that kernel should work fine.

