From: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>
Subject: Which netfilter modues are ready for 2.6 ?
Date: Thu, 29 Jan 2004 12:02:23 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58L.0401291151110.8878@alpha.zarz.agh.edu.pl>
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

I try to build modules from patch-o-matic-ng on kernel 2.6.2-rc2.
But as I see many of modules aren't prepared for kernel 2.6.*
For example: 
nf-log - missing BT_NETPROTO_LOCK declaration
rtsp-conntrack - missing ct_rtsp_info
talk-conntrack-nat - missing ct_talk_info
mms-conntrack-nat - missing ct_mms_info
ctstat and raw - missing ip_conntrack_defrag_ops and 
ip_conntrack_defrag_local_out_ops

Can anyone tell mw which modules are tested [and working] on 2.6.* ?

Thanx.
					Sas.
-- 
{Wojciech 'Sas' Cieciwa}  {Member of PLD Team                               }
{e-mail: cieciwa@alpha.zarz.agh.edu.pl, http://www2.zarz.agh.edu.pl/~cieciwa}
