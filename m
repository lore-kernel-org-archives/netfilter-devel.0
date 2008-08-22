From: "jon hale" <jon.h.hale@gmail.com>
Subject: Does policy routing based on owner-gid really work?
Date: Fri, 22 Aug 2008 16:38:54 -0700
Message-ID: <abe9c56e0808221638m35d2af7bu3535099e55e6c786@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:19019 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYHVXiz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2008 19:38:55 -0400
Received: by py-out-1112.google.com with SMTP id p76so484656pyb.10
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2008 16:38:54 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have a problem when I combine owner-gid, fwmark, and iproute2.
I am starting to wonder if I can really get there from here.

Synopsis:
       I have been trying to set up policy routing based upon the group id
       of the process sending the packets.

       It works for most packets, but there is some scenario that happens at
       the end of every ftp upload, where the packet goes out the wrong
       interface and gums up the works.

       I am doing this using iptables and iproute2 features. When I change
       my iptables fwmark rule from marking gid-owner packets to marking
       packets based on their destination address it all works fine.

Details:
       in /etc/iproute2/rt_table I added a table p0

       I added a rule (with ip ru add) "from all fwmark 0x1 lookup p0"

       I bring up my ppp daemon and I get the following address
       (from ip addr sh ppp0):
                inet 70.223.3.172 peer 66.174.168.192/32 scope global ppp0

       I create the entries for table p0:
               TARGETIP dev ppp0  scope link
               default via 66.174.168.192 dev ppp0  src 70.223.3.172
       I take the ppp0 default rule out of table main.

       I added some iptables rules:
               iptables -t mangle -A OUTPUT -m mark ! --mark 0 -j ACCEPT
               iptables -t mangle -A OUTPUT -m mark    \
                       --mark 0 -m owner --gid-owner $GROUP_0 -j MARK \
                       --set-mark 0x1
               iptables -t mangle -A OUTPUT -j CONNMARK --save-mark
               iptables -t nat -A POSTROUTING -o ppp0 -j SNAT \
                       --to-source 70.223.3.172
       I then flush the route cache (ip route flush cache)

       Now I run ftp and upload a file. Ouch! A few of the packets go out
       my eth0 interface.

Interesting facts:
       I can successfully upload a file up to size 4344 bytes. When I try using
       a file of size 4345 bytes. Things go bad. 4344 is interesting because
       this is three times the tcp payload of one packet.

       If I change the  --set-mark rule above to :
               iptables -t mangle -A OUTPUT -d $TARGET -j MARK --set-mark 0x1
       Then everything works fine. But this will not accomplish my larger goal.
       My larger goal is having two processes owned by the same user, but in
       different groups to be able to have packets to $TARGET take different
       routes.

       If I change the --set-mark rule above to match on the uid instead of
       the gid, I still have the same problem.

Versions of things:
       #ip -V
               ip utility, iproute2-ss070313
       #iptables -V
               iptables v1.3.7
       #linux kernel  2.6.22.9 WITHOUT SMP

I need a clue.
Or maybe just help understanding the clues that I do have.
Thank you,
-jon
