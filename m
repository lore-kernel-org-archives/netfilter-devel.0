From: udo <udovdh@yahoo.com>
Subject: Re: more about martians
Date: Wed, 21 Apr 2004 20:32:42 -0700 (PDT)
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20040422033242.86850.qmail@web40706.mail.yahoo.com>
References: <Pine.LNX.4.44.0404220240150.27078-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404220240150.27078-100000@filer.marasystems.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

--- Henrik Nordstrom <hno@marasystems.com> wrote:
> On Tue, 20 Apr 2004, udo wrote:
> 
> > As a follow up on my post about portforwarding to
> > 127.0.0.1 and the 'martian destination 127.0.0.1'
> > message I can tell I found the probable cause in
> > /usr/src/linux/net/ipv4/route.c.
> 
> Why do you want to forward to 127.0.0.1? Why not a
> global IP?

I only want to offer ssh to the outside world (lan and
wan) on port 22 while still being able to run sshd at
non-root privs.
Say port 2222 for non-root reasons but port 2222 must
not interfere and best not be visible to the outside
world.

> The loopback addresses (127.X/8) are handled very
> special.

I found out.
Why?
It's just another interface.
I would like to use the lo interface because it is
hidden for the outside world, so a sshd at 2222
listening there is no problem.

Kind regards,
Udo


	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
