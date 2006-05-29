From: Holger Eitzenberger <holger@my-eitzenberger.de>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Mon, 29 May 2006 11:30:18 +0200
Message-ID: <20060529093018.GA20260@kruemel.my-eitzenberger.de>
References: <447A1FB7.5080709@netfilter.org> <447A32FF.9060404@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <447A32FF.9060404@trash.net>
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

On Mon, May 29, 2006 at 01:32:15AM +0200, Patrick McHardy wrote:

> > I've been working on a pet project during the last months. Part of this
> > stuff is related with my works in the university.
> > 
> > The project is called `conntrackd' that is the conntrack userspace daemon.

> Interesting work (and nice featureset), I like the idea of doing this
> in userspace. IIRC Holger Eitzenberger is also working on something
> similar. Do you have performance measurements how this compares to
> ct_sync?

Hi Pablo, Patrick,

yes, for me it started as a proof-of-concept and matured in an almost
feature complete version I will release soon.  It's called ctsyncd.

Pablo, I will check your code, at a first glance your solution has a
richer feature set than my solution.  Mabe we should join our efforts.

Regards.  /holger
