From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: QUEUE target and IPT_CONTINUE verdict ?
Date: Mon, 16 May 2005 08:52:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0505160849470.14981@filer.marasystems.com>
References: <200505131729.39430.laurent.guyon@adelux.fr>
	<876ef97a05051510053c6827c2@mail.gmail.com>
	<Pine.LNX.4.61.0505152244290.28907@filer.marasystems.com>
	<876ef97a05051515127fbbf066@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a05051515127fbbf066@mail.gmail.com>
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

On Sun, 15 May 2005, Tobias DiPasquale wrote:

> Is this also the reason that there can be only one ip_queue handler at a time?

Yes, or no depending on how you want to use the ip_queue handlers..

If you want different rules to reach different queue handlers then yes.

If you simply want the packet to call both handlers then no, but as this 
generally can be implemented just fine in userspace it is not considered 
important to implement.

Why do you want more than one ip_queue handler, and how?

Regards
Henrik
