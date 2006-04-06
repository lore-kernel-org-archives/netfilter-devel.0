From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: The future of patch-o-matic-ng
Date: Thu, 6 Apr 2006 12:34:21 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>
	<20060405152628.GI20558@sunbeam.de.gnumonks.org>
	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>
	<20060406073514.GE6887@sunbeam.de.gnumonks.org>
	<4434CFBF.7030208@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-993088008-1144319661=:18845"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4434CFBF.7030208@trash.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-993088008-1144319661=:18845
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 6 Apr 2006, Patrick McHardy wrote:

> Harald Welte wrote:
>> As indicated in Patricks mail, there's a 30 day grace period.  Until
>> then the original authors (if they care) or other people can take
>> maintenance for individual patchlets and send us URL's to those
>> repositories.  We will add them to our list file, and distribute a
>> 'runme' script which downloads those repositories off the net.
>>
>> If you want to help, I suggest to wait for those patchlets that nobody
>> takes care of, and run a repository for them.
>
> As a side-note: anyone who decides to take maintanance for some
> patchlet, please drop me a short note, so I can keep a list
> of unmaintained patches.

If there are no other volenteers I would like to keep following patchlets:
  - TARPIT
  - connlimit
  - geoip
  - ipp2p
  - time

What about ROUTE, ipv4options, random, u32? Are they going to be=20
included in mainline?

>> Also, I assume that there is a lot that can be done to improve that
>> patchlet-handling script, i.e. add suport for GPG signature checking and
>> the like.  I suggest you coordinate with Patrick on this.
>
> Definitely. The code is very basic, it only makes sure a patchlet
> 1) doesn't overwrite anything outside of its patchlet directory
> 2) can only overwrite "Repository: external" patchlets
>
> But doensn't do any signature verification. I'll add it today,
> patches are welcome.

So, this external repository will be used only by netfilter server to=20
download patchlets? People will be still able to download complete pom-ng=
=20
package? How it is better from giving access to the svn server?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-993088008-1144319661=:18845--
