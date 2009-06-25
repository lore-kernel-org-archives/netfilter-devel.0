From: Ritesh Majumdar <r.majumdar@globallogic.com>
Subject: iptables ERROR
Date: Thu, 25 Jun 2009 18:26:51 +0530
Message-ID: <1245934611.4518.58.camel@ripper.synapse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello List,

I have recently added ipset code in to my kernel, so all the ipset
ralated ko's can be compiled while I compile kernel.
my compilation works fine and I can add ipset rules successfully.
but when I add iptables rules to macth specific set I get error.

Here is what I am trying to do.

=EF=BB=BF

ipset -N a_ipset iphash=20
iptables -N a=20
iptables -N b=20
iptables -A a -p udp -m set --set a_ipset dst -j b=20





when I try to add the last rule,(=EF=BB=BFiptables -A a -p udp -m set -=
-set
a_ipset dst -j b)  it fails with the error as below.

iptables: Invalid argument



I am not sure if its ipset issue or iptables.

I am using "kernel 2.6.27" "ipset-2.4.9" and "iptables-1.4.1.91"


Many Thanks.
Ritesh.

