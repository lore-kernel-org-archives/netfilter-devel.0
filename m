From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Bridging and IPT Queueing
Date: Tue, 13 Jul 2004 09:07:53 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407130903480.32118-100000@filer.marasystems.com>
References: <40F36523.6020302@metavize.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jim Mar <jmar@metavize.com>
In-Reply-To: <40F36523.6020302@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 12 Jul 2004, Jim Mar wrote:

> >>Yes, physdev match will work. Thanks. Using physdev match, can I get
> >>the physical indev for a redirected packet?
>
> Sorry, I meant from user space, and if so, how?

You can Use MARK to set a unique nfmark depending on the physdev and then
make decisions in userspace depending on this.

Regards
Henrik
