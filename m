From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: HOPLIMIT
Date: Mon, 16 Feb 2004 13:11:20 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0402161307250.2317@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


In HOPLIMIT module file has name ip6t_HL.c but Makefile requires 
ip6t_HOPLIMIT.o, and ip6t_HL.c required ip6t_HOPLIMIT.h which not exist.
exist include/linux/netfilter_ipv6/ip6t_HL.h

Rename works OK.
					Sas.
-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
