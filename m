From: Simon Huet <sh@numlog.fr>
Subject: VM bridged : NAT not done twice
Date: 21 Jan 2003 16:00:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1043161206.32497.36.camel@pcsh.numlog.priv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi folks,

I am using some user-mode-linux VM to build a bridge firewall/routing
device.

     ________________________
    |                        |
    |          HOST          |
    |      ____________      |
    |     |            |     |
    |     |   UML VM   |     |
    |     |            |     |
---[ ]===[ ]-        -[ ]===[ ]---
eth0|     |eth0    eth1|     |eth1 
    |     |            |     |
    |     |____________|     |
    |                        |
    |                        |
    |________________________|
 

Everything is fine except for any SNAT rules. They are applyied on each
the host ethernet interface.

When packets are coming from one host interface, going through the VM
and coming out on the other host interface the SNAT rules are not
applied which is not the case when they are originating from the VM.

Obviously, POSTROUTING is already done on those packets and it will not
be done twice.

Is there a way to mangle each packets in order to let netfilter think
those packets are new? Does someone knows way to do that? Or does
someone could tell me where I should start hacking code?

Thanks in advance.

---------------------------
 Simon HUET [sh@numlog.fr]
---------------------------
NUMLOG
23, rue des Poiriers
78370 Plaisir
TEL : 01 30 79 16 16
WWW : http://www.numlog.fr/
---------------------------
