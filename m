From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ANNOUNCE] libnetfilter_log 0.0.16 release
Date: Fri, 06 Mar 2009 18:10:02 +0100
Message-ID: <49B158EA.8080908@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060505090405080800000203"
Cc: netfilter-announce@lists.netfilter.org,
	netfilter-devel@vger.kernel.org, lwn@lwn.net
To: netfilter@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060505090405080800000203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi!

The netfilter project proudly presents:

  * libnetfilter_log-0.0.16

libnetfilter_log is a userspace library providing interface to packets
that have been logged by the kernel packet filter. It is is part of a
system that deprecates the old syslog/dmesg based packet logging.

ChangeLog of this release is attached. You can get this library from:

http://www.netfilter.org/projects/libnetfilter_log/downloads.html
ftp://ftp.netfilter.org/pub/libnetfilter_log

Regards,
Pablo

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers


--------------060505090405080800000203
Content-Type: text/plain;
 name="ChangeLog-libnetfilter_log-0.0.16"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ChangeLog-libnetfilter_log-0.0.16"

Eric Leblond (3):
      Fix minor memory leak in nflog_close().
      Suppress reference to libnetfilter_queue which is the model of libnetfilter_log.
      Suppress NFULNL_MSG_CONFIG callback registration.

Pablo Neira Ayuso (2):
      nflog: replace nfnl_talk by nfnl_query and disable sequence tracking
      build: bump version to 0.0.16


--------------060505090405080800000203--
