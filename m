From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: H.323 progress.
Date: Tue, 18 May 2004 10:54:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405181044330.32272-100000@blackhole.kfki.hu>
References: <40A9431D.8020404@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Richard Scobie <richard@sauce.co.nz>
In-Reply-To: <40A9431D.8020404@sauce.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 18 May 2004, Richard Scobie wrote:

> I have a FreeSwan IPsec VPN between 2 iptables NAT boxes.
>
> With H.323 videoconferencing equipment from both Via Video and Tandberg,
> I have been unable to get complete connection between both ends through
> the VPN - 90+ % of the time, video connects both ways and audio only one.
>
> The same setup using 2.2 kernels and ipchains works fine every time.
>
> After finding some information in the list archives, I was just wanting
> to confirm that the problem I am seeing is due to the current H.323
> helper modules and also whether these modules are currently being
> actively developed?

I abandoned the H.323 helper modules because in the present form they work
only in the most simple cases and the modules cannot be improved without
really implementing a H.323 parser. That, however, would require too much
time from me, dedicated to this single task.

If you have got such equipments as Via Video and Tandberg, better set up a
H.323 gatekeeper in proxy mode and configure the firewall to allow the
traffic to/from the gatekeeper in the port range you specified. Such
setups work fine and reliably. (However, it seems some Microsoft
netmeeting versions don't obey to communicate fully trough the proxy.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
