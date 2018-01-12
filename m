From: Jean Weisbuch <jean@phpnet.org>
Subject: [ulog2] Plugin ulogd_filter_HTTPSNIFF proposal
Date: Fri, 12 Jan 2018 18:21:04 +0100
Message-ID: <4c9caef6-810c-c656-b065-9f321a5d43a1@phpnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-sortant1.phpnet.org ([195.144.11.45]:58536 "EHLO
        smtp-sortant1.phpnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934109AbeALR3G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 12:29:06 -0500
Received: from vercors.phpnet.org (vercors.phpnet.org [46.255.160.222])
        by smtp-sortant1.phpnet.org (Postfix) with ESMTPS id 3zJ8fX22WCzJ67dD
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2018 18:21:07 +0100 (CET)
Received: from mailfilter2.phpnet.org (mailfilter2.phpnet.org [195.144.11.141])
        by vercors.phpnet.org (Postfix) with SMTP id 9B1F86B60117
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jan 2018 18:21:04 +0100 (CET)
Received: from rt-bur1.phpnet.org ([195.144.11.241] helo=[192.168.1.145])
        by smtp.phpnet.org with esmtpa (Exim 4.80)
        (envelope-from <jean@phpnet.org>)
        id 1ea30q-00047i-EE
        for netfilter-devel@vger.kernel.org; Fri, 12 Jan 2018 18:21:04 +0100
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I created a filter plugin for ulogd2 that does retrieve informations 
from HTTP request, it is similar to ulogd_filter_PWSNIFF (on which the 
code is based) which allows to monitor/log HTTP requests sent/recieved 
by the system.
Other solutions based on PCAP allows to log HTTP queries but not along 
with informations such as the UID that did sent the packet which can be 
useful to which users are executing virus/hacked scripts.

Output of "ulogd --info ulogd_filter_HTTPSNIFF.so" :
     Input keys:
         Key: raw.pkt (raw data)
     Output keys:
         Key: httpsniff.host (string)
         Key: httpsniff.uri (string)
         Key: httpsniff.method (unsigned int 8)


The code is available at : https://github.com/jb-boin/ulogd_filter_HTTPSNIFF

It requires both https://bugzilla.netfilter.org/show_bug.cgi?id=1192 and 
https://bugzilla.netfilter.org/show_bug.cgi?id=1193 to be fixed for it 
to work correctly.
I included proposed patchs for those two bugs.


I have been using it with a MariaDB output for about 3 months on more 
than 30 Debian Jessie hosts, ulogd2 compiled as packages using the 
Debian Stretch 2.0.5-5 source package and i didnt hit any issue so far.
