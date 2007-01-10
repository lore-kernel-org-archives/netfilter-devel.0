From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Wed, 10 Jan 2007 13:53:49 +0100
Message-ID: <45A4E1DD.8070001@trash.net>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
	<Pine.LNX.4.64.0612282158360.16672@bizon.gios.gov.pl>
	<45A48087.8090200@trash.net>
	<Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: lartc@mailman.ds9a.nl, netfilter-devel@lists.netfilter.org,
	Krzysztof Oledzki <ole@ans.pl>
Return-path: <lartc-bounces@mailman.ds9a.nl>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701101233080.3029@yvahk01.tjqt.qr>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Jan 10 2007 06:58, Patrick McHardy wrote:
> 
>>I would prefer to have someone maintain it externally though. Jan, are
>>you still interested in doing that? If you need help or webspace for
>>an external repository please let me know.
> 
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

ROUTE will not go in, its a bad hack and shouldn't be used (which
is why I would prefer to get rid of it). Haven't looked at TARPIT
and connlimit in a long time, we can think about it.
