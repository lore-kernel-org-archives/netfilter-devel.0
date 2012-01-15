From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Sun, 15 Jan 2012 17:16:51 +0000
Message-ID: <4F130A03.7080208@googlemail.com>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52301 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2AORRC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jan 2012 12:17:02 -0500
In-Reply-To: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Kernel part changes:
>  - hash:net,iface timeout bug fixed
>  - Exceptions support added to hash:*net* types
>   
Any chance of fixing this bug soon:

~# ipset n test hash:net family inet timeout 0
~# ipset a test 10.1.0.0/16
~# ipset t test 10.1.12.12
10.1.12.12 is in set test.
~# ipset t test 10.1.12.0/24
10.1.12.0/24 is NOT in test.

