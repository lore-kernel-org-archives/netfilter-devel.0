From: Patrick McHardy <kaber@trash.net>
Subject: Re: Intermittent NAT failure when multiple hosts send UDP packets
Date: Tue, 20 Sep 2005 23:15:08 +0200
Message-ID: <43307BDC.8060602@trash.net>
References: <432B8702.3060801@develer.com> <432CD386.201@develer.com> <43306484.2060103@develer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel@vger.kernel.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965124AbVITVPJ@vger.kernel.org>
To: Bernardo Innocenti <bernie@develer.com>
In-Reply-To: <43306484.2060103@develer.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Bernardo Innocenti wrote:
> I'm sorry to say that this bug has shown up again on
> 2.6.13 too, so it's not fixed at all.
> 
> It's quite hard to trigger, but after it does, packets
> are consistently routed with the source IP untranslated.

Please try "echo 255 >
/proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid"
and modprobe ipt_LOG to see if conntrack ignores them because
of invalid checksums or something.
