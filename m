From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [RFC] matching tproxied packets
Date: Tue, 4 Jun 2002 16:50:36 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020604145036.GA1295@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Suppose you have a TCP session, which is transparently redirected to a local
proxy. With the current state of the tproxy framework one need to add two
rules to iptables:

- one to the tproxy table to actually redirect a session
- one to the filter table to let the NATed traffic enter the local stack (in
  INPUT)

I'd like to make tproxies easier to administer, so I'm thinking about a
simple way of matching tproxied packets, which can be ACCEPTed from the
INPUT chain.

Possible solutions:

* use a new state (called TPROXY), which would be applied to all TPROXYed
  packets (might interact badly with nat/conntrack).
* have the tproxy framework mark all packets with an fwmark, and let the
  packets in based on the value of fwmark
* have a separate match (called tproxy), which matches tproxied sessions
  based on some value stored in the associated conntrack entry

which one do you prefer?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
