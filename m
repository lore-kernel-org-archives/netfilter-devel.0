From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that
 breaks routing?
Date: Tue, 28 Oct 2003 09:10:00 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310280908500.16516-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0310211141480.7787-100000@kinison.puremagic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evan Harris <eharris@puremagic.com>
In-Reply-To: <Pine.LNX.4.44.0310211141480.7787-100000@kinison.puremagic.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 21 Oct 2003, Evan Harris wrote:

> I am using a stock linux kernel 2.4.20, with iptables 1.2.8.  Please CC me,
> as I am not on the mailing list.

With or without applying the pending patch-o-matic patch set?

I would recommending grabbing a current iptables snapshot and then 
applying the pending patch set to your kernel.

Regards
Henrik
