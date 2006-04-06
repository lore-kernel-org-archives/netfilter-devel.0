From: Patrick McHardy <kaber@trash.net>
Subject: Re: The future of patch-o-matic-ng
Date: Thu, 06 Apr 2006 10:22:23 +0200
Message-ID: <4434CFBF.7030208@trash.net>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>	<20060405152628.GI20558@sunbeam.de.gnumonks.org>	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>
	<20060406073514.GE6887@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060406073514.GE6887@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> As indicated in Patricks mail, there's a 30 day grace period.  Until
> then the original authors (if they care) or other people can take
> maintenance for individual patchlets and send us URL's to those
> repositories.  We will add them to our list file, and distribute a
> 'runme' script which downloads those repositories off the net.
> 
> If you want to help, I suggest to wait for those patchlets that nobody
> takes care of, and run a repository for them.

As a side-note: anyone who decides to take maintanance for some
patchlet, please drop me a short note, so I can keep a list
of unmaintained patches.

> Also, I assume that there is a lot that can be done to improve that
> patchlet-handling script, i.e. add suport for GPG signature checking and
> the like.  I suggest you coordinate with Patrick on this.

Definitely. The code is very basic, it only makes sure a patchlet
1) doesn't overwrite anything outside of its patchlet directory
2) can only overwrite "Repository: external" patchlets

But doensn't do any signature verification. I'll add it today,
patches are welcome.
