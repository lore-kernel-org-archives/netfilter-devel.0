From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: DPRINTK -> pr_debug conversion
Date: Sat, 9 Jun 2007 11:01:18 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706091059550.14652@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi Patrick,


I've get compile errors when replacing DPRINTK by pr_debug. That's 
because variables, structs and internals changed over time, while the 
dprintks did not. (net/netfilter/xt_helper.c for example. Turn the #if 0 
into #if 1 and see.)


	Jan
-- 
