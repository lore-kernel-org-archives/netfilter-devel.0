From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: New tutorial on XDP
Date: Fri, 17 Mar 2017 09:17:38 -0400
Message-ID: <6089d01b-3eaa-00bc-17dc-0c0f48e395a8@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
To: people@netdevconf.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The tech committee would like to announce our first accepted tutorial

Monsieurs Andy Gospodarek and Jesper Dangaard Brouer will give an
XDP tutorial catered to mere mortals titled "XDP for the Rest of Us"

Description:
-----
XDP (eXpress Data Path) has been one of the most widely discussed topics 
for the last few netdev conferences. XDP is the Linux kernels
answer to operating at the same speeds as kernel bypass solutions
like DPDK. The typical use-case discussed for XDP is a large
datacenter or clustered environment, but XDP is obviously not limited
to those workloads. Since support for XDP now appears in multiple
network drivers (with more patches landing between the time of this
writing and the conference date) and is available on x86 and arm64
architectures, there now exists the possibility to allow a greater 
number of systems to benefit from this technology.

This tutorial will present an example/case-study where a tool such as
logtrigger or fail2ban will interact with an application and a BPF
program to make decisions to drop or allow certain packets early in
the packet processing step for enhanced DDoS prevention over
traditional methods.
Getting started using XDP, goes hand-in-hand with learning eBPF
(Extended Berkeley Packet Filter), as this is currently the XDP-hook
language. This tutorial will cover the process of writing/modifying a
simple BPF program, interacting with BPF maps in a programmatic manner,
and the potential performance benefit to early drop with XDP compared
to more traditional drop operations used on some embedded systems that
are placed much higher in the network stack.

Learning to use XDP can feel like a fairly steep learning curve, but
the goal of this tutorial is to make this process clear to kernel
developers, sysadmins, or anyone with DevOps responsibilities.
-------


cheers,
jamal
