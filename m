From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 29 Jun 2005 09:39:12 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@drugphish.ch>
In-Reply-To: <42C17443.60909@drugphish.ch>
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

Hi,

On Tue, 28 Jun 2005, Roberto Nibali wrote:

> Is the conntrack_error-api still needed and if so, where can I find it?

Good catch: not required so I removed the dependency from the info
file in svn.

> > Please report me any success/failure reports wether it's an improvement
> > compared to the previous version in your environment or not.
>
> Do you happen to have a changelog written down somewhere or shall I diff
> the two linux-2.4 patches?

The last update sent to 2.6 kernel inclusion created the major difference
between the two flavours. Now they are in sync and the most important
fixes are in no particular order

- Article on which the code is based falsely
  assumed that packets must fit completely into
  the window: packets must at least overlap, logic fixed
- Reopening connections now done properly
- We handle ACK packets sent by server to late resent SYNs too
- Arbitrary RST segments could cause connection
  teardown, fixed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
