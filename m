From: Olaf Kirch <okir@suse.de>
Subject: (usagi-users 02866) Re: ip6t_REJECT dst underflow
Date: Fri, 26 Mar 2004 10:08:59 +0100
Message-ID: <20040326090859.GB671@suse.de>
References: <20040325134340.GC8500@suse.de> <200403260726.QAA02087@toshiba.co.jp>
Reply-To: usagi-users@linux-ipv6.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: netfilter-devel@lists.netfilter.org, usagi-users@linux-ipv6.org
Return-path: <usagi-users-admin@linux-ipv6.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200403260726.QAA02087@toshiba.co.jp>
Content-Disposition: inline
List-Software: fml [fml 4.0.3 release (20011202/4.0.3)]
List-Post: <mailto:usagi-users@linux-ipv6.org>
List-Owner: <mailto:usagi-users-admin@linux-ipv6.org>
List-Help: <mailto:usagi-users-ctl@linux-ipv6.org?body=help>
List-Unsubscribe: <mailto:usagi-users-ctl@linux-ipv6.org?body=unsubscribe>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 26, 2004 at 04:25:32PM +0900, Yasuyuki Kozakai wrote:
> I think this patch is for ip6t_REJECT in USAGI kernel (linux 2.6.x), right ?
> I applied your patch to USAGI tree.

Right. I thought this stuff originated from netfilter.org, however,
which is why I cc'ed netfilter-devel.  If that's not the case, sorry
for the noise.

Olaf

> 
> Thank you for your report.
> 
> From: Olaf Kirch <okir@suse.de>
> Date: Thu, 25 Mar 2004 14:43:40 +0100
> 
> > Hi,
> > 
> > the ip6t_REJECT module currently produces dst underruns when used.
> > The problem is that it assigns the dst pointer to the new skb without
> > bumping its reference count. The attached patch fixes this.
> > 
> > A second issue I came across isn't really a bug but more of
> > a minor nuisance.
> > 
> > When I configured ip6t_REJECT to reject packets to ::1 and then pinged
> > ::1, I would get in my syslog
> > 
> > 	Mar 25 14:16:05 hammer kernel: printk: 2 messages suppressed.
> > 
> > without telling me what message got suppressed. The problem is that the
> > code does the following in two locations:
> > 
> > 	if (net_ratelimit())
> > 		DEBUGP(....)
> > 
> > So with debugging off, all you get is the above mentioned messages
> > from net_ratelimit but nothing else. Either the DEBUGP needs to be
> > converted to a printk, or the entire if() statement needs to be
> > enclosed in an #if/#endif pair.
> > 
> > Olaf
> > -- 
> > Olaf Kirch     |  Stop wasting entropy - start using predictable
> > okir@suse.de   |  tempfile names today!
> > ---------------+ 
> 
> -----------------------------------------------------------------
> Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

-- 
Olaf Kirch     |  Stop wasting entropy - start using predictable
okir@suse.de   |  tempfile names today!
---------------+ 
