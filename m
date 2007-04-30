From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Unspecified proto should print as "all" in iptables -L
Date: Mon, 30 Apr 2007 13:09:30 -0700
Message-ID: <20070430200930.GA8187@linuxace.com>
References: <20070428220206.GA26272@linuxace.com>
	<463524E7.60107@netfilter.org>
	<Pine.LNX.4.61.0704301038100.22744@yvahk01.tjqt.qr>
	<20070430171317.GA6904@linuxace.com>
	<Pine.LNX.4.61.0704301924021.29151@yvahk01.tjqt.qr>
	<20070430173654.GB6904@linuxace.com>
	<web-70582235@bk1.webmaillogin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jorge Davila <davila@nicaraguaopensource.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <web-70582235@bk1.webmaillogin.com>
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

On Mon, Apr 30, 2007 at 12:17:13PM -0600, Jorge Davila wrote:
> I was trying to apply a rule
> 
> iptables -p 0 -j DROP
> 
> to block only the protocol 0. I know now why that rule was not working.
> 
> I think that -p 0 must be a reference to the protocol 0 and not to all 
> protocols.
> 
> Jorge.

Which application uses protocol 0?  Or is this a custom app you wrote?

Phil
