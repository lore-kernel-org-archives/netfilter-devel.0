From: Michael Kopreski <michaelkopreski@gmail.com>
Subject: Using libiptc to programmatically modify iptables rules
Date: Fri, 27 Sep 2013 01:31:13 -0400
Message-ID: <CAG0djwzdncvtTn_4kTTX0Yj+rvaGU4FDVWeVHnXGeeWSEgUGhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f42.google.com ([209.85.212.42]:36307 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3I0FbO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:31:14 -0400
Received: by mail-vb0-f42.google.com with SMTP id e12so1517362vbg.15
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2013 22:31:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am attempting to use libiptc to retrieve and replace rules written to
iptables.  I have been using iptc_replace_entry() to substitute the
existing rule with one that I have generated, but with little success.
The function exits with a "Invalid argument" error, so I think that the
problem may lie with the ipt_entry struct that I am attempting to
create.  I only need a very basic rule that defines a target (in the
present case, RETURN); otherwise the rule can be empty.

So far, I have been creating an ipt_entry struct and appending an
ipt_entry_target.  I have tried writing the target struct to (&ipt_entry +
sizeof(struct ipt_entry) ) as well as to the elems member
of ipt_entry (which I believe should be the same place, given that there
are no matches or other data appended, yes?).  I also set the
target_size, target_offset, and next_offset (XT_ALIGN'ed) values, as
well as the u.user.name string (of course, in truth only the last is
directly significant to my purposes).  I have been doing some rooting
around in the iptables code to try to familiarize myself with what is
going on, but I feel I must be missing something.

I was hoping to gain some more insight into the way the ipt_entry data
is structured, and perhaps even a 'recipe' of sorts to create my simple
rule.  Is the problem a padding/size issue, or am I not setting the
proper values for the target? (It seems in the target struct in the
existing ipt rules does not have the u.user.name set, despite having a
RETURN target; perhaps I should be setting a pointer for the kernel
instead?)  Any help would be greatly appreciated.


Thanks in advance,

Michael Kopreski
