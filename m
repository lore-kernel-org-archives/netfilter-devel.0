From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Thu, 30 Jun 2005 23:30:57 +0200
Message-ID: <42C46491.8090609@trash.net>
References: <42C03F2E.30706@eurodev.net>
	<42C0806E.3010400@trash.net>	<20050628071308.GE13239@sunbeam.de.gnumonks.org>	<42C1747A.3010703@trash.net>
	<42C2F2DF.7070301@eurodev.net>	<42C2FC14.80609@trash.net>
	<20050629201625.GY25641@sunbeam.de.gnumonks.org>
	<42C33C56.10708@eurodev.net> <42C34290.6090305@trash.net>
	<42C3BFAF.7040900@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42C3BFAF.7040900@eurodev.net>
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

Pablo Neira wrote:
> So, should be a netlink function to check if there are currently
> listeners worth it?

That sounds fine. Messages should then only be built if there is
a listener for this group or if it is a reply to a unicast request.
BTW, I noticed nfnetlink_send is always called with pid = 0 and
echo = 0. This needs to be fixed, whenever anything happens in response
to a request the correct pid and echo = 1 need to be used.

Regards
Patrick
