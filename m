From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: HOPLIMIT again
Date: Tue, 17 Feb 2004 19:35:58 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0402171931520.31804@alpha.zarz.agh.edu.pl>
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


Hi,

once again HOPLIMIT, in 
HOPLIMIT/linux/include/linux/netfilter_ipv6/ip6t_HL.h

is IP6T_HOPLIMIT_*  but iptables required IP6T_HL_*
What version is correct ?
IP6T_HOPLIMIT_SET [kernel] or IP6T_HL_SET [iptables] ?

thanx.
					Sas.
-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
