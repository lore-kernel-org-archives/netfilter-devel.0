From: Internet Protocol version Six <inet6@mail.be>
Subject: Re: --reject-with admin-prohib not working
Date: Thu, 31 Jul 2003 03:48:46 +0200 (GMT+02:00)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <563371376.1059616126453.JavaMail.Administrator@pumbaa>
References: <20030730140214.GA4553@sunbeam.de.gnumonks.org>
Reply-To: Internet Protocol version Six <inet6@mail.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20030730140214.GA4553@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Works great, thanks :)

> ----------------------------------------
> From: Harald Welte <laforge@netfilter.org>
> Sent: Wed Jul 30 16:02:14 GMT+02:00 2003
> To: Internet Protocol version Six <inet6@mail.be>
> Subject: Re: --reject-with admin-prohib not working
> 
> 
> On Sat, Jul 26, 2003 at 12:15:22AM +0200, Internet Protocol version Six wrote:
> > Hello all,
> > 
> > like the subject says, it is not working for me, I applied the PoM
> > patch to the kernel, compiled the kernel, even recompiled iptables and
> > it still gives me "iptables v1.2.8: unknown reject type
> > `admin-prohib'"
> 
> just use iptables from CVS.  I should do a 1.2.9 release, if only for
> this issue.
> 
> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie

-----------------------------------------------------
Mail.be, WebMail and Virtual Office
http://www.mail.be
