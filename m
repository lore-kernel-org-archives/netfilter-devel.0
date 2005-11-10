From: Pablo Neira <pablo@eurodev.net>
Subject: web & releasing [was Re: problem with conntrack-0.81]
Date: Thu, 10 Nov 2005 05:14:42 +0100
Message-ID: <4372C932.8050006@eurodev.net>
References: <20051026030113.8DA3F42B2@daahman.cosmicfires.com>	<435F2D12.7050003@eurodev.net>	<20051026112645.GJ4479@sunbeam.de.gnumonks.org>	<436BAB3A.2030703@eurodev.net>
	<20051104203936.GK5594@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: David Walker <david@cosmicfires.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051104203936.GK5594@sunbeam.de.gnumonks.org>
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

Hi Harald,

Harald Welte wrote:
> On Fri, Nov 04, 2005 at 07:40:58PM +0100, Pablo Neira wrote:
> 
>>pablo@legba:~/SVN-netfilter/trunk/homepage$ make
>>make -C xml
>>make[1]: Entering directory `/usr/src/SVN/trunk/homepage/xml'
>>perl -I../scripts -I../../patch-o-matic-ng ../scripts/pom2docbook.pl
>>--xmldir ./patch-o-matic --repository pending
>>../../patch-o-matic-ng/patchlets
>>Your linux version  is unknown for patch-o-matic at
>>../scripts/pom2docbook.pl line 119
>>make[1]: *** [patch-o-matic/pom-pending.xml] Error 255
>>make[1]: Leaving directory `/usr/src/SVN/trunk/homepage/xml'
>>make: *** [all] Error 2
>>
>>any clue on what's wrong?
> 
> it tries to execute patch-o-matic-ng, but doesn't find a linux kernel in
> the default location (don't know where the default is, you'd have to
> check the sources).
> 
> this is for auto-creating the xml/html pages from the patch-o-matic
> tree.

The problem was that I forgot to set KERNEL_DIR and IPTABLES_DIR. OK,
now the problem is something different. Once I type make:

...
projects/libnetfilter_conntrack/downloads.xml:
projects/libnetfilter_conntrack/downloads.html
projects/conntrack/index.xml: projects/conntrack/index.html
projects/conntrack/downloads.xml: projects/conntrack/downloads.html
projects/ipset/index.xml: projects/ipset/index.html
projects/hipac/index.xml: projects/hipac/index.html
patch-o-matic/index.xml: projects/patch-o-matic/index.html
patch-o-matic/pom-submitted.xml: projects/patch-o-matic/pom-submitted.html
warning: failed to load external entity "patch-o-matic/pom-pending.xml"
patch-o-matic/pom-pending.xml: missing ID.
make: *** [autolayout.xml] Error 10

That file is missing. OK, to work around the problem I just remove the
reference to pom-pending.xml in layout.xml. Now I typed "make" again,
and the compilation loops forever.

make[1]: Entering directory `/usr/src/SVN/trunk/homepage/xml'
...
make[2]: Entering directory `/usr/src/SVN/trunk/homepage/xml'

and so on. Any clue?

>>>The more important issues is, how we're going to handle signing and
>>>uploading of the respective files to ftp and http server.  At the
>>>moment, only the core team can sign releases (and has the respective
>>>upload permissions).
>>
>>During the WS you told me that you needed someone that could do the
>>releasing stuff. Well, I don't know if this could help but if you
>>consider that I could that such work, what will it consist on?
> 
> well, basicaully it would mean that you'd be doing the 'make distrib',
> uploading the files to the http/ftp server, updating the homepage xml,
> rebuilding html from the xml, and (at least in the iptables case)
> manually write the changelog based on the diff to the previous version
> and the svn commit messages.

OK, that looks quite easy to automate. But, about iptables, maybe we
could add a ChangeLog file? That would make my life easier.

> PGP/GPG signign is an issue, and currently we only have one key for the
> coreteam.  Maybe we should create a separate 'release signing key' that
> would be kept with the releasemaster (e.g. you).
> 
> An alternative was to wait for somebody in the netfilter project to send
> you the signed released file, and you would just do the
> copying/updating/rebuilding/checking/...

Whatever. If I get some autonomy I'll be able to do things more
efficiently, so I prefer the first option. It's up to you.

cheers,
Pablo
