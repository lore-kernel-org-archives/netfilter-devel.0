From: Phil Oester <kernel@linuxace.com>
Subject: Re: TCP window tracking has bad side effects
Date: Wed, 1 Dec 2004 16:54:54 -0800
Message-ID: <20041202005454.GA14803@linuxace.com>
References: <20041201110253.GA9536@suse.de>
	<Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Dec 01, 2004 at 01:16:31PM +0100, Jozsef Kadlecsik wrote:
> Yes, you can disable it anytime:
> 
> echo 1 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_be_liberal
> 
> But a full tcpdump from such a session and the log entries on the
> invalid packets would be useful for us to recheck the code.

This sounds remarkably similar to bugzilla #258, where a TCP
session which works in 2.6.8.1 fails in 2.6.9:

https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=258

Attached to the report is a binary tcpdump.  I've replayed it
and tried a few things but can't figure out what the problem
is.

Disabling window tracking did nothing -- were there any other
interesting changes in 2.6.9 series?

Phil
