From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] Switch xt_target->checkentry to bool
Date: Mon, 04 Jun 2007 17:25:02 +0200
Message-ID: <46642ECE.1090402@trash.net>
References: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706041711020.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706041711020.20829@yvahk01.tjqt.qr>
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
> Switch the return type of target functions to boolean.

Its actually a shame that we don't return proper errno codes, but I
think that would seriously confuse iptables error messages, so applied.
Thanks Jan.
