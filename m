From: "Gerd v. Egidy" <lists@egidy.de>
Subject: Re: condition and 2.6
Date: Sun, 29 Feb 2004 23:14:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402292314.03863.lists@egidy.de>
References: <200402290210.35962.lists@egidy.de> <200402291528.01679.lists@egidy.de> <20040229205626.GN15558@sunbeam.de.gnumonks.org>
Reply-To: gerd@egidy.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040229205626.GN15558@sunbeam.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > I don't mind that much about ruleset change speed. The different
> > conditions for my firewall are changed by different scripts and I can't
> > make sure that only one is running at a time. So I fear a race like this:
>
> Sorry, but I have a different view on this.  Problems that can be solved
> in userspace (like mutual exclusion of certain scripts running at the
> same time) should be implemented in userspace, rather than pushing
> kludges into the kernel.

That's right - or the kernel will get even more bloated than it already is.

> > As far as I understand the libiptc code, the result will be that the
> > changes done by program 1 will be lost. Is that correct or have I
> > misunderstood the code?
>
> No, this is true.
>
> > The condition module offers a lot more atomicity and I can be sure that
> > two scripts don't interfere with each other.
>
> While I understand this application, I doubt that this rectifies the
> race-prone uglyness of something like ipt_condition.
>
> Why don't you just use a lock file in all your scripts?  Create the lock
> file before you access iptables, and remove it after it has been
> accessed.  This kind of file-based locking works since good old UUCP
> times.

Ok, judging from Willys comment I'm not the only one with problems / worries 
like this. The problem concerns not only my scripts but all users of libiptc 
(neglecting programs that directly use the kernel interface). So why not fix 
it there?

I think of a lockfile (e.g. /var/run/libiptc.pid) which is created by the 
library in iptc_init and removed in iptc_commit. This way all programs using 
libiptc become safe at once.

Do you like this idea?

Kind regards,

Gerd
