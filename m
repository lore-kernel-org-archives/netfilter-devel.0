From: hoangtam <tamnghoang@gmail.com>
Subject: nf_ip_local_out and internet connection
Date: Sat, 29 Oct 2011 22:32:32 +0200
Message-ID: <4EAC62E0.2000106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45518 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1J2Ucl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Oct 2011 16:32:41 -0400
Received: by wwe6 with SMTP id 6so7289437wwe.1
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2011 13:32:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
I write a netfilter module using NF_IP_LOCAL_OUT to change something in 
packet. Everything is perfect when I test it by using iperf and wget but 
if I open a website,the website can load some text and then PC stop 
running. Any comment is appreciated !!!
