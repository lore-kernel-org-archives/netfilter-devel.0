From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] realm: fix inversion
Date: Wed, 22 Sep 2004 03:58:09 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4150DC31.4050807@trash.net>
References: <4150D9F8.7060600@parknet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Lodal <simonl@parknet.dk>
In-Reply-To: <4150D9F8.7060600@parknet.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Simon Lodal wrote:

>
> Make '--realm ! id' work as advertised.
> Make save() output inversion correctly so it can be parsed back in, 
> and work with iptables-restore and iptables-save.


Applied, thanks.

>
>
> Simon Lodal
