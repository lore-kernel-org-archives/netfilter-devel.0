From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP window tracking has bad side effects
Date: Fri, 10 Dec 2004 20:42:10 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412102036050.15549@blackhole.kfki.hu>
References: <20041201110253.GA9536@suse.de>
	<Pine.LNX.4.58.0412011308520.27175@blackhole.kfki.hu>
	<20041201153903.GA16807@suse.de>
	<Pine.LNX.4.58.0412030942320.30157@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412060934050.5880@blackhole.kfki.hu>
	<20041209162656.GA9569@suse.de>
	<20041210172217.GA4323@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Ludwig Nussel <ludwig.nussel@suse.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
In-Reply-To: <20041210172217.GA4323@ti64.telemetry-investments.com>
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

On Fri, 10 Dec 2004, Bill Rugolsky Jr. wrote:

> On Thu, Dec 09, 2004 at 05:26:56PM +0100, Ludwig Nussel wrote:
> > Seems to work. The client machine no longer drops the packet and
> > properly sends RST.
>
> Will you push this to DaveM for 2.6.10?

Yes, he fully aware of the issue and the slightly modified version I have
posted to the list today (not arrived yet, it seems) will hopefully be
added to 2.6.10.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
