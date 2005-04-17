From: Piotrek Kaczmarek <kaczorek@k.daleka.net>
Subject: libipt_connbytes.c bug in iptables-1.3.1
Date: Mon, 18 Apr 2005 01:09:27 +0200
Message-ID: <20050417230927.GA23821@daleka.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I've spent couple of hours seaching for a fix for this bug... can you apply the patch below?

# iptables -t mangle -A PREROUTING -m connbytes --connbytes-mode packets
iptables v1.3.1: Unknown arg `packets'
Try `iptables -h' or 'iptables --help' for more information.

# iptables -t mangle -A PREROUTING -m connbytes --connbytes-mode bytes
iptables v1.3.1: Unknown arg `bytes'
Try `iptables -h' or 'iptables --help' for more information.

There's a patch:

########### cut

--- libipt_connbytes.c.fucked   2005-04-18 01:00:28.000000000 +0200
+++ libipt_connbytes.c  2005-04-18 00:56:10.000000000 +0200
@@ -93,6 +93,7 @@
                        exit_error(PARAMETER_PROBLEM,
                                   "Unknown --connbytes-mode `%s'", optarg);
                *flags |= 4;
+               break;
        default:
                return 0;
        }

########### cut

-- 
Piotrek Kaczmarek
