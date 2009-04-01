From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] conntrack-tools 0.9.12 released
Date: Wed, 01 Apr 2009 14:23:21 +0200
Message-ID: <49D35CB9.2070905@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000701020408040903050301"
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60137 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751451AbZDAMYB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:24:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000701020408040903050301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project presents another development release of the
conntrack-tools that includes a new `-S' option for the command line
tool, and a generic infrastructure to allow using different protocols to
replicate state-changes, currently unicast UDP and multicast are supported.

= command line interface: conntrack =

* Add `-S' option to display in-kernel connection tracking system
statistics in a more human-friendly way (instead of cat'ting
/proc/net/stat/nf_conntrack):

# conntrack -S
entries                 9
searched                22
found                   98143
new                     1844
invalid                 2
ignore                  120
delete                  1872
delete_list             1144
insert                  1116
insert_failed           0
drop                    0
early_drop              0
icmp_error              0
expect_new              0
expect_create           0
expect_delete           0

= userspace daemon: conntrackd =

* Add the new generic infrastructure to allow using different protocols
to replicate state-changes, currently unicast UDP and multicast are
supported. Now you can add your favourite protocol to propagate
state-changes. An example of the multi-dedicated link over multicast
support:

# conntrackd -s link
multicast traffic device=eth3 status=RUNNING role=ACTIVE:
           129181080 Bytes sent            198577788 Bytes recv
              273376 Pckts sent               268759 Pckts recv
                   0 Error send                    0 Error recv

multicast traffic device=eth2 status=RUNNING role=BACKUP:
            42063284 Bytes sent             16864344 Bytes recv
               94980 Pckts sent                48778 Pckts recv
                   0 Error send                    0 Error recv

Another example, but using multi-dedicated link over UDP unicast:

# sudo conntrackd -s link
UDP traffic device=eth3 status=RUNNING role=ACTIVE:
                1160 Bytes sent                  336 Bytes recv
                 124 Pckts sent                   21 Pckts recv
                   0 Error send                    0 Error recv

UDP traffic device=eth2 status=RUNNING role=BACKUP:
                   0 Bytes sent                    0 Bytes recv
                   0 Pckts sent                    0 Pckts recv
                   0 Error send                    0 Error recv

BTW, although UDP and multicast are unreliable, using FT-FW mode
provides reliability.

* Some cleanups and one compilation fix for Gentoo and Fedora.

See changelog attached for more details.

Q: How stable are the conntrack-tools?
A: This software is under development. Nevertheless, it has been tested
in a cluster environment composed of two stateful firewalls running
Debian 4.0 (Etch) with a Linux kernel 2.6.28, keepalived 1.1.15, using
conntrackd in FT-FW mode, randomly (in periods of 10 seconds) setting
links down to force the fail-over between the nodes. The results has
shown no hangs/closure in any TCP connection.

Q: What are the conntrack-tools?
A: The conntrack-tools are:

- The userspace daemon so-called conntrackd that covers the specific
aspects of stateful Linux firewalls to enable high availability
solutions. It can be used as statistics collector of the firewall use as
well. The daemon is highly configurable and easily extensible.

- The command line interface (CLI) conntrack that provides an interface
to add, delete and update flow entries, list current active flows in
plain text/XML, current IPv4 NAT'ed flows, reset counters, and flush the
complete connection tracking table among many other.

Q: Where can I download it from?
A: http://www.netfilter.org/projects/conntrack-tools/downloads.html

Q: Where can I get more information about them?
A: http://conntrack-tools.netfilter.org

Q: Where can I have a look at the user manual?
A: http://conntrack-tools.netfilter.org/manual.html

On behalf of the Netfilter Project,
Pablo.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------000701020408040903050301
Content-Type: text/plain;
 name="changes-conntrack-tools-0.9.12.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="changes-conntrack-tools-0.9.12.txt"

Jan Engelhardt (1):
      build: add m4 directory

Pablo Neira Ayuso (25):
      src: fix compilation issue in gentoo due to missing include limits.h
      doc: fix broken link to ulogd2 in the manual
      extensions: remove use of old libnetfilter API flags
      src: remove debian/ directory
      sync-mode: rename mcast_send_sync() to sync_send()
      sync-mode: rename mcast_iface structure to interface
      sync-mode: add abstract layer to make daemon independent of multicast
      sync-mode: rename mcast_track_*() by nethdr_track_*()
      sync-mode: add unicast UDP support to propagate state-changes
      sync-mode: fix wrong output stats refering lost/malformed packets
      sync-mode: save one tab inside switch, cleanup
      sync-mode: cleanup reminiscent of multicast dependency
      mcast: mcast_send() takes a const pointer to buffer
      sync-mode: change `multicast' by `link' for `-s' option
      parse: fix broken destination port address translation
      udp: fix missing scope_id in the socket creation
      mcast: remove several unused structure fields
      config: obsolete `ListenTo' clause
      sync-mode: fix broken dedicated-link change in multichannel layer
      conntrack: fix missing bits in `-C' command
      conntrack: add `-S' command to display kernel statistics
      conntrack: remove broken command checking code
      doc: set nice to -20 in example config files
      config: cleanup error reporting during config file parsing
      build: bump version to 0.9.12


--------------000701020408040903050301--
