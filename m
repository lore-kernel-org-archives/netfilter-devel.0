From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: Re: HOPLIMIT
Date: Mon, 16 Feb 2004 14:19:42 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0402161413310.6865@alpha.zarz.agh.edu.pl>
References: <Pine.LNX.4.58L.0402161307250.2317@alpha.zarz.agh.edu.pl>
 <006801c3f482$5f28a190$0e25fe96@pysiak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
In-Reply-To: <006801c3f482$5f28a190$0e25fe96@pysiak>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 16 Feb 2004, Maciej Soltysiak wrote:

> > In HOPLIMIT module file has name ip6t_HL.c but Makefile requires 
> > ip6t_HOPLIMIT.o, and ip6t_HL.c required ip6t_HOPLIMIT.h which not exist.
> > exist include/linux/netfilter_ipv6/ip6t_HL.h
> Hmm, what kernel is that ? Which version and is it
> a vanilla or a distro kernel?
> 
> I wrote the modules as *_HL everywhere and I do not
> recall changing their names ever :-)

kernel from PLD 2.6.3, but patch-o-matic-ng from CVS.
version of ip6t_JL.c is 1.1 
===================================================================
File: ip6t_HL.c        	Status: Up-to-date

   Working revision:	1.1
   Repository revision:	1.1	/cvspublic/patch-o-matic-ng/HOPLIMIT/linux/net/ipv6/netfilter/ip6t_HL.c,v
   Sticky Tag:		(none)
   Sticky Date:		(none)
   Sticky Options:	(none)

grep -i include ip6t_HL.c | grep ip6t 
#include <linux/netfilter_ipv6/ip6_tables.h>
#include <linux/netfilter_ipv6/ip6t_HOPLIMIT.h>
                               ^^^^^^^^^^^^^^^

					Sas.
-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
