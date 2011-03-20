From: Mark Montague <mark@catseye.org>
Subject: questions about variable-sized data in match rules
Date: Sun, 20 Mar 2011 00:03:18 -0400
Message-ID: <4D857C86.1010009@catseye.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48443 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab1CTELY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Mar 2011 00:11:24 -0400
Received: from compute1.internal (compute1.nyi.mail.srv.osa [10.202.2.41])
	by gateway1.messagingengine.com (Postfix) with ESMTP id 21FD022097
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Mar 2011 00:03:19 -0400 (EDT)
Received: from hitomi.local (unknown [198.111.179.55])
	by mail.messagingengine.com (Postfix) with ESMTPSA id CBCEC407EFE
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Mar 2011 00:03:18 -0400 (EDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  I'm writing a netfilter match extension (kernel 2.6.35.11) that has 
arguments of indeterminate length.  There are six possible arguments, 
each of which is a string with no pre-set maximum length.  Typically, a 
match rule would only specify one or two of these arguments, although it 
is theoretically possible to have a rule with all six.  Each argument 
can only occur once and is typically 30-50 characters, although it is 
possible to have arguments that are 100 characters or more each (there 
is no pre-set maximum length).  Here is an example that uses only two of 
the six possible arguments:

iptables -A INPUT -m mymatch --arg1 some-long-string --arg5 
another-even-longer-string -j ACCEPT


It seems to me that allocating memory via malloc() in the parse hook 
function, including a pointer for each argument in the match info 
structure, and using copy_from_user() in the checkentry hook function 
would be bad, since the match info structure is copied to kernel space 
across a netlink socket and the checkentry hook function may run after 
the userspace process has terminated.  Is this conclusion correct?

The best solution I have come up with so far is to have a pool for all 
arguments, with indexes into the pool for each argument:

struct mymatch_mtinfo {
         char  pool[256]; /* strings in pool are separated by '\0' */
         __u8 arg1_pool_offset; /* index into pool for argument 1 */
         __u8 arg2_pool_offset;
         __u8 arg3_pool_offset;
         __u8 arg4_pool_offset;
         __u8 arg5_pool_offset;
         __u8 arg6_pool_offset;
}

This would work in all but pathological cases, since a rule will 
normally only have one or two arguments each of which should be well 
below 100 characters.  If the total number of characters across all 
arguments is more than 255, the parse hook function would throw an error 
and say that although everything is be legal, together it is all more 
than the netfilter extension can handle.

Can anyone think of a better solution for passing six strings with no 
pre-set lengths to the kernel netfilter extension module?

Thanks in advance for any advice.

--
   Mark Montague
   mark@catseye.org

