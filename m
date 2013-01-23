From: Jonathan <jdccdevel@gmail.com>
Subject: Add packet statistics to ipset?
Date: Wed, 23 Jan 2013 11:19:56 -0700
Message-ID: <510029CC.5000902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54473 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab3AWSQ3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 13:16:29 -0500
Received: by mail-pb0-f42.google.com with SMTP id rp2so4842881pbb.15
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jan 2013 10:16:28 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello:

How difficult would it be to add packet/byte counters to ipset?

I have a iptables ruleset that I'm looking to simplify, and I would like 
to use the ipset module. However, I also have a need to collect per-host 
byte counters. Currently I scrape them from the iptables output, but 
with ipset this is not possible afaik. This makes the ipset module 
(which I would _really_ like to use) useless for me.

I am not familiar with kernel programming, but I do know C. If it's not 
too difficult, I would be very interested in helping with implementing 
this, or even implementing it myself with some help.

Other options I have considered are adding some sort of ip-bitmap or 
hash support to the nfacct system, or an aggregation filter module for 
ulogd. From what I can tell, adding bitmaps/hashes to the nfacct system 
would be much more complicated, and adding an aggregation filter to 
ulogd would be far less efficient.

What do you think?

Jonathan deBoer




