From: Ross Vandegrift <ross@kallisti.us>
Subject: Re: Netlink error datagrams
Date: Tue, 10 Apr 2007 14:19:40 -0400
Message-ID: <20070410181938.GA25617@kallisti.us>
References: <20070410040840.GA23429@kallisti.us> <461B4350.3000102@trash.net>
	<20070410162545.GA25386@kallisti.us> <461BC03A.7010501@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <461BC03A.7010501@trash.net>
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

On Tue, Apr 10, 2007 at 06:50:02PM +0200, Patrick McHardy wrote:
> Ross Vandegrift wrote:
> An error contains a struct nlmsghdr followed by a struct nlmsgerr
> followed by the message that caused the error.
> 
> > (gdb) hexdump buf
> > BFFE0E80 : 24 00 00 00  02 00 00 00 - 00 00 00 00  4A 37 00 00 $...........J7..
> 
> ^^ nlmsghdr
> 
> > BFFE0E90 : FE FF FF FF  1C 00 00 00 - 12 00 01 00  00 00 00 00 ................
> 
> nlmsgerr:    ^^ error     ^^ original msg
> 
> > BFFE0EA0 : 4A 37 00 00  65 74 68 30 - 00 00 00 00  00 00 00 00 J7..eth0........

Aha!  Now I get it - thanks a ton!

> 
> 
> So the error is 0xFEFFFFFF, which (assuming your machine is big-endian)
> is -2 or -ENOENT. The only case where this can happen is if you send
> a verdict for a non-existant queue entry.
> 

-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
