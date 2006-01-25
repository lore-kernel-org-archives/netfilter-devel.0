From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] [NETFILTER] Fix CID offset bug in PPTP NAT helper
Date: Wed, 25 Jan 2006 09:47:27 +0100
Message-ID: <43D73B1F.8010103@trash.net>
References: <925A849792280C4E80C5461017A4B8A2031F1C@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A2031F1C@mail733.InfraSupportEtc.com>
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

Greg Scott wrote:
> I've always wondered - patches for modules in POM-NG are available right
> away with the next daily snapshot.  But the PPTP stuff is now in the
> mainline kernel.  Would this patch end up in one of the snapshot or rc
> releases on kernel.org, or are there updates to the 2.6.15.1 tree or how
> does that work?  Or would the most up to date PPTP stuff still be in
> POM-NG?

No, the PPtP patch in pomng is not updated anymore, just the version
in the kernel.
