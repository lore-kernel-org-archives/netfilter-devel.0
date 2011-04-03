From: Brian G <unixman83@gmail.com>
Subject: Writing a mangle TARGET for iptables, questions about fragments,
 checksums
Date: Sat, 02 Apr 2011 23:47:20 -0500
Message-ID: <4D97FBD8.9050907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1DCEra (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Apr 2011 00:47:30 -0400
Received: by iyb14 with SMTP id 14so4871852iyb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Apr 2011 21:47:29 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I want to modify a packet in the TCP mangle PREROUTING table.

First question: Fragments, does the kernel reassemble them BEFORE this 
point?
Second question: Checksums, do I need to update the checksum?

Is there example code that I could work with?

- Brian
