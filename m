From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: chain_cache
Date: Sun, 16 May 2004 14:15:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405161409220.30410-100000@filer.marasystems.com>
References: <40A4A9BB.4050706@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur Akan <akan@aiqa.com>
In-Reply-To: <40A4A9BB.4050706@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 14 May 2004, Ozgur Akan wrote:

> no one knows?

Very few people if any is looking at or caring about how libiptc operates.  
What we care about is how the iptables kernel operate and that libiptc
succeds in building correct tables to the kernel.

The official interface to the iptables kernel is the iptables and 
iptables-save/restore commands, with their official module interfaces for 
writing your own matches/target extensions, the rest is "woodo magics" and 
is best left alone.

libiptc is primarily maintained for the purpose of implementing the above
commands and module interfaces, and other uses of the libiptc library is 
mostly on your own responsibility. It is expected there will be multiple 
memory leaks, odd bugs and other ill effects lurking around there.


iptables does not have a chain_cache. This is purely an artefact of the
libiptc userspace implementation for compiling/modifying the iptables
table before it is sent to the kernel.

Regards
Henrik
