From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: pom-ng and kernel 2.6.6
Date: Fri, 14 May 2004 15:40:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405141538590.21804-100000@blackhole.kfki.hu>
References: <87ekpojci2.fsf@thorr.asgardr.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel 'NebuchadnezzaR' Dehennin <nebuchadnezzar@nerim.net>
In-Reply-To: <87ekpojci2.fsf@thorr.asgardr.info>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 13 May 2004, Daniel 'NebuchadnezzaR' Dehennin wrote:

> On 3907 September 1993, Daniel Dehennin wrote:
> > I say no and try to continue.
>
> I apply all the base section of pom-ng to my 2.6.6, everything seems
> to apply cleanly but during make menuconfig I have errors:
>
> net/ipv4/netfilter/Kconfig:682: syntax error, unexpected T_WORD
> net/ipv4/netfilter/Kconfig:685: invalid menu option
> I remove the following help
>
> in /net/ipv4/netfilter/Kconfig, option IP_NF_MATCH_NTH
> The same for IP6_NF_MATCH_NTH

Help text was not properly indented. Bug is fixed in cvs, thank you.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
