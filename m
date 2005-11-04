From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack-0.81
Date: Fri, 04 Nov 2005 19:40:58 +0100
Message-ID: <436BAB3A.2030703@eurodev.net>
References: <20051026030113.8DA3F42B2@daahman.cosmicfires.com>	<435F2D12.7050003@eurodev.net>
	<20051026112645.GJ4479@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: David Walker <david@cosmicfires.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051026112645.GJ4479@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Wed, Oct 26, 2005 at 09:15:30AM +0200, Pablo Neira wrote:
>>I still have some things that I want to do before the first 1.0
>>release, among them learning how to add new releases to the
>>netfilter.org webpage, Harald? any help?
> 
> just check out the 'trunk/homepage' directory and try whether a 'make'
> does in fact generate a working copy of the homepage.   The build system
> works on Debian systems quite fine, you'll need xsltproc and
> docbook-website.

Installed both packages on my laptop (debian). Besides I needed to
install libxml-writer-perl (Write.pm required) and:

pablo@legba:~/SVN-netfilter/trunk/homepage$ touch depends.tabular
pablo@legba:~/SVN-netfilter/trunk/homepage/xml$ touch depends.tabular

and then, type make.

pablo@legba:~/SVN-netfilter/trunk/homepage$ make
make -C xml
make[1]: Entering directory `/usr/src/SVN/trunk/homepage/xml'
perl -I../scripts -I../../patch-o-matic-ng ../scripts/pom2docbook.pl
--xmldir ./patch-o-matic --repository pending
../../patch-o-matic-ng/patchlets
Your linux version  is unknown for patch-o-matic at
../scripts/pom2docbook.pl line 119
make[1]: *** [patch-o-matic/pom-pending.xml] Error 255
make[1]: Leaving directory `/usr/src/SVN/trunk/homepage/xml'
make: *** [all] Error 2

any clue on what's wrong?

> Once that works, I suggest looking at
> http://svn.netfilter.org/netfilter/trunk/homepage/xml/projects/conntrack/downloads.xml
> and adding the release to the xml code.  then rebuild the page.  if
> everything works fine, send me a patch, I'll apply it, rebuild and
> upload the homepage.

OK.

> The more important issues is, how we're going to handle signing and
> uploading of the respective files to ftp and http server.  At the
> moment, only the core team can sign releases (and has the respective
> upload permissions).

During the WS you told me that you needed someone that could do the
releasing stuff. Well, I don't know if this could help but if you
consider that I could that such work, what will it consist on?

-- 
Pablo
