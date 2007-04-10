From: Ross Vandegrift <ross@kallisti.us>
Subject: Re: Netlink error datagrams
Date: Tue, 10 Apr 2007 12:25:45 -0400
Message-ID: <20070410162545.GA25386@kallisti.us>
References: <20070410040840.GA23429@kallisti.us> <461B4350.3000102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Ross Vandegrift <ross@eris.kallisti.us>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <461B4350.3000102@trash.net>
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

On Tue, Apr 10, 2007 at 09:57:04AM +0200, Patrick McHardy wrote:
> Ross Vandegrift wrote:
> > I have a libipq application that I'm using with netfilter.  I have the
> > following fragment of code, mostly from the FAQ:
> > 
> >       status = ipq_read(h, buf, BUFSIZE, 0);
> >       if (status < 0)
> > 	rr_err ("%s", ipq_errstr ());
> >       
> >       switch (ipq_message_type(buf))
> > 	{
> > 	case IPQM_PACKET:
> >           /* Do stuff with the packet */
> >           break;
> > 
> > 	case NLMSG_ERROR:
> >           ipq_perror ("rrfilter");
> > [snip, hitting error case]
> 
> 
> What error code does the header contain?

Reading through libipq source, ipq_read seems to hand me a (struct nlmsghdr *),
so I've been treating it like so.  I'm kind of a newbie at netlink as
well as netfilter, and I don't really see an error code field in
struct nlmsgdr.  I'm guessing it's in the ancillary data field, but
I'm not sure how to interpret the data:

(gdb) hexdump buf
BFFE0E80 : 24 00 00 00  02 00 00 00 - 00 00 00 00  4A 37 00 00 $...........J7..
BFFE0E90 : FE FF FF FF  1C 00 00 00 - 12 00 01 00  00 00 00 00 ................
BFFE0EA0 : 4A 37 00 00  65 74 68 30 - 00 00 00 00  00 00 00 00 J7..eth0........


I've been going off of http://people.redhat.com/nhorman/papers/netlink.pdf,
which seems to match up with my <linux/netlink.h>.  Sorry for the
newbieish questions - if there's a different doc, feel free to point me
there.

Thanks again,

Ross

-- 
Ross Vandegrift
ross@kallisti.us

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
