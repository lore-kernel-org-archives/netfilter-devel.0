From: Matthias Dettling <m-dettling@gmx.de>
Subject: where is the right entry point for matching a tracked related connection?
Date: Thu, 27 May 2004 01:47:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B52C94.20008@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello developers,

I am searching the right place in my linux kernel source (v 2.4.26) for 
extending the iptables command to match in a packet "RELATED" to a 
specific connection, informations that were tracked before.

In detail I want to use this for a FTP-connection.
My aim is to open a FTP control-connection on port 21 in passive mode. 
In the so opened channel, the port for the real data transfer is 
negotiated. This negotiated connection is tracked by the 
ftp-helper-module and is allowed, because it corresponds to the related 
connection on port 21 (FW-Rule: "iptables -A INPUT -p tcp --sport 1024: 
--dport 1024: -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT").

But there is no possibility to test wheter the related connection is 
really on port 21.
So I want to modify the matching module "conntrack" (ipt_conntrack.c) 
written by Marc Boucher to do so.

The thing i should know for doing this, is how i can get access to the 
information of a tracked "RELATED" connection.
After reading the hacking-howto i thought that access is gained through 
the pointer "nfct" of the "sk_buff" structure, but with this i can't 
find anywhere port informations of the originating packet (of the 
related connection).
Can somebody help me?

best regards

M. Dettling
