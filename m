From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: Comments about IPT_ALIGN
Date: Sun, 26 Jan 2003 20:31:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030126203112.A9418@linux.karinthy.hu>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <3E33E96A.5080903@hipac.org> <20030126152650.B6811@linux.karinthy.hu> <3E3411CD.3050603@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anders Fugmann <afu@fugmann.dhs.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E3411CD.3050603@hipac.org>; from creatix@hipac.org on Sun, Jan 26, 2003 at 05:50:21PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Thomas!

On Sun, Jan 26, 2003 at 05:50:21PM +0100, Thomas Heinz wrote:
> > Yes, that's true, except for the fact that you will have to deal
> > with endianness as well, if you are interested in actually exchanging
> > data... 
> 
> The only match/target I'm aware of that has a pointer in its info
> struct is the limit match. Generally this is necessary for each

There's one in struct ipt_replace (indeed that's not a match/target),
for the counters.

> match/target that does not treat the info data as read only on a
> smp system (at least with the current infrastructure as each cpu has
> its own match/target info).
> 
> Anyway, I don't see a reason why one wants to exchange a valid pointer
> between user and kernel space.

I have seen at least two guys here who asked how to exchange arbitrary
amount of data. And a pointer is an easy way out...

> > And don't forget the size change that brings in on every 32-bit
> > platform effectively killing compatibility...
> 
> One could use #ifdef's for compatibility purpose but as I read you
> don't like these :-)

I could put up with that one :) But I doubt that we could get that "solution"
accepted into mainline releases...

Regards,
Laszlo

> 
> 
> Thomas
> 
