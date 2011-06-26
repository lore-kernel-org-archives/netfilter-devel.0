From: Dave Taht <dave.taht@gmail.com>
Subject: Fwd: more grokking of iptables, qdiscs, filters, etc
Date: Sun, 26 Jun 2011 07:15:12 -0600
Message-ID: <BANLkTimWwjhVLjeBbc=Eb5pUnAyx3vMkqA@mail.gmail.com>
References: <BANLkTikqCM6=3AVU4-fFqxQDn3ef9RmG0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55697 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1FZNPS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Jun 2011 09:15:18 -0400
Received: by iyb12 with SMTP id 12so3438003iyb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jun 2011 06:15:18 -0700 (PDT)
In-Reply-To: <BANLkTikqCM6=3AVU4-fFqxQDn3ef9RmG0A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I decided enough of this was netfilter related to also send to this
list, in addition to the bloat list. Sorry for the duplication for
those that are on both lists.


---------- Forwarded message ----------
=46rom: Dave Taht <dave.taht@gmail.com>
Date: Sun, Jun 26, 2011 at 6:58 AM
Subject: more grokking of iptables, qdiscs, filters, etc
To: bloat <bloat@lists.bufferbloat.net>


As I continue to fiddle with deeply understanding one entirely open
source router[1] in the context of bufferbloat by running tons of
wildly varied traffic through it...

I could be filing individual bug reports in the right places or the
right mailing list, or (preferably) writing something other than test
code, but having an overview is important.

I'm very glad we have representatives from many different areas of
expertise here, so I'm writing these notes in the hope that eventually
they will get to the right people, and if they don't, we've got a
public record to work from while we dig into other stuff.

Previous email threads in this series have been very productive thus
far [2] [3].

So on to the results of last week's hacking! I spent half of my time
tracking down some issues in local multicast and link state detection
which I'm not prepared to talk about today...

I fiddled with iptables, tc, cerowrt, and a bunch of wireless devices.

I picked on iptables last week [5] *not* because it was the right
thing but because it was the easiest thing. To finish that up
somewhat:

A) Iptables

A1) Iptables cannot do multi-protocol matching in one rule. If you
want to allow icmp,tcp,udp,ah,esp,ipv6,sctp,pim,ipip,ospf,gre,rsvp,l2tp
& hip (just to list a few interesting ones from /etc/protocols)

You need to do each one in a separate rule. 256 bits would suffice to
be able to match a set of them in one rule.

Although Linux is a hotbed of research into new, interesting
protocols, it's hard to use them if they are blocked by default,
everywhere.

Being able to deal with more set-like operations such as multiprotocol
matches or comprehensive classification into diffserv [4] falls into a
critical gap between the current single matches, more complex
or/and/xor u32 operations, and ipset, in the iptables architecture. I
note that syntactically the existing --protocol userspace match could
transparently also do multiprotocol matching.

A2) iptables has the ability to do a string pattern match, using the +
syntax to match one or more devices. e.g. eth+ matches all ethernet
devices.

If more comprehensively used, potentially this would simplify mapping
firewall 'zones' to actual rules, which I'll talk to in a second, once
I get done with the one liners.

A3) Hotplug2 (which is used in openwrt) doesn't appear to have a way
to do persistent device renaming for ethernet devices. (Wlans get
renamed differently). Udev does it great, but is not currently in use
there.

B) TC

After at least temporarily abandoning the Diffserv effort [4] [5], I
went poking into tc... I took a leap into the dark corners of the
qdiscs and tc filters.

B1) The topmost example on google for a tc tos match, matches against
all 8 bits in the field, and will fail when ecn is applied [8]. 'tos'
in tc is an alias for the entire 8 bit field. It could do more of the
right thing if it excluded the ECN bits, but kept the 8 bitness,
without breaking userspace.

B2) I had no idea of the extent of em_meta.c, it can do some
interesting stuff. It doesn't have ecn, or dscp matches, but looks
like a good substrate for stuff like this

C) Wireless and vlan interactions with qdiscs

C1) Wireless lans have added the ability to have multiple networks
(SSIDs) and devices show up. However once you do that, the fact that
you only have X bandwidth available, total, for all those devices, on
one radio, disappears. I haven't found an easy way to determine what
devices belong to one radio. While I've walked down the /sys/class/net
hierarchy, and fiddled with iw somewhat... Perhaps it exists
somewhere.

