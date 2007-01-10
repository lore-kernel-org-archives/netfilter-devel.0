From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Opinions about pom/patches [was: iptables 1.3.7, kernel 2.6.19,
 ROUTE and Layer7 issues]
Date: Wed, 10 Jan 2007 14:15:02 +0100 (CET)
Message-ID: <53212.195.55.244.106.1168434902.squirrel@www.arcoscom.com>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
	<45A48087.8090200@trash.net>
	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
To: lartc@mailman.ds9a.nl,
 netfilter-devel@lists.netfilter.org
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

I think so, there are many old matches that are stables and I have to
apply many times when I update the kernel. If they where into kernel and
iptables (because they are now not as experimental than many months/years
ago) these problem when new kernel releases and/or iptables releases
disapears very quickly.

I have a great headache now, I had to patch my kernel, patch iptables,
update iproute to allow "mark-and" operations for routing. Yes, I can
adapt many thinks and forgot many routing/filtering functionality, but
then, my linux box will be useless for the purposes I deploy it.

I have no problem in patch and upgrade thinks, my problem is that I have
no time to do all these steps every any important bug, improvement is
released.

To allow compatibility with my installed distro (one in production and
another in testing), I had to readapt the RPM's and modify specs to put
there the patch. Usually is easy, but when netfilter changes its internals
structs (that I have no knoledgement) I can't correct the patches and
adapt them.

When I readapt RPM's, I can use them into my systems, and I think many
users should want them for their systems and the same purpose as me and I
don't know where I can send them to allow people to use them (perhaps I
make a simple webpage for that and a RPM repository, but I can't use my
lines to allow comunity to massive download the rpm's).

Too punctual work that comunity can't improve or maintain because they
hasn't got access. Perhaps, when I finish the testing and all the problems
I have got in testing environtment were solved, I can make a good
repository to allow community to download and upload thinks, but now, I
had time to make it.

The real problems of all these, I think, are :
   1) That the time from a fix/release goes out to that change appears
into the distro repositories are enought.
   2) Another problem is when there are bugs are fixed in versios and that
fix is not backported to prior versions and distros mainteneers have to
backport the fix to preserve stable state of the distro package (less
features than actual stable sources, but stable system).
   3) Another problem is that the patches for bugfixes are not public or
easy accesible for normal users as me, and then I not only need to
learn how to patch, make and upgrade (or rpm/deb build), I need to
learn too how to extract the bugfix patch I need to solve one problem
in my kernel/iptables/module/etc... version, what are the developer
list, subscribe, where are the development sources that correct the
problem, how I can download the patch, etc...

I know that all these project are diferent communities, but if all
comunities make more easy to the end user some tasks, the users learns
more quickly how to contribute and work with the many projects and
tecknologies.

Don't know how projects could make the thinks easy, but, in case of
netfilter, some tables explaining what matches are included in kernel (and
from what version) allow users to know what kernel version can use for
certain purposes.

For example, I know h323 where added into kernel at 2.6.17 kernel version,
but the community appears to be working into 2.6.16.x version to stabilize
it and and backported many bugfixes from 2.6.19.x to 2.6.16.x. I think
2.6.16.x kernel is the more stable at these days, but if I want h323
conntrack modules I can't use pom-&#324;g because h323 is not in pom-ng
today, and if I use old pom-ng, I know I will use a module with some bugs
corrected in 2.6.18.x kernel. Do I explained a problem that have many
users than me?

Another example, some body say in the lists that using "mark" will allow
me to change routes by "mark value" or by "and-mark mask", fine, that were
to substitute ROUTE tarjet. I think that is a correct solution but ...
What are the implications? 1) I can't see any documentation in netfilter
or iproute.
2) My distro don't update the packages, I have to do it manually.
3) When I have an updated iproute package, kernel package, iptables
package and I finish and test the configuration, I have the knowledte to
write a little explanation/how-to to allow users to know how and don't
waste their time looking for the steps ... some hours after I found a
wiki, I need to register, etc.... When I finished all the needed steps to
allow me to write a "more or less" public super-mini-howto I forgot the
steps and I, finally, don't write the info, because my systems are working
for my purposes, I have my paper with my hand annotations and I need to
continue working in more tasks.

Sorry for the big e-mail, but it is only my user opinion about these type
o things.

Sorry for my poor english.

Regards

El Mie, 10 de Enero de 2007, 12:53, Jan Engelhardt escribió:
>
> On Jan 10 2007 06:58, Patrick McHardy wrote:
>>Krzysztof Oledzki wrote:
>>>> Its still down, but the ROUTE patch is unmaintained anyway.
>>>
>>> How about attached (and inlined) patch. BTW - is it possible to add a
>>> Kconfig entry after a specific text, like with Makefile.ladd?
>>>
>>> [POM-NG] ROUTE: 2.6.19 compatibility fix
>>>
>>> Make both IPv4 and IPv6 versions compatible with 2.6.19
>>
>>
>>Thanks Krzysztof, applied.
>>
>>I would prefer to have someone maintain it externally though. Jan, are
>>you still interested in doing that? If you need help or webspace for
>>an external repository please let me know.
>
> I would give it a try. Though I would really prefer to have it in the
> kernel and iptables rather than pomng or pomng-external. In my
> opinion that simplifies maintainability. Changes in the netfilter API
> seem to be the most common reason for patching (someone changed the
> xt_match->match and xt_target->target signatures in 2.6.20 again!),
> and keeping out-of-tree modules compiling with kernel-du-jour can be
> an #ifdef pita. Then it's really preferable to have 2.6.18 have a
> xt_FOOBAR with netfilter-2.6.18 signatures, and 2.6.20 with
> netfilter-2.6.20. Especially since many people run distributions with
> RPM/DEBified iptables, so the POM `runme` will not be easy to
> accomplish for the casual user. (I currently do have that issue -
> after doing `svn up` on pomng, I have to manually move the changes to
> (my) kernel rpm and (my) iptables rpm, because the days of `make
> install` are GONE for me - at least I try.)
>
> I understand that POM does not require to compile with all
> kernels-of-the-last-three-months, but this also simplifies
> integration for end users. They do not need to backport/forward port
> indated/outdated out-of-tree modules and, at best, do not even need
> to recompile the kernel.
>
> Of course there are some modules that continue being out-of-tree
> because they would not fit in (imagine a 500K geoip.c with a
> compiled-in big string array). Not sure what to do about them.
> Perhaps do it like chaostables [2.6.18-2.6.20], trying to keep it
> working for a limited set of kernels.
>
> Oh well, that said, my ideal plan would be to get ROUTE TARPIT
> connlimit and u32 into mainline in one go, and perhaps, after review
> and discussion, chaostables and some of the others that live in
> Krzystof's patchlet collection.
>
> Opinions, please?
>
>
> 	-`J'
> --
>
>
