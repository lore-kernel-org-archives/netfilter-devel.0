From: Stephen Hemminger <shemminger@osdl.org>
Subject: Re: [PTCH 2.5.68] netfilter using Read Copy Update
Date: Mon, 28 Apr 2003 08:57:21 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428085721.15966de4.shemminger@osdl.org>
References: <20030427132413.GP990@sunbeam.de.gnumonks.org>
	<20030428062622.5F0FE2C4D3@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
   davem@redhat.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030428062622.5F0FE2C4D3@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 28 Apr 2003 14:24:30 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> In message <20030427132413.GP990@sunbeam.de.gnumonks.org> you write:
> > 
> > --K0mDTbuGRobClnW5
> > Content-Type: text/plain; charset=us-ascii
> > Content-Disposition: inline
> > Content-Transfer-Encoding: quoted-printable
> > 
> > On Thu, Apr 24, 2003 at 09:04:06AM -0700, Stephen Hemminger wrote:
> > > This is an update to netfilter core that uses the read-copy-update
> > > instead of brlock.  The code is similar to my earlier patch but less
> > > invasive.
> > 
> > I will try to review this patch and eventually push it to David Miller.
> 
> There is a fundamental flaw in the nf_reinject code: when a packet is
> reinjected, it makes an attempt to figure out if the hook which sent
> it to queue in the first place has vanished, and if so it drops the
> packet.
> 
> Of course, this is racy (it compares nf_hook_ops addresses) but
> "mostly works".  The best solution is to hold a reference to the hook
> so it can't vanish.
> 
> Stephen, it should be simple for you to rework your patch on top of
> this one.
> 

Okay, that makes sense.
