From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Thu, 18 Mar 2004 09:17:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403180910520.25678-100000@filer.marasystems.com>
References: <20040318013406.6848.qmail@web13911.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040318013406.6848.qmail@web13911.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 17 Mar 2004, Scott MacKay wrote:

> valgrind --leak-check=yes iptables -A PREROUTING -t
> mangle -s 192.168.1.0/24 -j DROP
> 
> and got a few...I would be cautious about using these
> routines in a long-running app unless they were looked
> at more.

libiptc is not really intended for long-running applications. The only
official use of this is iptables and iptables-restore which usually does
not run for a long time, so there has not been very much attention to
memory leaks etc.. but bugfixes are usually accepted when found.

Note that the design of libiptc will indicate some static memory leaks due
to modules being loaded etc unless you compile it as a single binary.  
These leaks are not interesting to have fixed. The type of leaks
interesting to have fixed is the leaks which grows over time as more and
more operations have been executed.

Regards
Henrik
