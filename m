From: Stig Thormodsrud <stig@ubnt.com>
Subject: ipset save issue
Date: Thu, 18 Sep 2014 16:04:19 -0700
Message-ID: <CAL-yc8-6miUn_dg=cDtUzsJC_XKtTnt78xdcnXtH0AnbuJ-nmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:54781 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbaIRXEU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:04:20 -0400
Received: by mail-ie0-f179.google.com with SMTP id rl12so2258788iec.24
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 16:04:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I know the max group name length is 32 characters, but I'm running
into a problem with "save" if the group name is 29 characters.  For
example:

ubnt@ERL:~$ sudo ipset create  A234567890123456789 bitmap:port range 1-65535
ubnt@ERL:~$ sudo ipset add  A234567890123456789 4512-65535
ubnt@ERL:~$ sudo ipset save  A234567890123456789 > file
ipset v6.21.1: Internal error at printing to output buffer
ubnt@ERL:~$

But if I change it to 28 characters it works:

ubnt@ERL:~$ sudo ipset create  A23456789012345678 bitmap:port range 1-65535
ubnt@ERL:~$ sudo ipset add A23456789012345678 4512-65535
ubnt@ERL:~$ sudo ipset save A23456789012345678 > file
ubnt@ERL:~$
ubnt@ERL:~$ sudo ipset -V
ipset v6.21.1, protocol version: 6


Ideas?
