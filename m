From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: TCP Reset to destination instead of source.
Date: Fri, 13 Jul 2007 10:22:55 -0400
Message-ID: <20070713142255.GB4848@ti88.telemetry-investments.com>
References: <46978445.10500@one.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Adam Hasselbalch Hansen <ahh@one.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46978445.10500@one.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Thoughts are appreciated.

http://www.lowth.com/cutter/

Summary

Network security administrators sometimes need to be able to abort
TCP/IP connections routed over their firewalls on demand. This would
allow them to terminate connections such as SSH tunnels or VPNs left
in place by employees over night, abort hacker attacks when they are
detected, stop high bandwidth consuming downloads - etc. There are many
potential applications.

This article describes how a Linux IPTables based firewall/router can
be used to send the right combination of TCP/IP packets to both ends of
a connection to cause them to abort the conversation. It describes the
steps required to perform this task, and introduces a new open-source
utility called "cutter" that automates the process.

...


Regards,

	Bill Rugolsky
