From: "Krishna N. Ramachandran" <krishna@cs.ucsb.edu>
Subject: new match for PIM
Date: Sun, 9 Mar 2003 12:05:11 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.21.0303091201140.23610-100000@ella>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hi Developers, 
    I am trying to create a new match module for PIM (protocol independant
multicast), a protocol used for multicast tree creation. 

    I am relatively new to the world of module development. I am running
into problems with insmoding my new module ...

net/ipv4/netfilter/ipt_pim.o: unresolved symbol ipt_register_match
net/ipv4/netfilter/ipt_pim.o: unresolved symbol ipt_unregister_match

I wonder if there is any documentation out there that gives the exact
options to include for compiling a netfilter module.

Thank you,
Krishna
