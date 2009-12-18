From: Zdenek Vasicek <vzdenek@seznam.cz>
Subject: [Fwd: Re: libnetfilter_conntrack]
Date: Fri, 18 Dec 2009 10:29:07 +0100
Message-ID: <4B2B4B63.20509@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kazi.fit.vutbr.cz ([147.229.8.12]:58808 "EHLO kazi.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbZLRJh1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:37:27 -0500
Received: from [147.229.13.122] (pcvasicek.fit.vutbr.cz [147.229.13.122])
	(user=vasicek mech=PLAIN bits=0)
	by kazi.fit.vutbr.cz (envelope-from vzdenek@seznam.cz) (8.14.3/8.14.3) with ESMTP id nBI9T6Rl085182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2009 10:29:12 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear authors,
I would like to ask you about help. I have installed latest version of 
the libnetfilter_conntrack (libnetfilter_conntrack-0.0.100, 
libnfnetlink-1.0.0) and I have found that the src and dest address 
(ipv4) as well as src and dest port are always empty (zero). However, if 
I look into /proc/net/nf_conntrack, everything is ok. The kernel version 
is 2.6.32.

Example:
  libnetfilter_conntrack-0.0.100/utils/conntrack_dump
  ipv4     2 tcp      6 431999 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 
packets=13087 bytes=851624 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 
packets=14940 bytes=8636188 [ASSURED] mark=0 use=2

  /proc/net/nf_conntrack
  ipv4     2 tcp      6 431999 ESTABLISHED src=147.229.13.xx 
dst=147.229.14.xx sport=40868 dport=22 packets=13236 bytes=861344 
src=147.229.14.xx dst=147.229.....

Can you please help me to solve this bug? I didn't have any problems 
with conntrack and ulog before. I suppose that there must to be 
incompatibility between kernel and libnetfilter.

Best regards,
Zdenek Vasicek

>pleaes contact netfilter-devel@vger.kernel.org
>-- 
>- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
>============================================================================
>"Privacy in residential applications is a desirable marketing option."

