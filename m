From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: iptables extensions
Date: Sun, 27 Apr 2003 08:03:51 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427150352.61643.qmail@web13904.mail.yahoo.com>
References: <20030427123927.GW990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030427123927.GW990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- Harald Welte <laforge@netfilter.org> wrote:
> On Wed, Apr 16, 2003 at 11:14:04AM -0700, Scott
> MacKay wrote:
> > Basically would do what print() does, but dump the
> > results into a character buffer, to
> examine/deliver in
> > a means other than printf().  
> 
> As the iptables userspace was not designed to be
> used (as a library) by
> other applications, there is no support for doing
> so.
> 
> With good luck, we will eventually see libiptables
> show up in the far
> future...

Understandable, though I would guess this kind of
extension would be more 'grunt work' (given that the
format & code behind the format is already done for
printf), needing only to have a generic-o safe buffer
filler and add in a new function for each of the
existing items already coded.  Since there is a good
chance that I will have a need for something like
this, my general preference to not have to re-code on
new releases and instead contribute something which
others may like, combined with my lack of experience
generating patchfiles, if I were to code this in would
there be any devel teamies that could review and
accept/reject it in the code base?

-Scott

__________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo.
http://search.yahoo.com
