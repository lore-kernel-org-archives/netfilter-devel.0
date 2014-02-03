From: Sassy Natan <sassyn@gmail.com>
Subject: ULOG Packet Count
Date: Mon, 3 Feb 2014 23:40:12 +0200
Message-ID: <CACHQFzFTDJ-zj9wx+my4Oy9sQ=nZg4mG=FX8JC7kHm-3n-Z-Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Eric Leblond <eric@regit.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34566 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaBCVkd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:40:33 -0500
Received: by mail-qc0-f180.google.com with SMTP id i17so12134022qcy.39
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Feb 2014 13:40:32 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,


I being trying to understand how to get ulog2 to capture my network
traffic in terms of accounting.

I have setup my ubuntu to work with ulog2 and MySQL, and manage to get
the tables fill up with data.

Howerver, I didn't manage to understand how to get the packet length
so I could calculate the amount of data generated for the specific
service.

In ulogd.conf I configure the following:

stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:HWHDR,mysql1:MYSQL
stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL


Tables ulog2 and ulog2_ct are being populated with the data.
In ulog2_ct I can see a column name orig_bytes and orig_packets but
both of them are always 0.

I google for this and found this
http://mohskitchen.wordpress.com/2012/08/27/accounting-with-ulogd-2-and-conntrack-on-a-gbit-nat/

I'm also aware of nfacct, but haven't find a way to make it work with MySQL.


Any idea?
Thank u



-- 
Regards,

Sassy Natan
972-(05)54-2203702
