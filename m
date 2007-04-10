From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netlink error datagrams
Date: Tue, 10 Apr 2007 18:50:02 +0200
Message-ID: <461BC03A.7010501@trash.net>
References: <20070410040840.GA23429@kallisti.us> <461B4350.3000102@trash.net>
	<20070410162545.GA25386@kallisti.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Ross Vandegrift <ross@kallisti.us>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070410162545.GA25386@kallisti.us>
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

Ross Vandegrift wrote:
> On Tue, Apr 10, 2007 at 09:57:04AM +0200, Patrick McHardy wrote:
> 
>>What error code does the header contain?
> 
> 
> Reading through libipq source, ipq_read seems to hand me a (struct nlmsghdr *),
> so I've been treating it like so.  I'm kind of a newbie at netlink as
> well as netfilter, and I don't really see an error code field in
> struct nlmsgdr.  I'm guessing it's in the ancillary data field, but
> I'm not sure how to interpret the data:


An error contains a struct nlmsghdr followed by a struct nlmsgerr
followed by the message that caused the error.

> (gdb) hexdump buf
> BFFE0E80 : 24 00 00 00  02 00 00 00 - 00 00 00 00  4A 37 00 00 $...........J7..

^^ nlmsghdr

> BFFE0E90 : FE FF FF FF  1C 00 00 00 - 12 00 01 00  00 00 00 00 ................

nlmsgerr:    ^^ error     ^^ original msg

> BFFE0EA0 : 4A 37 00 00  65 74 68 30 - 00 00 00 00  00 00 00 00 J7..eth0........


So the error is 0xFEFFFFFF, which (assuming your machine is big-endian)
is -2 or -ENOENT. The only case where this can happen is if you send
a verdict for a non-existant queue entry.
