From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: updated ctnetlink
Date: 22 May 2003 16:03:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1053612216.15181.66.camel@tux.rsn.bth.se>
References: <20030522124450.GA30151@balabit.hu>
	 <1053610279.15180.64.camel@tux.rsn.bth.se>
	 <20030522135943.GA31399@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20030522135943.GA31399@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2003-05-22 at 15:59, Balazs Scheidler wrote:

> > The version in p-o-m is working fine here on 2.4.21-rc1
> > (with a few fixes so userspace can't crash the kernel so easily
> > http://kashyyyk.netfilter.org/~gandalf/patches/nfnetlink_conntrack-fix.diff
> > one hunk of it has been integrated into p-o-m)
> 
> hm it is in the oldnat/ section of the p-o-m, it was the reason I thought it
> was obsoleted.

That one is :)

But extra/nfnetlink-ctnetlink-0.11.patch isn't

-- 
/Martin
