From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: what's the lockingrules for ip_conntrack_expect_list?
Date: 12 Oct 2002 15:20:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034428800.7609.43.camel@tux>
References: <1034286048.25146.40.camel@tux>
	<Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
	<20021012141737.X13233@sunbeam.de.gnumonks.org>
	<1034428150.7595.36.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <1034428150.7595.36.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2002-10-12 at 15:09, Martin Josefsson wrote:
  
> > > > ip_conntrack_expect_related
> > > > 	WRITE_LOCK(&ip_conntrack_lock);
> > > > 	LIST_FIND
> > > > 	LIST_FIND
> > > > 	list_prepend
> > 
> > This is clearly a bug, but works according to the optimization described 
> > above.  I think we should either grab the tuple_lock or at least make 
> > a verbose comment in the code describing why we don't grab it.
> 
> I'll add a read-lock on the tuple_lock here just to mark that it should
> be taken.

Oops, spoke too soon, there already exists such a comment:

         /* Because of the write lock, no reader can walk the lists,
          * so there is no need to use the tuple lock too */

I'll leave it at that.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
