From: Samuel Jean <jix@bugmachine.ca>
Subject: Re: How to block traffic country-wise?
Date: Sat, 27 May 2006 08:42:08 -0400
Message-ID: <1148733728.8723.8.camel@localhost.localdomain>
References: <4477791A.5070100@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dirk <noisyb@gmx.net>
In-Reply-To: <4477791A.5070100@gmx.net>
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

On Fri, 2006-26-05 at 23:54 +0200, Dirk wrote:
> Hello,
> I want to write a firewall that can block traffic from specific
> countries using GeoIP.dat.

There is the geoip match module for iptables.

> Can someone give me a hint, example, snippet or link?

There is the PoM module:
http://people.netfilter.org/~peejix/patchlets/

Krzysztof Ol=C4=99dzki patch for linux 2.6.16.x:
https://lists.netfilter.org/pipermail/netfilter-devel/2006-May/024303.htm=
l

There is the howto:
http://people.netfilter.org/~peejix/geoip/howto/geoip-HOWTO.html

HTH,
--peejix
