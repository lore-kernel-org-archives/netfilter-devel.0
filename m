From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ipset matches either,both
Date: Mon, 07 Aug 2006 14:21:26 +0100
Message-ID: <44D73E56.9070102@ufomechanic.net>
References: <eat75p$9o4$1@sea.gmane.org>
	<Pine.LNX.4.58.0608070907400.8741@blackhole.kfki.hu>
	<44D6FF0A.8050009@ufomechanic.net>
	<Pine.LNX.4.58.0608071108130.8741@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0608071108130.8741@blackhole.kfki.hu>
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

* Jozsef Kadlecsik wrote, On 07/08/06 11:49:
> >From the svn changelog:
>
> iptables.c, rev 6474, modified Fri Mar 3 09:36:50 2006 UTC (5 months ago):
>
> Multiple matches of the same type can be specified on the commandline.
>
> If two or more matches of the same type are detected then the options
> are assumed to be grouped in order to tell which option belongs
> to which match:
>
> ... -m foo ... <options0> ... -m foo ... <options1> ...
>
> Otherwise the commandline parsing is unmodified.
>   
dang, I missed that.
...
> I'm open to feature requests and suggestions for the next revisions but
> still not convinced about "both" and "either", sorry:
>
> "both" is equal to    -m set --set foo src -m set --set foo dst
> "neither" is equal to -m set ! --set foo src -m ! set --set foo dst
> "either" can be expressed by two iptables rules.
>
> So what can we gain?
>   
indeed. *sob*

Sam
