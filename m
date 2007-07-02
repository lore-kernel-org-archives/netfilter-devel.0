From: Andreas Steinmetz <ast@domdv.de>
Subject: Re: mss to pmtu clamping partially broken?
Date: Mon, 02 Jul 2007 19:04:12 +0200
Message-ID: <4689300C.9050802@domdv.de>
References: <4684E853.20900@domdv.de>
	<Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706301034320.22579@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> Do you really need clamping? It's a hack, since TCP should do MSS negotiation
> itself. (Of course it may happen that some routers are broken.) But usually not
> for incoming packets.

You never know when you hit ICMP blackholes, broken routers and other
evil things. Better safe than sorry so clamping is the way to go for me.

-- 
Andreas Steinmetz                       SPAMmers use robotrap@domdv.de
