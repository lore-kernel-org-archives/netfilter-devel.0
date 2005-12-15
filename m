From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] Add sanity checkings for ICMP
Date: Thu, 15 Dec 2005 01:49:01 +0100
Message-ID: <43A0BD7D.20806@trash.net>
References: <4394229B.5030506@netfilter.org>
	<200512090240.jB92egAp002675@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512090240.jB92egAp002675@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> This checks ICMP type in tuple before putting it.
> And it's better to use invmap instead of valid_new to allow Echo reply and
> so on.
> 
> How about attached patch instead ?
> 
> [NETFILTER] ipctnetlink: Add sanity checkings for ICMP

Applied to my 2.6.16 queue, thanks.
