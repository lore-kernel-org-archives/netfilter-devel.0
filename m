From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [RFC] unidirectional NAT
Date: Wed, 5 Jun 2002 11:36:50 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020605093650.GA9723@balabit.hu>
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

First of all, thanks for the feedback on my tproxy patches. It generally
works well for TCP based connections, what I'm up to now is proper support
for UDP.

The problem with datagram based protocols is that connection tracking (at
least in my case involving Zorp) and address translation is done by the
userspace proxy.

The only features for an UDP proxy is the following:
* being able to receive frames originally destined elsewhere (the REDIRECT
  case)
* being able to receive frames from an arbitrary host, originally destined
  to another arbitrary host (the foreign address listen case)
* being able to send frames using an arbitrary source IP/address, to an
  arbitrary host (the foreign connect case)

I use the NAT framework to redirect packets to the local stack, but as a
sideeffect NAT translates replies as well. 

Now I don't want reply translation :), that's why the subject unidirectional
NAT, which would mean to translate packets in only one direction. (to be
honest the best would be to translate a single packet only)

I'm thinking about two possibilities:

* yet another flag to ip_nat_setup_info() to set up a single manip only. 
* free the state associated to UDP packets after the translation was applied.
* instead of setting up a NAT translation, call manip_pkt() directly somehow

Ideas?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
