From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] ipt_MARK extension with backwards
	compatibility	(kernel side).
Date: Wed, 08 Dec 2004 16:44:45 +1100
Message-ID: <1102484685.20129.41.camel@localhost.localdomain>
References: <1101358191.5842.26.camel@localhost.localdomain>
	<41A7B514.9030703@eurodev.net>  <41B61E84.7020304@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41B61E84.7020304@eurodev.net>
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

On Tue, 2004-12-07 at 22:20 +0100, Pablo Neira wrote:
> Pablo Neira wrote:
> 
> >> 2) If not, you must extend the size of the structure, so old kernels
> >> will fail, and new kernels will be able to tell whether they are to use
> >> the new or old structure.  The IPT_ALIGN'ed size of the structure must
> >> change for this to work!
> >
> >
> > My idea, I don't know how crazy it is. Instead of using the size to 
> > guess the target/match version, we could steal 1 byte from char name[] 
> > to define a new field called version, so we could register different 
> > versions of a match/target.
> >
> > Possible scenarios:
> > a) Old kernel, new iptables binary: since names are manipulated with 
> > str* functions, it shouldn't be any problem with the version stuff 
> > because it will be ignored since info after first '\0' is ignored.
> > b) New kernel, old iptables: version value is zero, so kernel guess 
> > that it must handle the thing with first version of the target/match.
> 
> 
> I finally found some spare time to go back this issue, I've finished two 
> patches for the kernel part of my idea of adding versions to 
> targets/matches. One for ip_tables, and other for ipt_MARK, this based 
> on Rusty's.

This is so evil that my first reaction was to say "ick!".  My second
reaction was to say "cool"!.  My third reaction was "ick!" again.

> iptables (user space) patches is still missing  :(

OK.  For the other variant, I wrote a userspace patch, built it, and
used nfsim to test it.  Unfortunately, SVN is having trouble at the
moment, so the test script I used is below (use env var
NFSIM_IPTABLES_PREFIX to override /sbin for iptables)

If you ensure that works, I'm relatively happy with this.
Rusty.

# Test the ipt_MARK target, which has a backwards compatbility mode.

# Test old-style first, insert and delete.
iptables -t mangle -A PREROUTING -j MARK --set-mark 7
iptables -t mangle -D PREROUTING -j MARK --set-mark 7

iptables -t mangle -A PREROUTING -s 192.160.0.2 -j MARK --set-mark 7
iptables -t mangle -D PREROUTING -s 192.160.0.2 -j MARK --set-mark 7

# Test that it works.
iptables -t mangle -A PREROUTING -j MARK --set-mark 7
expect gen_ip send:eth1 MARK 7 {IPv4 192.168.0.2 192.168.1.2 10 17 1 2}
gen_ip IF=eth0 192.168.0.2 192.168.1.2 10 17 1 2
iptables -t mangle -D PREROUTING -j MARK --set-mark 7

# Test new-style, insert and delete.
iptables -t mangle -A PREROUTING -j MARK --or-mark 7
iptables -t mangle -D PREROUTING -j MARK --or-mark 7

iptables -t mangle -A PREROUTING -j MARK --and-mark 7
iptables -t mangle -D PREROUTING -j MARK --and-mark 7

iptables -t mangle -A PREROUTING -s 192.160.0.2 -j MARK --or-mark 7
iptables -t mangle -D PREROUTING -s 192.160.0.2 -j MARK --or-mark 7

iptables -t mangle -A PREROUTING -s 192.160.0.2 -j MARK --and-mark 7
iptables -t mangle -D PREROUTING -s 192.160.0.2 -j MARK --and-mark 7

# Test that they work.
iptables -t mangle -A PREROUTING -j MARK --or-mark 7
expect gen_ip send:eth1 MARK 7 {IPv4 192.168.0.2 192.168.1.2 10 17 1 2}
gen_ip IF=eth0 192.168.0.2 192.168.1.2 10 17 1 2
iptables -t mangle -D PREROUTING -j MARK --or-mark 7

iptables -t mangle -A PREROUTING -j MARK --set-mark 3
iptables -t mangle -A PREROUTING -j MARK --or-mark 4
expect gen_ip send:eth1 MARK 7 {IPv4 192.168.0.2 192.168.1.2 10 17 1 2}
gen_ip IF=eth0 192.168.0.2 192.168.1.2 10 17 1 2
iptables -t mangle -D PREROUTING -j MARK --set-mark 3
iptables -t mangle -D PREROUTING -j MARK --or-mark 4

iptables -t mangle -A PREROUTING -j MARK --set-mark 3
iptables -t mangle -A PREROUTING -j MARK --and-mark 6
expect gen_ip send:eth1 MARK 2 {IPv4 192.168.0.2 192.168.1.2 10 17 1 2}
gen_ip IF=eth0 192.168.0.2 192.168.1.2 10 17 1 2
iptables -t mangle -D PREROUTING -j MARK --set-mark 3
iptables -t mangle -D PREROUTING -j MARK --and-mark 6

# Now mix them up: check we delete the right one.
iptables -t mangle -A PREROUTING -j MARK --set-mark 7
iptables -t mangle -A PREROUTING -j MARK --or-mark 7
iptables -t mangle -A PREROUTING -j MARK --and-mark 7

# Delete old-style.
iptables -t mangle -D PREROUTING -j MARK --set-mark 7
expect iptables iptables: command failed
iptables -t mangle -D PREROUTING -j MARK --set-mark 7
iptables -t mangle -A PREROUTING -j MARK --set-mark 7

# Delete or.
iptables -t mangle -D PREROUTING -j MARK --or-mark 7
expect iptables iptables: command failed
iptables -t mangle -D PREROUTING -j MARK --or-mark 7
iptables -t mangle -A PREROUTING -j MARK --or-mark 7

# Delete and.
iptables -t mangle -D PREROUTING -j MARK --and-mark 7
expect iptables iptables: command failed
iptables -t mangle -D PREROUTING -j MARK --and-mark 7
iptables -t mangle -A PREROUTING -j MARK --and-mark 7

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
