From: Phil Oester <kernel@linuxace.com>
Subject: Re: iptables 1.3.6 not using /etc/networks
Date: Mon, 13 Nov 2006 09:12:36 -0800
Message-ID: <20061113171236.GA10032@linuxace.com>
References: <cd6061db0611111725q2822d96cg2272b44dc3e85d0b@mail.gmail.com>
	<cd6061db0611111835u7d6ea889g56822e458e3e12f2@mail.gmail.com>
	<20061112173312.GA2593@linuxace.com>
	<Pine.NEB.4.64.0611121933050.20892@ukato.freeshell.org>
	<20061112194314.GA3542@linuxace.com>
	<Pine.NEB.4.64.0611130053020.6631@ukato.freeshell.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Laurence J. Lane" <ljlane@debian.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexey Toptygin <alexeyt@freeshell.org>
Content-Disposition: inline
In-Reply-To: <Pine.NEB.4.64.0611130053020.6631@ukato.freeshell.org>
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

On Mon, Nov 13, 2006 at 12:58:48AM +0000, Alexey Toptygin wrote:
> >But if you use a FQDN such as www.domain.com/24, then shouldn't that
> >then imply <ip of www.domain.com>/24?  That's why I didn't make the
> >exception for letters vs. digits, as it could be used either way.
> 
> I don't understand what you mean. I think if it starts with a digit, it 
> must be an IP (or part of an IP with 0's dropped), else it is a network 
> name or a domain name (since neither of those can start with digits). If 
> it's an IP by the above logic, then pad it with '.0's as necessary (or 
> translate directly into a number without padding first). If it's not an 
> IP, first call getnetbyname on it and if that returns NULL call 
> gethostbyname. I think this algorithm works in all cases, unless I'm 
> missing something.

What I meant was some people might want to include the /24 a host sits
on, and use something like "mydomain.com/24".  When the name gets
translated to 1.2.3.4, the cidr would make it 1.2.3.0/24.

Also, as Martijn points out, just starting with digit doesn't imply
an IP, as hosts can start with digits also.

The difficulty here is we can't easily have /etc/networks be processed
and have shorthand CIDR notation (such as 10.10.10/24) work.

Phil
