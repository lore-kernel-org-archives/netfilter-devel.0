From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] Accept named realm
Date: Wed, 24 May 2006 18:06:23 +0200
Message-ID: <4474847F.9060407@trash.net>
References: <200605211813.21301.simonl@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <200605211813.21301.simonl@parknet.dk>
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

Simon Lodal wrote:
> Make the realm match accept named realms, defined in /etc/iproute2/rt_realms.

I think this is a good idea, but it should also show realm names when
listing without -n. For that it makes little sense to read in the
realms file once for each rule shown, so you should keep a map of
realm->name values. I actually had a patch to do exactly that long
ago, but I lost it.
