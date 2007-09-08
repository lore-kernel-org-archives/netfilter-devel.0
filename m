From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] iptables namespaces
Date: Sat, 8 Sep 2007 15:59:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709081557570.16699@fbirervta.pbzchgretzou.qr>
References: <20070907180204.GA460@ekonomika.be>
	<20070907184642.GA4728@outback.rfc2324.org>
	<20070907190601.GA18714@ekonomika.be>
	<Pine.LNX.4.64.0709080924090.25942@fbirervta.pbzchgretzou.qr>
	<20070908132810.GA19766@ekonomika.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070908132810.GA19766@ekonomika.be>
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


On Sep 8 2007 13:28, Steven Van Acker wrote:
>
>it's remarkable that we have never tried it this way before.
>I tested adding 10000 lines with iptables, then using iptables-save and
>iptables-restore. The difference in speed is amazing. With iptables it
>takes 5 minutes and 10 seconds, while iptables-restore takes 0.3
>seconds.

Well obviously. Because *for EACH* iptables command that you run,
it does a load and store. That, by definition, takes O(n*(n+1));
where iptables-restore is like O(n) for n rules.



	Jan
-- 
