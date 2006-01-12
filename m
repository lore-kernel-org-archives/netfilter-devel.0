From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: iptables 1.3.4 kernel 2.4.31 string match
Date: Thu, 12 Jan 2006 12:29:37 +0100
Message-ID: <43C63DA1.8040601@eurodev.net>
References: <1136294032.43ba78906f44c@imp4-g19.free.fr>
	<43BBFBC8.7010604@eurodev.net>
	<0ba501c61620$d8c547d0$f9b5a8c0@pii350>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gilles Espinasse <g.esp@free.fr>
In-Reply-To: <0ba501c61620$d8c547d0$f9b5a8c0@pii350>
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

Gilles Espinasse wrote:
> I don't attempt to use the new 'string' code on kernel-2.4.
> I just find better to use the previous 'string' version than not be able to
> use iptables-1.3.4 with 2.4 kernel

OK, but the previous code computes the Boyer-Moore shift arrays
everytime a packet is processed. So I doubt about the benefits of such
approach. I warned you.

Amicalement,

-- 
Pablo
