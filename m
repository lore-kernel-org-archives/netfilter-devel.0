From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables denial of services
Date: Sat, 17 Apr 2004 18:49:12 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404171843020.22016-100000@filer.marasystems.com>
References: <4081114A.40808@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4081114A.40808@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Apr 2004, Friedrich Lobenstock wrote:

> What if the server you are talking about is a server farm? Then an iptables 
> gateway that does connection track on the way may as well "die" before the 
> servers "die" because of overload.

If you have a very large farm and does not tune conntrack accordingly then
yes this can happen. It will not die, but it may be the case that it does
not accept as many sessions as your server farm and thereby not allowing
the server farm to be fully utilized.

> Can you give some details about those limits? Are there any numbers 
> availabe that relate that to memory/cpu/....?

The default number of sessions is based on amount of memory but can
easily be tuned at boot time.. or even runtime but then with a slight
performance penalty.

http://www.netfilter.org/documentation/FAQ/netfilter-faq-3.html#ss3.7

Regards
Henrik
