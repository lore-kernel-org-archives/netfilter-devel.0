From: Patrick McHardy <kaber@trash.net>
Subject: Re: The future of patch-o-matic-ng
Date: Thu, 06 Apr 2006 16:30:32 +0200
Message-ID: <44352608.7000509@trash.net>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>	<20060405152628.GI20558@sunbeam.de.gnumonks.org>	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>	<20060406073514.GE6887@sunbeam.de.gnumonks.org>	<4434CFBF.7030208@trash.net>	<Pine.LNX.4.64.0604061219580.18845@bizon.gios.gov.pl>	<20060406105350.GT6887@sunbeam.de.gnumonks.org>	<4435143E.3030700@gmx.net>
	<20060406131939.GA19216@oknodo.bof.de> <44351AB5.9090103@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>, Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <44351AB5.9090103@gmx.net>
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
> Yes. I always treated pom-ng as patch collection which is usable
> offline. With the proposed change, it becomes a mix of patch
> collection and patch list. Packaging a patch list doesn't make
> sense, but packaging a link to a package list makes sense. If
> I already have to download patches on the machine where I want
> to apply them (no offline capability anymore), I can as well
> get the patch list from a link on the netfilter.org site.
> And if the linux machine has no network, I can simply download
> the packages via the link on the netfilter.org site on another
> machine.
> 
> Changing the name to pom-coreteam would give others the chance
> to provide a package with the same features and same name as
> the current pom-ng.

I honestly don't care about the name at all, but I don't really
see the point. We're pushing the good stuff to the kernel,
which should benefit everyone. Old, broken and obscure patches
are moved out, as are patches that are not ready for mainline
where we don't have enough interest in getting them ready ourselves.
You are of course welcome to work on these patches to get them
mergable. Ideally we will just obsolete pom.
