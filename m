From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: raw/NOTRACK + TARPIT = good idea?
Date: Tue, 2 Dec 2003 10:13:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312020944470.23251-100000@filer.marasystems.com>
References: <14014030.1070339924765.JavaMail.Administrator@pumbaa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: IP v6 <inet6@mail.be>
In-Reply-To: <14014030.1070339924765.JavaMail.Administrator@pumbaa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2 Dec 2003, IP v6 wrote:

> I would like to do this also but I don't quite understand what you mean
> with "take care both directions for the tarpitted sessions".

What I think Harald is saying is that you need to NOTRACK packets in both
directions of the TARPIT:ed sessions.  If not conntrack might pick up the
session on the first faked reply packet sent by TARPIT.

But then this does not seem to be the case. It seems TARPIT sends the
reply packets directly to the network interface bypassing the netfilter
hooks, so this does not seem to be needed.

Regards
Henrik
