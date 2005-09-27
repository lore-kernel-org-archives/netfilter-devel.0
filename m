From: Bernardo Innocenti <bernie@develer.com>
Subject: Re: Intermittent NAT failure when multiple hosts send UDP packets
Date: Tue, 27 Sep 2005 23:00:35 +0200
Message-ID: <4339B2F3.5040206@develer.com>
References: <432B8702.3060801@develer.com> <432CD386.201@develer.com> <43306484.2060103@develer.com> <43307BDC.8060602@trash.net> <4330A51D.20009@develer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	lkml <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965073AbVI0VA5@vger.kernel.org>
To: Bernardo Innocenti <bernie@develer.com>
In-Reply-To: <4330A51D.20009@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Bernardo Innocenti wrote:
> Patrick McHardy wrote:
>>Bernardo Innocenti wrote:
>>
>>>It's quite hard to trigger, but after it does, packets
>>>are consistently routed with the source IP untranslated.
>>
>>Please try "echo 255 >
>>/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid"
>>and modprobe ipt_LOG to see if conntrack ignores them because
>>of invalid checksums or something.
> 
> It doesn't seem to be the case.  I only see a few occasional
> errors, probably caused by miserable hosts crawling with worms:


PROBLEM SOLVED!  I'm glad to say It's *almost* not a kernel bug,
more like a missing feature.


In my ip-up.local script, I do:

        echo "Loading NAT modules:"
        /sbin/modprobe ip_conntrack
        /sbin/modprobe ip_conntrack_ftp
        /sbin/modprobe ip_conntrack_irc
        /sbin/modprobe iptable_nat
        /sbin/modprobe ip_nat_ftp
        /sbin/modprobe ip_nat_irc

	[...several filtering and QoS rules...]

	$iptab -A POSTROUTING -t nat -o $IFNAME -j SNAT --to-source $IPLOCAL


My ip-down.local attempts to do the opposite:

        echo "Flushing all current rules:"
        $iptab -F
        $iptab -F -t nat
        echo "Clearing all chains:"
        $iptab -X
        $iptab -Z
        $iptab -X -t nat
        $iptab -Z -t nat

        echo "Removing NAT modules:"
        /sbin/rmmod ip_nat_ftp ip_nat_irc iptable_nat ip_conntrack ip_conntrack_ftp ip_conntrack_irc


Note the order of the modules in the last line: ip_conntrack cannot
be unloaded because it's still being used by ip_conntrack_ftp and
ip_conntrack_irc.

So, whenever the PPP link goes down, ip_conntrack remains loaded with
all connections still being tracked until the timer expires!

If ppp0 goes up again soon enough, the script reloads the ip_nat modules,
but the existing connections are no longer being translated.

Would it be possible to do something at module initialization time
to recover those connections?  Meanwhile, I've fixed my rmmod to make
sure ip_conntrack really gets unloaded.

-- 
  // Bernardo Innocenti - Develer S.r.l., R&D dept.
\X/  http://www.develer.com/
