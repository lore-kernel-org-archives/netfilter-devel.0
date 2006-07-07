From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.17.1 compile error with a netfilter module
Date: Fri, 07 Jul 2006 06:13:42 +0200
Message-ID: <44ADDF76.6000304@trash.net>
References: <925A849792280C4E80C5461017A4B8A206F784@mail733.InfraSupportEtc.com>
	<1151700888.2709.4.camel@murdegern.hindenburgdamm.example>
	<44A9615C.2050405@trash.net>
	<Pine.LNX.4.64.0607032135220.9324@bizon.gios.gov.pl>
	<925A849792280C4E80C5461017A4B8A208D0A6@mail733.InfraSupportEtc.com>
	<Pine.LNX.4.64.0607062323410.31114@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Torsten Luettgert <t.luettgert@pressestimmen.de>,
	netfilter-devel@lists.netfilter.org,
	Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0607062323410.31114@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> OK, I prepared external repository with correct (I hope!) time and ipp2p
> extensions, TARPIT and connlimit are going to be fixed soon. Before I
> submit this to Patrick I need to be sure that it works. If you would
> like to test it, please:
> 
>  - remove "time" and "ipp2p" directories from extracted pom-ng
> 
>  - add this to the sources.list:
> 
> # ipp2p and time maintained by Krzysztof Oledzki <ole@ans.pl>
> http://people.netfilter.org/ole/pom/
> 
>  - run "./runme --download"
> 
>  - patch & recompile kernel as always
> 
>  - tell me if it works (or not).
> 
> Both extensions should work with both 2.6.16 and 2.6.17 kernels if I
> done everything properly.

Thanks Krzysztof, seems to work fine (didn't tried patching, but
the rest). I've added it to the sources.list now.
