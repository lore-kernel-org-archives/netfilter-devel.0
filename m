From: Biermann-Roemke@t-online.de (=?ISO-8859-1?Q?Karsten_R=F6mke?=)
Subject: libiptc - frustrating
Date: Thu, 02 Oct 2003 17:49:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F7C4919.8060800@hhb.bonn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

A long time ago (means 12 month or something like this)
I wrote c++-Classes around some functionality of libiptc and
iptables. Used iptables-1.2.6a.
Now, I'm changing my linux version and they actually use 1.2.7a,
maybe patched, it's a suse 8.2.

Hmm, same program works on old-Version and leads to a segmentation
fault in the new version. (Kernel differs too).

I remember that I need some time to analyse iptables and the calls
to libiptc and I think I understand it half (maybe).
My needs are only the insertion / deletion of  redirection-rules, if the 
source
of the packet was a specified IP. Furthermore I create a new chain out
of my program.

OK, cause it was some work I now thought:
"look for examples in the archive" and I found:

 >We said it before and we say it again. libiptc was never intended to 
be used
 >by anything else but iptables.c self. Its not an "open" API to be used by
 >any C-program. It might be and will be changed without any notice possible
 >making your c-program not working anymore.

Uuups - horrible for me :-)

Question: how can I insert a rule from a running daemon in the fastest way:
1) calling a system("iptables ..."), don't know if the syntas is correct
2) doing the work again of analyzing the source code again
3) linking iptables.o to my application. I remember, that I've not done that
    because iptables never frees any memory - only allocates - not 
useful for a
    long time running program.
    If I'm not right with this, excuse me, I just have something in mind 
like this :-)

Thank you

	Karsten
