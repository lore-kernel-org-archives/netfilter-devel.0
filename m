From: Eicke Friedrich <tady@gmx.net>
Subject: Re: Can it realize that redirect  on  Brige?!
Date: Mon, 19 May 2003 15:11:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EC8D81F.3020508@gmx.net>
References: <000d01c31dbc$67773a70$5b01aa0a@Dec0y>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dec0y <anti_decoy@sina.com>
In-Reply-To: <000d01c31dbc$67773a70$5b01aa0a@Dec0y>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dec0y wrote:
> iptables -t nat -A PREROUTING -j REDIRECT --to  1080
> my kernel panic!
try iptables -t mangle instat of nat because normally you don't use
nat on a bridge.
Hope that helps.


Eicke.
