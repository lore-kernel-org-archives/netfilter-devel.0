From: Mike Carlton <mikecarlton@gmail.com>
Subject: Re: About connbytes
Date: Thu, 18 Nov 2004 13:17:15 -0800
Message-ID: <f663f63604111813174cc28048@mail.gmail.com>
References: <419052E5.4080609@koba.com.ar>
	<20041109090422.GQ22257@sunbeam.de.gnumonks.org>
Reply-To: Mike Carlton <mikecarlton@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, "koba@koba.com.ar" <koba@koba.com.ar>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20041109090422.GQ22257@sunbeam.de.gnumonks.org>
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

I have the same problem with an outdated libopt_connbytes.c

The latest snapshot
ftp://ftp.netfilter.org/pub/iptables/snapshot/iptables-1.3.0-20041114.tar.bz2
as well as the most recent browsable version I can find
http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/trunk/iptables/extensions/libipt_connbytes.c?rev=3071&view=markup

are both old.  

Can you give us a link to the current subversion version you refer to?

Thanks,
--Mike Carlton


On Tue, 9 Nov 2004 10:04:22 +0100, Harald Welte <laforge@netfilter.org> wrote:
> On Tue, Nov 09, 2004 at 02:17:25AM -0300, koba@koba.com.ar wrote:
> > Hello,
> >       I've been trying to get the connbytes module working but apparently
> >       the CVS/SVN libipt_connbytes.c is outdated (for example it uses sinfo->from
> > instead of sinfo->count.from). If you've been mantaining it, can you
> > send me your latest version?
> 
> Which particular version of ipt_connbytes are you talking about?
> 
> at least the 2.6.x version from subversion appears to use 'count.from'
> consistently.
> 
> I don't have anything else than current subversion.
> 
> --
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
> 
> 
>
