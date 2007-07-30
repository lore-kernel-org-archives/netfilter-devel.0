From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][netfilter] Avoid a possible NULL pointer deref in
	recent_seq_open()
Date: Mon, 30 Jul 2007 14:28:18 +0200
Message-ID: <46ADD962.4040700@trash.net>
References: <200707290308.45464.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Marc Boucher <marc@mbsi.ca>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	James Morris <jmorris@namei.org>, coreteam@netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: Jesper Juhl <jesper.juhl@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707290308.45464.jesper.juhl@gmail.com>
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

Jesper Juhl wrote:
> There is a small problem in
>  net/ipv4/netfilter/ipt_recent.c::recent_seq_open().
> 
> If the call to seq_open() returns != 0 then the code calls 
> kfree(st) but then on the very next line proceeds to 
> dereference the pointer - not good.


Applied, thanks Jesper.
