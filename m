From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables command and target ULOG problem
Date: Mon, 02 May 2005 22:31:08 +0200
Message-ID: <42768E0C.2080406@trash.net>
References: <79a98d9f05050112304848c6ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020505090504020708030303"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Andre Luiz da Silva <andrack@gmail.com>
In-Reply-To: <79a98d9f05050112304848c6ce@mail.gmail.com>
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

This is a multi-part message in MIME format.
--------------020505090504020708030303
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Andre Luiz da Silva wrote:
> Hello friends...
> 
> I'm using the iptables version 1.2.11 and I have the follow problem with
> ULOG iptables target:
> 
> For example....
> 
> When I insert the rule and the parameter '-j ULOG' are before icmp protocol
> options, I received the error "Bad argument":

Fixed in svn by this patch.

Regards
Patrick

--------------020505090504020708030303
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: extensions/libipt_ULOG.c
===================================================================
--- extensions/libipt_ULOG.c	(Revision 3889)
+++ extensions/libipt_ULOG.c	(Arbeitskopie)
@@ -144,6 +144,8 @@
 #endif
 		*flags |= IPT_LOG_OPT_QTHRESHOLD;
 		break;
+	default:
+		return 0;
 	}
 	return 1;
 }

--------------020505090504020708030303--