Regardless...

If you want to be able to balance traffic appearing across multiple
interfaces to one radio using some combination of qdiscs, this is a
problem as tc assumes a device is a device.

The same problem may apply also to vlans.

There appears to be a way to use IFB to actually group together
traffic across devices [7] using the mirror target but it's pretty
hacky.

C2) The vlan.c code treats skb->priority << 13 as being special for 802=
1q
=A0 =A0Mac80211 treats skb->priority 256 + [0-7] as being special 802.1=
1e

C3) tc doesn't grok the iptables + syntax

D) Some ideas

I spent some time breaking with convention for device naming. Networks
and network interfaces are usually divided into zones - one or secure
zones, a dmz, guest zones, and outgoing interfaces. So I thought I
could simplify some firewall rules greatly by using comprehensive
device renaming and the whatever+ syntax to make rule generation
easier (if considerably less end-user friendly)

So I sat down and wrote up a little specification for myself to play
with, to see if it helped in writing better rules across more
devices...

n[s|g|d][e|w][0-9]
n: network
s: secure
g: guest (or out to the wan)
d: dmz
e: ethernet
w: wireless
0-9 device number.

And it indeed, it seems to help somewhat, when you have > 3 interfaces
to deal with, (I have 7), you can setup rules for ns+, ng+ which in
general tend to be long, complex and tricky...

But I haven't really got much further than just fiddling with the
concept and without comprehensive device renaming it can't work, and
it would be better if I could do n?e+, or something like that...

# This worked better when I had 'wlans' and 'eths'
# But I note this is straightforward, Writing good firewall
# rather than classification rules is made easier by the ns+ concept...

iptables -A POSTROUTING -o nse+ -g MAC8021d_CLASSIFIER
iptables -A POSTROUTING -o nsw+ -g MAC80211e_CLASSIFIER
iptables -A POSTROUTING -o nge+ -g MAC8021d_CLASSIFIER
iptables -A POSTROUTING -o ngw+ -g MAC80211e_CLASSIFIER

E) Futures

I'm working very hard on getting a usable (by others) version of
cerowrt done, at least for alpha testing by the end of this week.
There are only about 9 outstanding major bugs right now... down from
12.


1: http://www.bufferbloat.net/projects/cerowrt
2: https://lists.bufferbloat.net/pipermail/bloat/2011-June/000555.html
=A0 https://lists.bufferbloat.net/pipermail/bloat/2011-June/000568.html
=A0 which ultimately forked off into bloat-devel, establishing the
concept of 'ANTS':
3:
https://lists.bufferbloat.net/pipermail/bloat-devel/2011-June/000173.ht=
ml
https://lists.bufferbloat.net/pipermail/bloat-devel/2011-June/000175.ht=
ml

4: =A0https://github.com/dtaht/Diffserv
5: =A0http://www.bufferbloat.net/projects/bloat/wiki/RFC_Improving_DSCP=
_support_in_Linux
6: there is nooo.... 6!
7: http://www.linuxfoundation.org/collaborate/workgroups/networking/ifb
8: From: http://lartc.org/howto/lartc.cookbook.ultimate-tc.html

# TOS Minimum Delay (ssh, NOT scp) in 1:10:
tc filter add dev nse1 parent 1:0 protocol ip prio 10 u32 \
=A0 =A0 =A0match ip tos 0x10 0xff =A0flowid 1:10


tc filter show dev nse1
filter parent 1: protocol ip pref 10 u32
filter parent 1: protocol ip pref 10 u32 fh 800: ht divisor 1
filter parent 1: protocol ip pref 10 u32 fh 800::800 order 2048 key ht
800 bkt 0 flowid 1:10
=A0match 00100000/00ff0000 at 0
filter parent 1: protocol ip pref 10 u32 fh 800::801 order 2049 key ht
800 bkt 0 flowid 1:10
=A0match 00010000/00ff0000 at 8
filter parent 1: protocol ip pref 10 u32 fh 800::802 order 2050 key ht
800 bkt 0 flowid 1:10
=A0match 00060000/00ff0000 at 8
=A0match 05000000/0f00ffc0 at 0
=A0match 00100000/00ff0000 at 32


--
Dave T=E4ht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://the-edge.blogspot.com



--=20
Dave T=E4ht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://the-edge.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
