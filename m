From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.12: connection tracking broken?
Date: Sat, 18 Jun 2005 18:16:15 +0100 (BST)
Message-ID: <20050618171615.66470.qmail@web52909.mail.yahoo.com>
References: <876ef97a05061808141d503f58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262158AbVFRRQX@vger.kernel.org>
To: Tobias DiPasquale <codeslinger@gmail.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <876ef97a05061808141d503f58@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--- Tobias DiPasquale <codeslinger@gmail.com> wrote:
> Did you have /proc/sys/net/ipv4/ip_forward turned on?

Yes, because otherwise it wouldn't work in 2.6.11.11 either. My userspace environment is identical
between 2.6.12 an 2.6.11.11, but the RELATED and ESTABLISHED packets aren't forwarded across the
bridge in 2.6.12.

And no, I haven't tried recompiling my userspace iptables tools. Why would this make any
difference? "iptables -L -v" reports exactly what I expect to see.

Cheers,
Chris



		
___________________________________________________________ 
How much free photo storage do you get? Store your holiday 
snaps for FREE with Yahoo! Photos http://uk.photos.yahoo.com
