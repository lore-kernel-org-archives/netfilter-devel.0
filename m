From: Willy Tarreau <willy@w.ods.org>
Subject: Re: condition and 2.6
Date: Sun, 29 Feb 2004 15:05:21 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229140521.GA18370@alpha.home.local>
References: <200402290210.35962.lists@egidy.de> <20040229110711.GJ7790@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, gerd@egidy.de,
   netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040229110711.GJ7790@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Feb 29, 2004 at 12:07:11PM +0100, Harald Welte wrote:
 
> > What do you dislike? Is it the idea or the implementation? Do you know of any 
> > bugs or possible problems in the code - especially with 2.6?
> 
> The idea of having /proc files control how the ruleset behaves.  This is
> an ugly kludge for our less-than-optimal ruleset change performance.
> Apart from that I cannot really see why this has to be solved in the
> kernel and not by some userspace daemon that updates the ruleset
> whenever a change is needed.

I was planning to try to use condition in a HA environment to temporarily
disable some rules during a fail-over, or for maintenance operations (eg:
disable health-checks but let application traffic go through for soft-stop).
I think that condition offers much more atomicity than a ruleset update, and
there's no risk of multiple loads of the same rule.

Anyway, I agree that for permanent changes, an update of the ruleset should
be preferred.

Regards,
Willy
