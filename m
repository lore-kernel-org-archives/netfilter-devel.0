From: "Mikael Starvik" <mikael.starvik@axis.com>
Subject: RE: Iptable loop during kernel startup
Date: Wed, 10 Jan 2007 13:58:11 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66803BEED34@exmail1.se.axis.com>
References: <BFECAF9E178F144FAEF2BF4CE739C668030B5907@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
	"Edgar Iglesias" <edgar.iglesias@axis.com>,
	"'Netfilter Development Mailinglist'"
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932796AbXAJM6X@vger.kernel.org>
To: "Mikael Starvik" <mikael.starvik@axis.com>,
	"'Patrick McHardy'" <kaber@trash.net>
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C668030B5907@exmail1.se.axis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Ok, this is what happens:

iptable_filter sets up initial_table.
The part that says { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" }
  initializes a xt_entry_target struct. target_size gets the value 
  0x24 and name "". 
This is copied to loc_cpu_entry in iptables.c:ipt_register_table() 
  and translate_table is called
translate_table calls IPT_ENTRY_ITERATE with the 
  check_entry_function
check_entry does t->u.kernel.target = target;

On this particular architecture u.user.name and u.kernel.target in 
struct xt_entry_target has the same address (because of the union). So 
name that was previously "" gets mangled here.

check_entry returns into translate_table which calls mark_source_chains
mark_source_chains compares t->target.u.user.name with 
IPT_STANDARD_TARGET. name has been mangled above and the comparision 
fails. On my ARM platform name has not been mangled (I guess this is 
because target and name doesn't share address by I haven't checked).

So... Is it really correct to modify the target pointer there?

/Mikael



-----Original Message-----
From: Mikael Starvik 
Sent: Wednesday, January 10, 2007 12:29 PM
To: 'Patrick McHardy'; Mikael Starvik
Cc: 'Linux Kernel Mailing List'; Edgar Iglesias; 'Netfilter Development
Mailinglist'
Subject: RE: Iptable loop during kernel startup


>Which iptables/kernel versions are you using?

2.6.19. After further testing it seams to be a compiler/CPU issue. The exact

same kernelconfig works on ARM. So I have to dig some...

/Mikael
