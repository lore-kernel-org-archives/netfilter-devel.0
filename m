From: Patrick McHardy <kaber@trash.net>
Subject: Re: Maintenance for POM-ng modules
Date: Thu, 07 Dec 2006 04:08:28 +0100
Message-ID: <457785AC.6070105@trash.net>
References: <Pine.LNX.4.61.0612062122410.16042@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: kaber@netfilter.org,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0612062122410.16042@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> Hi,
> 
> connlimit:
> As of r6652, it has been moved to external. I would like to see it in 
> pomng again (or even mainline kernel).

IIRC it scans the conntrack table. This general opinion so far has
been that this should not be merged, but I'm personally not that
opposed since I don't really see a better way and the functionality
seems useful (and I don't really want to lecture people on whats bad
for them, it should just be documented).

> XOR:
> Removed as of r6598, reason: no maintainer. I am currently maintaining 
> it in private, just for the fun of it.

We definitely don't want to merge this :)

> unclean:
> Also deleted as of r6598. I would like to revive this module since it 
> will be useful to us.

This one is considered harmful by all netfilter developers and the
many bugs so far breaking totally legitimate behaviour proof this
right. This is also why it has been removed in 2.6.

> So, given this short summary, I would like to take these three projects 
> and bring them back into shape (they really don't need a lot fixing 
> AFAICT).
> What's the preferred procedure?

For patches that we don't want to merge but see some use in, an
external pom repository is prefered. Its basically a tar of the
patchlet directory with repository: changed to "external" in the
info file. So for the connlimit match feel free so send me a URL
for an external repository or convince me that it should be
merged, the others should probably just be deleted :)
