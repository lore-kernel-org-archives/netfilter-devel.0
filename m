From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] peer_pid checking in ip_queue
Date: Wed, 24 Mar 2004 01:07:59 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403240106490.15222-100000@filer.marasystems.com>
References: <4060BDBF.8050407@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>, <netfilter-devel@lists.netfilter.org>,
   Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4060BDBF.8050407@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 23 Mar 2004, Patrick McHardy wrote:

> It can happen if peer_pid is checked outside the locked section on one
> CPU and changed on another at the same time. I don't consider it
> important, as the exact point in time at which the first packet will be
> received is non-deterministic for userspace anyway.

What about when the user program closes? How bad it is to have read the 
pid and then there is no userspace there?

Regards
Henrik
