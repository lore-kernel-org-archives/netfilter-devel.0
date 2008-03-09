From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnfnetlink release 0.0.33
Date: Sun, 09 Mar 2008 02:07:40 +0100
Message-ID: <47D3385C.40605@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070506080206000307060303"
Cc: lwn@lwn.net
To: netfilter-announce@lists.netfilter.org, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070506080206000307060303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents libnfnetlink 0.0.33. This release
includes minor bugfixes and updates. Changelog attached.

libnfnetlink is the low-level library for netfilter related
kernel/userspace communication. It provides a generic messaging
infrastructure for in-kernel netfilter subsystems (such as
nfnetlink_log, nfnetlink_queue, nfnetlink_conntrack) and their
respective users and/or management tools in userspace.

You can download it from:

http://www.netfilter.org/projects/libnfnetlink/downloads.html

Pablo (on behalf of the Netfilter Project)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------070506080206000307060303
Content-Type: text/plain;
 name="Changelog"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Changelog"

- nfnl_handle must be const in nfnl_rcvbufsiz
	[ Pablo Neira Ayuso ]

- Introduce nfnl_set_rcv_buffer_size to set the receive buffer size
	[ Pablo Neira Ayuso ]

- Improve receive path performance: do only one recv instead of two
	[ Pablo Neira Ayuso ]

- Fix endless loop on unknown netfilter attributes.
	[ Marcus Sundberg ]

- Fix handling of multipart netlink packets in nfnl_handle_packet
	[ Eric Leblond ]

--------------070506080206000307060303--
