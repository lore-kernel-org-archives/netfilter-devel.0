From: Peter Stamfest <peter@stamfest.at>
Subject: Re: question for (existing?) feature
Date: Sun, 23 Mar 2003 20:43:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0303232038100.2375-100000@peter.stamf.pr.at>
References: <2405.1047904769@frodo.gams.co.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <2405.1047904769@frodo.gams.co.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 17 Mar 2003, Bernd Petrovitsch wrote:

> "K. Posern" <k@posern.org> wrote:
> >Is there a possibility to provice a description to rule - which will be printe
> >d out with "iptables -L" or "iptables -L -v"???
> 
> Yes, just implement a comment field.

[snip]

> >    What are you thinking about it?
> 
> It is more than superflous (read: No, do not do it.). Reason: see 
> above.

I disagree. Eg. if you do accounting using iptables it is vital to be able
to identify the correct rule, regardless of possibly added or rearranged
rules. A comment field can provide for this quite nicely. Then you might 
implement accounting using bash + grep only.

You can't do that with a script containing the comments.

peter
