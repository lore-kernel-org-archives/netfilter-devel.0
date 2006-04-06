From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: The future of patch-o-matic-ng
Date: Thu, 06 Apr 2006 15:42:13 +0200
Message-ID: <44351AB5.9090103@gmx.net>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>	<20060405152628.GI20558@sunbeam.de.gnumonks.org>	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>	<20060406073514.GE6887@sunbeam.de.gnumonks.org>	<4434CFBF.7030208@trash.net>	<Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>	<20060406105350.GT6887@sunbeam.de.gnumonks.org>	<4435143E.3030700@gmx.net>
	<20060406131939.GA19216@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20060406131939.GA19216@oknodo.bof.de>
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

Patrick Schaaf schrieb:
>>So if you really don't want to package patches from other sources
>>anymore, please be honest and call the new package pom-coreteam
>>or something like that.
> 
> What has honesty to do with naming things?

Sorry, english is my second language. Maybe "broken expectation"
would be a better description.

> As far as I can see, the core team is honestly telling us what
> they are going to do, and why. Happy naming games don't enter
> into this feeling of mine.

Yes. I always treated pom-ng as patch collection which is usable
offline. With the proposed change, it becomes a mix of patch
collection and patch list. Packaging a patch list doesn't make
sense, but packaging a link to a package list makes sense. If
I already have to download patches on the machine where I want
to apply them (no offline capability anymore), I can as well
get the patch list from a link on the netfilter.org site.
And if the linux machine has no network, I can simply download
the packages via the link on the netfilter.org site on another
machine.

Changing the name to pom-coreteam would give others the chance
to provide a package with the same features and same name as
the current pom-ng.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
