From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP window tracking patch status query for further design
 considerations
Date: Tue, 8 Oct 2002 12:17:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0210081210410.23021-100000@blackhole.kfki.hu>
References: <3DA1AE9E.6030106@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <3DA1AE9E.6030106@tac.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, 7 Oct 2002, Roberto Nibali wrote:

> Is/Are there any news about the possibly impaired functionality of the
> TCP window tracking patch? I recall the thread about the mailinglist
> problems where Harald concluded that it was this patch that caused
> headaches to several people trying to send emails to the netfilter
> lists. Has the problem been investigated any further or is the status
> still unclear?

The problem hasn't still been investigated. :-( I have been totally buried
with other tasks in the last weeks. :-((

I hope in this month I'll be able to run an excessive testing of the
delayed SMTP delivery caused by the patch and find the solution.

> Without this patch, netfilter is completely useless to us. Could
> someone please give me a status report of this patch? What about a
> possible inclusion into mainstream kernel (this question is important
> to our management to create appropriate SLAs)?

Even after the problem is fixed, some time will be required for further
testing the patch before considering submitting into the kernel. Also,
a decision will be required on the the proc interface of netfilter due to
the new level introduced by the patch.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
