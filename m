From: Patrick McHardy <kaber@trash.net>
Subject: Re: news about retrieving kernel symbols (tasklist_struct)
Date: Mon, 25 Sep 2006 17:52:17 +0200
Message-ID: <4517FB31.6050407@trash.net>
References: <885896af0609250825k7d0afda9x50fbc8f8a9d73913@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
In-Reply-To: <885896af0609250825k7d0afda9x50fbc8f8a9d73913@mail.gmail.com>
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

Giacomo wrote:
> Good afternoon.
> As to the need to retrieve the symbol tasklist_lock, which is no more
> exported in kernel 2.6.18, i tried to use the

There is a reason why it is not exported anymore. You can't use
it from netfilter.
