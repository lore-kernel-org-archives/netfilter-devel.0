From: "Tarek W." <mailinglists1@hotpop.com>
Subject: distro kernel support in patch-o-matic-ng [WAS: HOPLIMIT]
Date: Mon, 01 Jan 2001 06:29:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <978323361.27467.12.camel@carve.personal.localdomain>
References: <Pine.LNX.4.58L.0402161307250.2317@alpha.zarz.agh.edu.pl>
 <006801c3f482$5f28a190$0e25fe96@pysiak>
 <Pine.LNX.4.58L.0402161413310.6865@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-reply-to: <Pine.LNX.4.58L.0402161413310.6865@alpha.zarz.agh.edu.pl>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 2004-02-16 at 15:19, Wojciech 'Sas' Cieciwa wrote: [snipped]
> On Mon, 16 Feb 2004, Maciej Soltysiak wrote:
> 
> > > In HOPLIMIT module file has name ip6t_HL.c but Makefile requires 
> > > ip6t_HOPLIMIT.o, and ip6t_HL.c required ip6t_HOPLIMIT.h which not exist.
> > > exist include/linux/netfilter_ipv6/ip6t_HL.h
> > Hmm, what kernel is that ? Which version and is it
> > a vanilla or a distro kernel?

I've been following the earlier thread on architecturing
patch-o-matic-ng to support kernel version, even minor numbers.

I'd like to suggest the inclusion of support (in patch-o-matic-ng, as in
"can work with", not labeled "supported") for distro kernels too.

shouldn't be too different then adding support for leaf kernel versions.
albeit adding headaches to the maintainer which could be delegated to
volunteer sergeants.

/me ducks dodging the hail of bullets and fades away into the dunes

my $.02 ;)
