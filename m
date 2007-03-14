From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 23:02:11 +0100
Message-ID: <45F870E3.6020805@trash.net>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
	<45F8637D.3060600@trash.net>
	<Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703142207180.1199@yvahk01.tjqt.qr>
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
> Right. Of course this is a problem. To that end, I can really only say
> that a divide needs to be made someday.

I totally disagree. iptables has tons of problems, I'm guessing that
a year from now we will have a successor. Breaking compatibility at
this point in its lifetime is not acceptable, especially on such a
fundamental level. I really wish people would stop wasteing time
trying to redesign iptables, its just not worth it.
