From: Patrick McHardy <kaber@trash.net>
Subject: Re: The future of patch-o-matic-ng
Date: Thu, 06 Apr 2006 16:23:36 +0200
Message-ID: <44352468.5010505@trash.net>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>	<20060405152628.GI20558@sunbeam.de.gnumonks.org>	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>	<20060406073514.GE6887@sunbeam.de.gnumonks.org>	<4434CFBF.7030208@trash.net>	<Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>
	<20060406105350.GT6887@sunbeam.de.gnumonks.org>
	<4435143E.3030700@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <4435143E.3030700@gmx.net>
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

Carl-Daniel Hailfinger wrote:
> Harald Welte schrieb:
> 
>>On Thu, Apr 06, 2006 at 12:34:21PM +0200, Krzysztof Oledzki wrote:
>>
>>
>>>So, this external repository will be used only by netfilter server to
>>>download patchlets? People will be still able to download complete
>>>pom-ng package? 
>>
>>No, users will actually only download 
> 
> 
> And exactly that's the problem with the proposed change. The value
> of pom-ng was not a central list of patches (I can always get that
> from the netfilter web site), but the packaged collection.

You can always do "runme --download" and you have the packaged
collection. We could also start doing two releases, one with
only patches maintained by the netfilter team and one with
all the patches.

> So if you really don't want to package patches from other sources
> anymore, please be honest and call the new package pom-coreteam
> or something like that.

Whats the point? We _do_ include other patches, just not every
random crap.
