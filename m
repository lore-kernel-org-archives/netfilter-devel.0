From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: NAT for IPv6
Date: Thu, 20 Nov 2003 19:01:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031120180148.GB2254@balabit.hu>
References: <3FBCCBA0.7020309@netlab.hut.fi> <Pine.LNX.4.44.0311201626560.12803-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Emmanuel Guiton <emmanuel@netlab.hut.fi>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311201626560.12803-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 20, 2003 at 04:43:05PM +0100, Henrik Nordstrom wrote:
> On Thu, 20 Nov 2003, Emmanuel Guiton wrote:
> Undoubtly similar abuses of the IPv6 protocol to do "amasing" things is
> likely to appear over time just as has had happened with IPv4 in the last
> decade, but it is pointless to start discussing breaking the protocol
> before investigating what solutions exists for solving the problem within
> the protocol. A lot of thought has been put into the IPv6 protocol to
> solve many of the problems experienced over the years with IPv4, and at
> the same time the transition from IPv4 to IPv6 also allows for a nice
> transition from old braindead applications to more capable applications.
> 
> So instead of focusing on IPv4 problems in a IPv6 packet level, take a
> step back and look at the problem as such and how it is best solved in
> IPv6. If this involves slight changes to applications to add behaviour not
> yet existing, no big deal as the applications need to be changed anyway.

You might be right in some circumstances, the problem is _existing_
applications are being ported to IPv6 which carry on their legacy problems.

I can't see the trend that introducing IPv6 would replace all protocols in
use today (POP3, IMAP, SMTP, etc.)

They will have their security implications just like in their IPv4
equivalent. 

And adding explicit proxying to the protocol will not give you end-to-end IP
either.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
