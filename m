From: "rruegner" <robowarp@gmx.de>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Wed, 25 Feb 2004 20:31:47 +0100
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <001101c3fbd6$0310ed80$32640a0a@robopc>
References: <20040225182828.GP13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Mailinglist" <netfilter@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@netfilter.org>,
	"Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

do you mean something like this ?
fresh 2.6.3 kernel with patch-o-matic-ng-20040224

Welcome to Patch-o-matic (1.13)!

Kernel:         /usr/src/linux
Iptables:       /usr/src/iptables

Each patch is a new feature: many have minimal impact, some do not.
Almost every one has bugs, so don't apply what you don't need!
-------------------------------------------------------
Already applied:

Not all requirements fulfilled for quake3-conntrack-nat, skipping:
 requirement 'linux < 2.6.0' not fulfilled

Excellent! Source trees are ready for compilation.

your rewrite seems to work , but the h323 which i could compile in the past
was rejected too
is this current state of art ?
Regards Robert
----- Original Message ----- 
From: "Harald Welte" <laforge@netfilter.org>
To: "Netfilter Development Mailinglist"
<netfilter-devel@lists.netfilter.org>
Cc: "Netfilter Mailinglist" <netfilter@lists.netfilter.org>
Sent: Wednesday, February 25, 2004 7:28 PM
Subject: [ANNOUNCE] call for testing of patch-o-matic-ng
