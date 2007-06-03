From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] xt_connlimit (kernel) - connection limiting
Date: Sun, 03 Jun 2007 19:34:46 +0200
Message-ID: <4662FBB6.9060000@trash.net>
References: <Pine.LNX.4.61.0706031248290.10578@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706031312450.10578@yvahk01.tjqt.qr>
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
> Adds the connlimit match that has been in POM-NG for a long time.


This has about half the points I mentioned last time unfixed,
starting with proper use of list.h.
