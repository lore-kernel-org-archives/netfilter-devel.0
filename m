From: "Jan Kaastrup" <jka@protego.dk>
Subject: ip_conntrack_pptp
Date: Thu, 22 Jan 2004 16:57:26 +0100
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <003601c3e100$6e8a68c0$2d64a8c0@pcjka>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Netfilter Mailinglist'" <netfilter@lists.netfilter.org>
Return-path: <netfilter-admin@lists.netfilter.org>
To: "'Harald Welte'" <laforge@netfilter.org>,
	"'Netfilter Development Mailinglist'" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald and all on this list.

I have problems with ip_conntrack_pptp patch from POM-20031219

It seems the patch doesn't apply what it should:

"In the pptp-conntrack-nat.patch.configure.help it says something like
this:
CONFIG_IP_NF_CT_PROTO_GRE
  This module adds generic support for connection tracking and NAT of
the
  GRE protocol (RFC1701, RFC2784).  Please note that this will only work
  with GRE connections using the key field of the GRE header."

I do something like this for patching my kernel (2.4.21):
patch -p1 < ./path-o-mat.../ip_conntrack_pptp.patch, and everything
seems allright.

But I Never get the option in my kernelconfiguration - I want to make it
as a module.
I do have the ip_conntrack_pptp.c and .h file, maybe it is possible to
make my module out of them?


Does anyone know of this, or is it just me being stupid ?



Thanks a lot in regards

Jan
