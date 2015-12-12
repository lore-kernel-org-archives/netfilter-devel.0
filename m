From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sat, 12 Dec 2015 14:06:55 -0200
Message-ID: <566c4622.936d810a.ece67.ffffdfc9@mx.google.com>
References: <n4g4s8$4pr$1@ger.gmane.org>
	<566BEF33.7090501@gmail.com>
	<alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
	<566C09F5.6080606@gmail.com>
	<alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
	<566C0E75.6080800@familie-kuntze.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Remzi =?UTF-8?B?QUtZw5xa?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Noel Kuntze <noel@familie-kuntze.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35263 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbLLQHA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Dec 2015 11:07:00 -0500
In-Reply-To: <566C0E75.6080800@familie-kuntze.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 12 Dec 2015 13:09:25 +0100
Noel Kuntze <noel@familie-kuntze.de> wrote:

> - -m state has been deprecated for some time though.
> Please try using -m conntrack instead. It offers more
> functionality and is not considered deprecated.
> Translation of -m state to --m conntrack:
> - -m state --state foo,bar -> -m conntrack --ctstate foo,bar

	I tried this:

iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

	And I got the same error:

iptables: Protocol wrong type for socket.

	I'm afraid something has changed between 4.3.0 and 4.3.1 kernel
and some module isn't loading correctly. Here are the loaded modules:

xt_conntrack            3401  0 
x_tables               15108  7 xt_comment,ip_tables,xt_tcpudp,xt_conntrack,xt_LOG,iptable_filter,ipt_REJECT
nf_conntrack_ftp        6750  0 
nf_conntrack           56108  2 xt_conntrack,nf_conntrack_ftp

	Is there something missing?

-- 
Linux 4.3.2: Blurry Fish Butt
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
