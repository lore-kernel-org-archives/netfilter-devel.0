From: Filip Sneppe <filip.sneppe@cronos.be>
Subject: Re: trouble with expect_related
Date: 14 Jan 2003 15:19:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1042553961.465.290.camel@xbox>
References: <t2mk7hlwz5c.fsf@rw2-laptop.wellner.org>
	<1041651291.1637.41.camel@exile> <t2mwulie0cu.fsf@rw2-laptop.wellner.org>
	<1041933003.502.23.camel@xbox>  <t2mk7hhx86x.fsf@rw2-laptop.wellner.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rich Wellner <rkw@objenv.com>
In-Reply-To: <t2mk7hhx86x.fsf@rw2-laptop.wellner.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Rich,

I am just cc-ing this excerpt of our private mail exchange
about this problem to netfilter-devel again so it
gets archived for future developers to benefit from.

The reason for the trouble with ip_conntrack_expect_related
is that NAT setups require a ip_xxx_nat.c module.

Regards & good luck,
Filip

On Tue, 2003-01-07 at 21:41, Rich Wellner wrote:
> Filip Sneppe <filip.sneppe@cronos.be> writes:
> >
> > Is it possible for you to test things without NAT ? Might be
difficult if
> > you're doing this on a home MASQUERADING box with Internet
connectivity.
> >
> > If not, you're going to have to show more code, namely what you're
doing in
> > ip_xxx_nat.c.
> 
> Ugh, this is a train wreck.  I didn't understand that I needed both a
> ip_conntrack_dcap module and a ip_nat_dcap.c module.
> 
> I'll have to adapt one from the IRC I guess.
> 
> Thanks for the help.
> 
> rw2
