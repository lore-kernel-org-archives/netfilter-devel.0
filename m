From: Eric Leblond <eric@regit.org>
Subject: Re: ULOG Packet Count
Date: Mon, 03 Feb 2014 23:05:10 +0100
Message-ID: <1391465110.19856.14.camel@ice-age2.regit.org>
References: <CACHQFzFTDJ-zj9wx+my4Oy9sQ=nZg4mG=FX8JC7kHm-3n-Z-Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Sassy Natan <sassyn@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:55161 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbaBCWFS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:05:18 -0500
In-Reply-To: <CACHQFzFTDJ-zj9wx+my4Oy9sQ=nZg4mG=FX8JC7kHm-3n-Z-Bw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2014-02-03 at 23:40 +0200, Sassy Natan wrote:
> Hi All,
> 
> 
> I being trying to understand how to get ulog2 to capture my network
> traffic in terms of accounting.
> 
> I have setup my ubuntu to work with ulog2 and MySQL, and manage to get
> the tables fill up with data.
> 
> Howerver, I didn't manage to understand how to get the packet length
> so I could calculate the amount of data generated for the specific
> service.
> 
> In ulogd.conf I configure the following:
> 
> stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mac2str1:HWHDR,mysql1:MYSQL
> stack=ct1:NFCT,ip2bin1:IP2BIN,mysql2:MYSQL
> 
> 
> Tables ulog2 and ulog2_ct are being populated with the data.
> In ulog2_ct I can see a column name orig_bytes and orig_packets but
> both of them are always 0.

You need to enable accounting in conntrack:

echo "1">/proc/sys/net/netfilter/nf_conntrack_acct

> I google for this and found this
> http://mohskitchen.wordpress.com/2012/08/27/accounting-with-ulogd-2-and-conntrack-on-a-gbit-nat/
> 
> I'm also aware of nfacct, but haven't find a way to make it work with MySQL.

Yes, MySQL schema has not been adapted to store these informations.

Sassy, are you able to do it based on PostgreSQL one ? Commit
implementing this is d9377e7ba22ec13a0c73785f86e5bcc869d1051f

BR,
-- 
Eric Leblond <eric@regit.org>

