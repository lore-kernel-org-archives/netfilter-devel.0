From: Patrick McHardy <kaber@trash.net>
Subject: Re: Packet marked wrongly as INVALID?
Date: Fri, 02 Jul 2010 09:55:51 +0200
Message-ID: <4C2D9B87.3080508@trash.net>
References: <4C2C5C0A.3070109@cineca.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Marco Innocenti <m.innocenti@cineca.it>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44434 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0GBHzw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:55:52 -0400
In-Reply-To: <4C2C5C0A.3070109@cineca.it>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Marco Innocenti wrote:
> Hi,
>     on a couple of production server I get routinely some packet which 
> should be marked as NEW are marked as INVALID and I'm unable to 
> understand why or to reproduce the problem in a testing environment.
> I use distribution kernel (SUSE 2.6.16.60-0.58.1-smp and Debian 
> 2.6.26-2-amd64) on intel (64 bit) but I could try a recent kernel if 
> need arise.
>
>
> Jul  1 09:14:44 miur10 kernel: INPUT-INVALIDIN=bond0 OUT= 
> MAC=00:22:19:bb:85:7b:00:0b:fc:fe:1b:01:08:00 SRC=130.186.5.204 
> DST=10.253.0.11 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=47760 DF PROTO=TCP 
> SPT=53816 DPT=80 WINDOW=5840 RES=0x00 SYN URGP=0
> Jul  1 09:16:18 miur10 kernel: INPUT-INVALIDIN=bond0 OUT= 
> MAC=00:22:19:bb:85:7b:00:0b:fc:fe:1b:01:08:00 SRC=130.186.5.204 
> DST=10.253.0.11 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=13606 DF PROTO=TCP 
> SPT=54446 DPT=80 WINDOW=5840 RES=0x00 SYN URGP=0
> Jul  1 09:16:34 miur10 kernel: INPUT-INVALIDIN=bond0 OUT= 
> MAC=00:22:19:bb:85:7b:00:0b:fc:fe:1b:01:08:00 SRC=130.186.5.204 
> DST=10.253.0.11 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=15917 DF PROTO=TCP 
> SPT=54694 DPT=80 WINDOW=5840 RES=0x00 SYN URGP=0
> Jul  1 09:16:55 miur10 kernel: INPUT-INVALIDIN=bond0 OUT= 
> MAC=00:22:19:bb:85:7b:00:0b:fc:fe:1b:01:08:00 SRC=130.186.5.204 
> DST=10.253.0.11 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=22772 DF PROTO=TCP 
> SPT=54863 DPT=80 WINDOW=5840 RES=0x00 SYN URGP=0
>
>

"echo 6 > /proc/sys/net/netfilter/nf_conntrack_log_invalid" will make
conntrack log the reason for marking the packets as INVALID.
