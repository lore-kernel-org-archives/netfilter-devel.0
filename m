From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Follow packets in rules
Date: Mon, 25 Jun 2007 15:52:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706251549580.3137@fbirervta.pbzchgretzou.qr>
References: <466FB176.7040306@netfilter.org>
	<twig.1181752139.4605@bugmachine.ca> <467020F6.2050906@trash.net>
	<Pine.LNX.4.64.0706132138050.7396@blackhole.kfki.hu>
	<46713EE8.6060906@trash.net>
	<Pine.LNX.4.64.0706141536530.8110@blackhole.kfki.hu>
	<46714F7D.4010309@trash.net>
	<Pine.LNX.4.64.0706181208160.13474@blackhole.kfki.hu>
	<467BDA90.7090802@trash.net>
	<Pine.LNX.4.64.0706231843350.22171@blackhole.kfki.hu>
	<467E844C.6030600@trash.net> <467FB2BE.6080509@trash.net>
	<Pine.LNX.4.64.0706251445390.3137@fbirervta.pbzchgretzou.qr>
	<467FBC63.4010908@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FBC63.4010908@trash.net>
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


On Jun 25 2007 15:00, Patrick McHardy wrote:
+static const char *hooknames[] = {
+	[NF_IP_PRE_ROUTING]		= "PREROUTING",
                           ^
Well I meant: Where are the spaces? Try looking at it with tab width 4
and you'll see the alignment breaks :)


	Jan
-- 
