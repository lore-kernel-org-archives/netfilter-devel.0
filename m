From: Peter Warasin <peter-k8AlXt1uIdjQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] adds ebtables nflog support to ulogd
Date: Mon, 11 Feb 2008 23:07:53 +0100
Message-ID: <20080211220753.796791654@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ebtables-devel>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Hi Guys

The following patch-set adds ebtables nflog support to ulogd.

In order to have this work it's also necessary to apply the
ebtables and kernel patches I posted some time ago
(i posted as well as this post on both, ebtables and
netfilter devel lists).

Those patches add both ebt_nflog kernel module and userland
module.

However the patches can certainly be applied separately.

This patchset adds now the corresponding support to ulogd's
BASE, PRINTPKT and IP2STR modules.
Currently it interprets the AF_BRIDGE family and knows to
differentiate IP and ARP header and log them accordingly.

Here is a sample log output:

Feb 11 20:56:30 efw-1201175446 ulogd[10972]: EBTABLES TEST IN=br0 OUT= \
MAC=00:0c:e0:e0:7d:62:ff:ff:08:00:0c:00 SRC=10.7.100.2 DST=10.7.222.22 \
PROTO=ARP REQUEST 
Feb 11 20:56:31 efw-1201175446 ulogd[10972]: EBTABLES TEST IN=br0 OUT= \
MAC=00:0c:e0:e0:7d:62:ff:ff:08:00:0c:00 SRC=10.7.100.2 DST=10.7.222.22 LEN=84 \
TOS=00 PREC=0x00 TTL=64 ID=0 DF PROTO=ICMP TYPE=8 CODE=0 ID=10541 SEQ=0 
Feb 11 20:56:35 efw-1201175446 ulogd[10972]: EBTABLES TEST IN=br0 OUT= \
MAC=00:0c:e0:e0:7d:62:ff:ff:08:00:0c:00 SRC=10.7.100.2 DST=10.7.222.22 \
PROTO=ARP REPLY REPLY_MAC=00:0c:e0:e0:7d:62 

More protocols *could* be implemented later.

kind regards,

Peter

-- 

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
