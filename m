From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: 13 Jun 2002 18:17:41 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023985062.19816.368.camel@tux>
References: <1023365846.845.26.camel@tux> <1023873045.19812.95.camel@tux>
	<1023908549.19812.106.camel@tux>
	<200206131407.39752@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200206131407.39752@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 2002-06-13 at 14:07, Henrik Nordstrom wrote:
> On Wednesday 12 June 2002 21:02, Martin Josefsson wrote:
> 
> > It adds a new parameter to ip_ct_refresh called force, if set to
> > non-zero a timer update will be forced.
> 
> Hmm.. this may be a little hard to enforce at all times..
> 
> Why don't you make the filter simply filter out any timer updates that 
> would increase the timer by less than HZ?
> 
>   change = new_interval - current_remaining_time
> 
>   if (change < 0 || change >= HZ)
>      update the timer
> 
> Feels both cleaner and safer to me..

This sounds like a very good idea, it's a good thing I have you guys to
straighten me out :)

Will send new patch later this evening. And I'll even test it before
sending :)

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
