From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: Thu, 13 Jun 2002 14:07:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206131407.39752@henrik.marasystems.com>
References: <1023365846.845.26.camel@tux> <1023873045.19812.95.camel@tux> <1023908549.19812.106.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1023908549.19812.106.camel@tux>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 12 June 2002 21:02, Martin Josefsson wrote:

> It adds a new parameter to ip_ct_refresh called force, if set to
> non-zero a timer update will be forced.

Hmm.. this may be a little hard to enforce at all times..

Why don't you make the filter simply filter out any timer updates that 
would increase the timer by less than HZ?

  change = new_interval - current_remaining_time

  if (change < 0 || change >= HZ)
     update the timer

Feels both cleaner and safer to me..

Regards
Henrik
