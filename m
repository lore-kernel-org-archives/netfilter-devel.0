From: Dan Kegel <dank@kegel.com>
Subject: Building on case-insensitive filesystems
Date: Sat, 16 Oct 2004 12:35:43 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4171780F.1070909@kegel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

$ ls {include/linux/netfilter_ipv4,net/ipv4/netfilter}/*.{h,c}
shows eight pairs of files whose names differ only in case.
For example:
$ more include/linux/netfilter_ipv4/ipt_{mark,MARK}.h
::::::::::::::
include/linux/netfilter_ipv4/ipt_mark.h
::::::::::::::
#ifndef _IPT_MARK_H
#define _IPT_MARK_H

struct ipt_mark_info {
     unsigned long mark, mask;
     u_int8_t invert;
};

#endif /*_IPT_MARK_H*/

::::::::::::::
include/linux/netfilter_ipv4/ipt_MARK.h
::::::::::::::
#ifndef _IPT_MARK_H_target
#define _IPT_MARK_H_target

struct ipt_mark_target_info {
         unsigned long mark;
};

#endif /*_IPT_MARK_H_target*/

Seems like ipt_mark_target.h might be a better name for
that latter file.  That would let developers who have
MacOSX or Windows laptops successfully unpack the
Linux source tree on their computers' case-insensitive filesystems.

I maintain http://kegel.com/crosstool, which is a script
that builds arbitrary combinations of gcc + {g,uc}libc + binutils + linux headers + target.
As a check on the resulting cross toolchains, I try building
a Linux kernel.  This works great in general, but on
operating systems with case-insensitive filesystems
(MacOSX, Cygwin), building the linux kernel understandably fails on these files.

Here's the patch I've been using to do a rename and fix Makefiles to match:
   http://www.kegel.com/crosstool/linux-2.6.8-netfilter-case-insensitive.patch
It renames the uppercase variants to add a _u suffix, but I would
gladly rework the patch to use a nicer suffix (like _target) if
that would help make the rename happen.

This is part of a larger effort to make life easier for
embedded Linux developers who are stuck developing on Windows
or Mac systems; see discussion at
http://marc.theaimsgroup.com/?l=linux-kernel&m=109713211417106&w=2
(Summary: Sam Ravnborg is helping; Russel King is skeptical.)
- Dan

-- 
Trying to get a job as a c++ developer?  See http://kegel.com/academy/getting-hired.html
