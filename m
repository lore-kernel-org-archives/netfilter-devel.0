From: "Gerd v. Egidy" <lists@egidy.de>
Subject: Re: condition and 2.6
Date: Sun, 29 Feb 2004 15:28:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402291528.01679.lists@egidy.de>
References: <200402290210.35962.lists@egidy.de> <20040229110711.GJ7790@sunbeam.de.gnumonks.org>
Reply-To: gerd@egidy.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20040229110711.GJ7790@sunbeam.de.gnumonks.org>
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

> This comment is meant as:
>
> "Since nobody provided us with a 2.6.x port yet, and I have very limited
> time for such porting, and I personnaly dislike the condition match
> anyway, I marked it as 2.4.x only - since the 2.4.x patch doesn't work
> for 2.6.x"

Thank you for the clarification.

> > What do you dislike? Is it the idea or the implementation? Do you know of
> > any bugs or possible problems in the code - especially with 2.6?
>
> The idea of having /proc files control how the ruleset behaves.  This is
> an ugly kludge for our less-than-optimal ruleset change performance.
> Apart from that I cannot really see why this has to be solved in the
> kernel and not by some userspace daemon that updates the ruleset
> whenever a change is needed.

I don't mind that much about ruleset change speed. The different conditions 
for my firewall are changed by different scripts and I can't make sure that 
only one is running at a time. So I fear a race like this:

Program 1: iptc_init
Program 2: iptc_init
Program 1: modify rule A
Program 2: modify rule B
Program 1: iptc_commit
Program 2: iptc_commit

As far as I understand the libiptc code, the result will be that the changes 
done by program 1 will be lost. Is that correct or have I misunderstood the 
code?

The condition module offers a lot more atomicity and I can be sure that two 
scripts don't interfere with each other.

Kind regards,

Gerd
