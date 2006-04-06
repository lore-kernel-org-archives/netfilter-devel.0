From: Patrick McHardy <kaber@trash.net>
Subject: Re: The future of patch-o-matic-ng
Date: Thu, 06 Apr 2006 12:40:25 +0200
Message-ID: <4434F019.3060000@trash.net>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>
	<20060405152628.GI20558@sunbeam.de.gnumonks.org>
	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>
	<20060406073514.GE6887@sunbeam.de.gnumonks.org>
	<4434CFBF.7030208@trash.net>
	<Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>
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
> If there are no other volenteers I would like to keep following patchlets:
>  - TARPIT
>  - connlimit
>  - geoip
>  - ipp2p
>  - time

Thanks, I've updated my list. I think some of these are actually
actively maintained. If a maintainer itself offers to keep a
repository, he will most likely be prefered.


> What about ROUTE, ipv4options, random, u32? Are they going to be
> included in mainline?

ROUTE will be kept in pomng, ipv4options will be merged, random will
be merged with nth and then go into the kernel (I've already started
this), u32 will also go in the kernel.

>>> Also, I assume that there is a lot that can be done to improve that
>>> patchlet-handling script, i.e. add suport for GPG signature checking and
>>> the like.  I suggest you coordinate with Patrick on this.
>>
>>
>> Definitely. The code is very basic, it only makes sure a patchlet
>> 1) doesn't overwrite anything outside of its patchlet directory
>> 2) can only overwrite "Repository: external" patchlets
>>
>> But doensn't do any signature verification. I'll add it today,
>> patches are welcome.
> 
> 
> So, this external repository will be used only by netfilter server to
> download patchlets? People will be still able to download complete
> pom-ng package? How it is better from giving access to the svn server?

No, it will be used by users to download patchlets.

BTW, the code is in SVN now.
