From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Calling multiple times ip_nat_mangle_tcp_packet()
Date: Mon, 5 Jul 2004 10:41:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0407021150190.32120-100000@blackhole.kfki.hu>
References: <04EE7AD0450F7B498BA216312943A1A1155585@blrse201.ap.infineon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <Atanu.Mondal@infineon.com>
In-Reply-To: <04EE7AD0450F7B498BA216312943A1A1155585@blrse201.ap.infineon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2 Jul 2004 Atanu.Mondal@infineon.com wrote:

> I am mangling SIP Message Header and data and for this I am calling
> ip_nat_mangle_tcp_packet() funtion for
> each line which need to adjust its IP Address.. The problem I am facing
> is with TCP seq numbering..
> The ip_nat_resize_packet() function takes care of the seq numbering
> inside ip_nat_mangle_tcp_packet() but
> it takes care of the adjustment for only the 1st call.. Any subsequent
> call to ip_nat_mangle_tcp_packet
> does not adjust the offset_before and offset_after parameters and the it
> remains what it was in the first
> call.
> In the return direction the ack and seq no is adjusted as per the offset
> set in the 1st call..which is wrong.
>
> Can somebody help me out in understanding how to do it... Or do I need
> to writeout my  own function. ???

Write your own mangle_tcp_packet function: the current one supports one
adjustment in the window, as the comment in the source code says as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
