From: Juha Heljoranta <juha.heljoranta@evtek.fi>
Subject: Re: Status of owner-socketlookup
Date: Wed, 27 Apr 2005 17:40:10 +0300
Message-ID: <426FA44A.2010008@evtek.fi>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>
	<426F64C8.1070601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <426F64C8.1070601@trash.net>
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

Patrick McHardy wrote:
> I still need to convert parts of iptables to handle the new argument,
> I'll post a patch in a few days. Unfortunately, this doesn't solve
> the other problems of the owner match, for properly working pid and
> command matching we need at least the pid of the sending process to
> look it up. Any ideas for solving this are welcome.

I am working on the other issues you mentioned. Or at least doing some
research.

To authenticate _receiving_ process reliably I created a socket usage
surveillance module. It keeps track of the processes that access PF_INET
sockets. If the accessing process is not already in the surveillance
list then the absolute path and stat(2) of the process image is stored.
plus some other relevant information like pid.

When a packet is received the socket is located by using
tcp/udp_v4_lookup functions. After the socket is found the modified
version of sock_def_readable is used to get information about the
receiving tasks that are stored into surveillance module. After this I
just compare data to e.g. ipt_owner_info. Works great!

Ideas how to identify sending process are indeed needed. How about
adding sender information (pid) into skb?

I am working on thesis about process network access control in Linux. I
will make announcement (hopefully) within a week.

Regards,
Juha Heljoranta
