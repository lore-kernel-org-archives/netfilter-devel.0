From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: NFNL_NFA_NEST
Date: Wed, 21 Mar 2007 11:04:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0703211014200.4799@blackhole.kfki.hu>
References: <4600BDBB.8020205@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4600BDBB.8020205@trash.net>
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

Hi Patrick,

On Wed, 21 Mar 2007, Patrick McHardy wrote:

> One of the worst mistakes in nfnetlink in my opinion was the
> introduction of the NFNL_NFA_NEST bit. It prevents us from
> using a large part of the generic netlink stuff, since that
> just interprets it as a really huge attribute type. Since
> its not used even for anything, this is really annoying.

Pablo helped me to work on porting ipset from sockopt to nfnetlink (which 
is still not finished yet :-() and I nagged Pablo a lot to use nesting, 
primarily to hide sub-module details at netlink message level from the 
ipset core. For example when adding/deleting/testing a set, the netlink 
message looks like this:

<set name>
<set type>
<nested: set type specific data>

so that the core is not burdened by module-dependent details.

The other place where I wanted to use nesting is to send a bunch of the 
same type data in one netlink message instead of sending every one of them 
in separated messages: I shudder to send ~370 netlink messages instead of 
a single one in order to pass that number of IP addresses.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
