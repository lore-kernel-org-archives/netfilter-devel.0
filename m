From: Alexandre Becoulet <alexandre.becoulet@epita.fr>
Subject: [new filter] simple packet authentication
Date: Thu, 22 Jan 2004 22:04:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401222204.04861.alexandre.becoulet@epita.fr>
Reply-To: alexandre.becoulet@epita.fr
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi,

I have written a new extension to the netfilter project and i would
like to contribute. 

My extension provides both, a new target to mangle packets and a new
match rule.

The idea is to have a non obvious relationship between the IP id field
and the TCP header informations. This relationship may then be used to
authenticate packets sender.

The mangle part of the module is used to recalculate a new value for
the id field of IP packet header. This new value is based on a hash
value computed from the TCP sequence numbers and an optional
passphrase. Of course we have to take care not to mangle already
fragmented packets to keep all IP fragments with the same id.

The match part of the module is able to check the IP id field against
the locally recomputed hash value, so we may reject packets without
correct id field value.

This simple authentication system may be a good mean to avoid TCP ports
scanning and to prevent non authorized people from connecting to ports that
still have to remain open for admin access.

This method should be safer than matching host IP address to allow
connection, it will allow connections from any host IP having the good
passphrase and should prevent connections from spoofed/stolen IP
addresses. It aims to be more simple than heavy packets authentication
methods and leave TCP/IP packet format untouched.

My implementation use a trivial hash function to remain simple and
fast. The hash function could be replaced with a stronger digest
algorithm like those provided in the kernel crypto API.

Here is an example to show how to do simple authentication for
incoming connections on tcp port 22:

 # Server side
 iptables -A INPUT -p tcp --syn -m hashseq --key testkey -j ACCEPT
 iptables -A INPUT -p tcp --syn --dport 22 -j REJECT

 # Client side
 iptables -t mangle -A OUTPUT -p tcp --syn --dport 22 -j HASHSEQ \
          --key testkey

I hope my work will be of some interest. :)

I just followed instructions given in the patch-o-matic README file for the 
netfilter part. Where should i send/post my full netfilter and iptables 
extentions patchs ?

Regards,

-- 
Alexandre Becoulet
