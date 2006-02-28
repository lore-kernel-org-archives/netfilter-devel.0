From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Multiple matches of the same type
Date: Tue, 28 Feb 2006 17:52:08 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602281747430.18836@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0602270933130.15955@blackhole.kfki.hu>
	<Pine.LNX.4.64.0602281726240.32525@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0602281726240.32525@bizon.gios.gov.pl>
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

On Tue, 28 Feb 2006, Krzysztof Oledzki wrote:

> > If two or more matches of the same type are detected then the options are
> > assumed to be grouped in order to tell which option belongs to which
> > match:
> >
> > ... -m foo ... <options0> ... -m foo ... <options1> ...
>
> What about -s and -d? I know about ipset but sometimes you need
> just two or three addresses.

The matches are ANDed and not ORed. Without a complete redesign or
alternate store/lookup methods what you request cannot be done.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
