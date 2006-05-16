From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Integrating SIP-conntrack feature problems
Date: Tue, 16 May 2006 12:07:18 +0100
Message-ID: <4469B266.7070401@ufomechanic.net>
References: <8406.07320792532$1147770545@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <8406.07320792532$1147770545@news.gmane.org>
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

free wrote:
> hi all
> 
>   I now working in integrate SIP-conntrack feature in our system.The patch require that kernel should at least be 2.6.11,but our system using 2.6.8.
>   Is is possible to integrate without upgrading the kernel to 2.6.11,if possible,Cound you give some advice on how to do it?

The procedure is not simple, and neither is checking that you have done
it right. Depending on your needs it may be simpler to just upgrade your
kernel.

You see; patches are sent because something is wrong, or needs
improving, or new features need adding. To use this sip feature you need
to bring accross fixes and features that it needs, you can skip
improvemnts, and skip fixes and features that it doesn't need, but you
need to identify them.

First; you need to look at the release date of your current kernel.
Then you need to look at all postings to this list since that date (and
a while before) and check for

1. posts about sip-conntrack
2. posts about things that sip-conntrack depends on (like conntrack)

You need to be fully aware of the code that was sent, and try and work
out the intention behind the poster; i.e. what was it they were trying
to fix, and in what way does that relate to this sip-conntrack stuff.

Then you have to decide which patches you may need to pull in

you can also try and apply the patch and see which files it fails on,
and repeat the above procedures in looking for information and changes
relating to those files.

Then you can get confidence that the patch you apply may work with the
additional patches you selected.

You patch, build, and better have some test cases to prove it works.

It may be simpler to diff between the two kernel versions and look at
those changes, isolate them as functional units and decide which ones to
keep and which ones to drop.

Sam
